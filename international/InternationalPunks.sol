pragma solidity ^0.8.0;

contract  InternationalPunks  is ERC721Enumerable, Ownable
{
    using SafeMath for uint256;
    using Address for address;
    using Strings for uint256;

    uint public constant _TOTALSUPPLY =10000;
    uint public maxQuantity =50;
    uint256 public price = 0.01 ether;
    bool public isPaused = true;
    uint public reserve = 100;
    mapping(address => bool) public _userExist;

    constructor(string memory baseURI) ERC721("International Punks", "INTPUNKS")  {
        setBaseURI(baseURI);
    }
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseURI = baseURI;
    }

    function setPrice(uint256 _newPrice) public onlyOwner() {
        price = _newPrice;
    }
    function setMaxxQtPerTx(uint256 _quantity) public onlyOwner {
        maxQuantity=_quantity;
    }
     function setReserveTokens(uint256 _quantity) public onlyOwner {
        reserve=_quantity;
    }



    modifier isSaleOpen{
        require(totalSupply() < _TOTALSUPPLY, "Sale end");
        _;
    }
    function flipPauseStatus() public onlyOwner {
        isPaused = !isPaused;
    }
    function getPrice(uint256 _quantity) public view returns (uint256) {

           return _quantity*price ;
     }
     function reserveTokens(uint quantity) public onlyOwner {
        require(totalSupply()>=200,"Total supply is less than 200");
        uint supply = totalSupply();
        require(quantity <= reserve, "The quantity exceeds the reserve.");
        reserve -= quantity;
        for (uint i = 0; i < quantity; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function mint(uint chosenAmount) public payable isSaleOpen{
        require(isPaused == false, "Sale is not active at the moment");
        require(totalSupply()+chosenAmount<=_TOTALSUPPLY,"Quantity must be lesser then MaxSupply");
        require(chosenAmount > 0, "Number of tokens can not be less than or equal to 0");
        require(chosenAmount <= maxQuantity,"Chosen Amount exceeds MaxQuantity");
        if (totalSupply()>=200)
        {

        require(price.mul(chosenAmount) == msg.value, "Sent ether value is incorrect");
        for (uint i = 0; i < chosenAmount; i++) {
            _safeMint(msg.sender, totalSupply());
            }
        }
        else
        {
            require(!_userExist[msg.sender],"User already Exist");
            require(chosenAmount==1,"amount is greater than 1");
            require(msg.value==0,"First 200 tokens are free");
            _safeMint(msg.sender,totalSupply());
            _userExist[msg.sender]=true;
        }


    }

    function tokensOfOwner(address _owner) public view returns (uint256[] memory)
    {
        uint256 count = balanceOf(_owner);
        uint256[] memory result = new uint256[](count);
        for (uint256 index = 0; index < count; index++) {
            result[index] = tokenOfOwnerByIndex(_owner, index);
        }
        return result;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}