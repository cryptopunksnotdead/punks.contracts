pragma solidity ^0.8.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/security/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/security/ReentrancyGuard.sol";
import "./library/AdminControl.sol";



/**
 * @title PunksMarket contract
 * @author @FrankPoncelet
 *
 */
contract PunksMarket is AdminControl, Pausable , ReentrancyGuard{

    IERC721 public punksWrapperContract; // instance of the Cryptopunks contract
    ICryptoPunk public punkContract; // Instance of cryptopunk smart contract

    struct Offer {
        bool isForSale;
        uint punkIndex;
        address seller;
        uint256 minValue;          // in WEI
        address onlySellTo;
    }

    struct Bid {
        bool hasBid;
        uint punkIndex;
        address bidder;
        uint256 value;
    }

    struct Punk {
        bool wrapped;
        address owner;
        Bid bid;
        Offer offer;
    }

    // keep track of the totale volume processed by this contract.
    uint256 public totalVolume;
    uint constant public TOTAL_PUNKS = 10000;

    // A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
    mapping (uint => Offer) private punksOfferedForSale;

    // A record of the highest punk bid
    mapping (uint => Bid) private punkBids;

    event PunkOffered(uint indexed punkIndex, uint minValue, address indexed toAddress);
    event PunkBidEntered(uint indexed punkIndex, uint value, address indexed fromAddress);
    event PunkBidWithdrawn(uint indexed punkIndex, uint value, address indexed fromAddress);
    event PunkBought(uint indexed punkIndex, uint value, address indexed fromAddress, address indexed toAddress);
    event PunkNoLongerForSale(uint indexed punkIndex);

    /*
    * Initializes contract with an instance of CryptoPunks Wrapper contract
    */
    constructor() {
        punksWrapperContract = IERC721(0x282BDD42f4eb70e7A9D9F40c8fEA0825B7f68C5D); // TODO change on deploy main net
        punkContract = ICryptoPunk(0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D); // TODO change on deploy main net
    }

    /* Allows the owner of the contract to set a new Cryptopunks WRAPPER contract address */
    function setPunksWrapperContract(address newpunksAddress) public onlyOwner {
      punksWrapperContract = IERC721(newpunksAddress);
    }

    /* Allows the owner of a CryptoPunks to stop offering it for sale */
    function punkNoLongerForSale(uint punkIndex) public nonReentrant() {
        require(punkIndex < 10000,"Token index not valid");
        require(punksWrapperContract.ownerOf(punkIndex) == msg.sender,"you are not the owner of this token");
        punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, address(0x0));
        emit PunkNoLongerForSale(punkIndex);
    }

    /* Allows a CryptoPunk owner to offer it for sale */
    function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) public whenNotPaused nonReentrant()  {
        require(punkIndex < 10000,"Token index not valid");
        require(punksWrapperContract.ownerOf(punkIndex) == msg.sender,"you are not the owner of this token");
        punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, address(0x0));
        emit PunkOffered(punkIndex, minSalePriceInWei, address(0x0));
    }

    /* Allows a Cryptopunk owner to offer it for sale to a specific address */
    function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) public whenNotPaused nonReentrant() {
        require(punkIndex < 10000,"Token index not valid");
        require(punksWrapperContract.ownerOf(punkIndex) == msg.sender,"you are not the owner of this token");
        punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, toAddress);
        emit PunkOffered(punkIndex, minSalePriceInWei, toAddress);
    }


    /* Allows users to buy a Cryptopunk offered for sale */
    function buyPunk(uint punkIndex) payable public whenNotPaused nonReentrant() {
        require(punkIndex < 10000,"Token index not valid");
        Offer memory offer = punksOfferedForSale[punkIndex];
        require (offer.isForSale,"Punk is not for sale"); // punk not actually for sale
        require (offer.onlySellTo == address(0x0) || offer.onlySellTo == msg.sender,"Private sale.") ;
        require (msg.value >= offer.minValue,"Not enough ether send"); // Didn't send enough ETH
        address seller = offer.seller;
        require  (seller == punksWrapperContract.ownerOf(punkIndex),'seller no longer owner of punk'); // Seller no longer owner of punk

        punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, address(0x0));
        _withdraw(seller,msg.value);
        totalVolume += msg.value;
        punksWrapperContract.safeTransferFrom(seller, msg.sender, punkIndex);

        emit PunkBought(punkIndex, msg.value, seller, msg.sender);

        // Check for the case where there is a bid from the new owner and refund it.
        // Any other bid can stay in place.
        Bid memory bid = punkBids[punkIndex];
        if (bid.bidder == msg.sender) {
            // Kill bid and refund value
            _withdraw(msg.sender,bid.value);
            punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
        }
    }
    /* Allows users to enter bids for any Cryptopunk */
    function enterBidForPunk(uint punkIndex) payable public whenNotPaused nonReentrant() {
        require(punkIndex < 10000,"Token index not valid");
        require (punksWrapperContract.ownerOf(punkIndex) != msg.sender,"You already own this punk");
        require (msg.value > 0,"Cannot enter bid of zero");
        Bid memory existing = punkBids[punkIndex];
        require (msg.value > existing.value,"your bid is too low");
        if (existing.value > 0) {
            // Refund the failing bid
            _withdraw(existing.bidder,existing.value);
        }
        punkBids[punkIndex] = Bid(true, punkIndex, msg.sender, msg.value);
        emit PunkBidEntered(punkIndex, msg.value, msg.sender);
    }

    /* Allows Cryptopunk owners to accept bids for their punks */
    function acceptBidForPunk(uint punkIndex, uint minPrice) public whenNotPaused nonReentrant() {
        require(punkIndex < 10000,"Token index not valid");
        require(punksWrapperContract.ownerOf(punkIndex) == msg.sender,'you are not the owner of this token');
        address seller = msg.sender;
        Bid memory bid = punkBids[punkIndex];
        require(bid.hasBid == true,"Punk has no bid");
        require (bid.value >= minPrice,"The bid is too low");

        address bidder = bid.bidder;
        punksOfferedForSale[punkIndex] = Offer(false, punkIndex, bidder, 0, address(0x0));
        uint amount = bid.value;
        punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);

        _withdraw(seller,amount);
        totalVolume += amount;
        punksWrapperContract.safeTransferFrom(msg.sender, bidder, punkIndex);

        emit PunkBought(punkIndex, bid.value, seller, bidder);
    }

    /* Allows bidders to withdraw their bids */
    function withdrawBidForPunk(uint punkIndex) public nonReentrant() {
        require(punkIndex < 10000,"token index not valid");
        Bid memory bid = punkBids[punkIndex];
        require (bid.bidder == msg.sender,"The bidder is not message sender");
        emit PunkBidWithdrawn(punkIndex, bid.value, msg.sender);
        uint amount = bid.value;
        punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
        // Refund the bid money
        _withdraw(msg.sender,amount);
    }

    ///////// Website only methods ////////////
    function getBid(uint punkIndex) external view returns (Bid memory){
        return punkBids[punkIndex];
    }

    function getOffer(uint punkIndex) external view returns (Offer memory){
        return punksOfferedForSale[punkIndex];
    }

    /**
    * Returns offer, bid and owner data for a specific punk.
    */
    function getPunksDetails(uint index) external view returns (Punk memory) {
            address owner = punkContract.punkIndexToAddress(index);
            bool wrapper = false;
            if (owner==address(punksWrapperContract)){
                owner = punksWrapperContract.ownerOf(index);
                wrapper = true;
            }
            Punk memory punks=Punk(wrapper,owner,punkBids[index],punksOfferedForSale[index]);
        return punks;
    }

    /**
    * Returns the id's of all wrapped punks.
    */
    function getAllWrappedPunks() external view returns (int[] memory){
        int[] memory ids = new int[](TOTAL_PUNKS);
        for (uint i=0; i<TOTAL_PUNKS; i++) {
            ids[i]= 11111;
        }
        uint256 j =0;
        for (uint256 i=0; i<TOTAL_PUNKS; i++) {
            if ( punkContract.punkIndexToAddress(i) == address(punksWrapperContract)) {
                ids[j] = int(i);
                j++;
            }
        }
        return ids;
    }

    /**
    * Returns the id's of the UNWRAPPED punks for an address
    */
    function getPunksForAddress(address user) external view returns(uint256[] memory) {
        uint256[] memory punks = new uint256[](punkContract.balanceOf(user));
        uint256 j =0;
        for (uint256 i=0; i<TOTAL_PUNKS; i++) {
            if ( punkContract.punkIndexToAddress(i) == user ) {
                punks[j] = i;
                j++;
            }
        }
        return punks;
    }

    /**
    * Returns the id's of the WRAPPED punks for an address
    */
    function getWrappedPunksForAddress(address user) external view returns(uint256[] memory) {
        uint256[] memory punks = new uint256[](punksWrapperContract.balanceOf(user));
        uint256 j =0;
        for (uint256 i=0; i<TOTAL_PUNKS; i++) {
            try punksWrapperContract.ownerOf(i) returns (address owner){
                if ( owner == user ) {
                    punks[j] = i;
                    j++;
                }
            } catch {
                // ignore
            }
        }
        return punks;
    }

    ////////// safe withdraw method //////////
    function _withdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{ value: _amount }("");
        require(success, "Failed to send Ether");
    }

    ////////// Contract safety, emergency methods////////
    /**
    * Allow the CONTRACT owner/admin to return a bid.
    */
    function returnBid(uint punkIndex) public adminRequired {
        Bid memory bid = punkBids[punkIndex];
        uint amount = bid.value;
        address bidder = bid.bidder;
        punkBids[punkIndex] = Bid(false, punkIndex, address(0x0), 0);
        emit PunkBidWithdrawn(punkIndex, amount, bidder);
        _withdraw(bidder,amount);
    }
    /**
    * Allow the CONTRACT owner/admin to END an offer.
    */
    function revokeSale(uint punkIndex) public adminRequired {
        require(punkIndex < 10000,"Token index not valid");
        punksOfferedForSale[punkIndex] = Offer(false, punkIndex, address(0x0), 0, address(0x0));
        emit PunkNoLongerForSale(punkIndex);
    }

    /////////// pause methods /////////////
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    ///////// contract can recieve Ether if needed//////
    fallback() external payable { }
    receive() external payable { }

}
