// File: contracts/PunksV1Wrapper.sol

contract PunksV1Wrapper is Ownable, ERC721 {

    event Wrapped(uint indexed _punkId, address indexed owner);
    event Unwrapped(uint indexed _punkId, address indexed owner);

    address payable public punkAddress = payable(0x6Ba6f2207e343923BA692e5Cae646Fb0F566DB8D);
    string public _baseTokenURI;

    constructor() payable ERC721("Wrapped CryptoPunks V1", "WPUNKS1") {}

    /**
     * @dev Accepts an offer from the punks contract and assigns a wrapped token to msg.sender
     */
    function wrap(uint _punkId) public payable {
        // Prereq: owner should call `offerPunkForSaleToAddress` with price 0 (or higher if they wish)
        (bool isForSale, , address seller, uint minValue, address onlySellTo) = PunksV1Contract(punkAddress).punksOfferedForSale(_punkId);
        require(isForSale == true);
        require(seller == msg.sender);
        require(minValue == 0);
        require((onlySellTo == address(this)) || (onlySellTo == address(0x0)));
        // Buy the punk
        PunksV1Contract(punkAddress).buyPunk{value: msg.value}(_punkId);
        // Mint a wrapped punk
        _mint(msg.sender, _punkId);
        Wrapped(_punkId, msg.sender);
    }

    /**
     * @dev Burns the wrapped token and transfers the underlying punk to the owner
     **/
    function unwrap(uint256 _punkId) public {
        require(_isApprovedOrOwner(msg.sender, _punkId));
        _burn(_punkId);
        PunksV1Contract(punkAddress).transferPunk(msg.sender, _punkId);
        Unwrapped(_punkId, msg.sender);
    }

    /**
     * @dev Returns a URI for a given token ID's metadata
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
    }

    function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
        _baseTokenURI = __baseTokenURI;
    }
}

