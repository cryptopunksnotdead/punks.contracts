
contract ExpansionPhunks is ERC1155, Ownable {
    string public constant name = "ExpansionPhunks";
    string public constant symbol = "PHUNX";

    uint32 public totalSupply = 0;
    uint256 public constant phunkPrice = 0.02 ether;
    uint256 public constant bulkPrice = 0.015 ether;

    uint32 public saleStart = 1640894400;
    uint32 public constant startSupply = 10000;
    uint32 public maxSupply = 10000;

    address private wallet1 = 0xD44F85aA20b03cc773309f10d67cC4eaB0BD26a6;
    address private wallet2 = 0xB9e1cc664a0140953c2512f57BCd36Bb92c2eEf6;

    constructor(string memory uri) ERC1155(uri) {}

    function setURI(string memory uri) public onlyOwner {
        _setURI(uri);
    }

    function setSaleStart(uint32 timestamp) public onlyOwner {
        saleStart = timestamp;
    }

    function saleIsActive() public view returns (bool) {
        return saleStart <= block.timestamp;
    }

    function setMaxSupply(uint32 _supply) public onlyOwner {
        maxSupply = _supply;
    }

    function mint(address to, uint32 count) internal {
        if (count > 1) {
            uint256[] memory ids = new uint256[](uint256(count));
            uint256[] memory amounts = new uint256[](uint256(count));

            for (uint32 i = 0; i < count; i++) {
                ids[i] = startSupply + totalSupply + i;
                amounts[i] = 1;
            }

            _mintBatch(to, ids, amounts, "");
        } else {
            _mint(to, startSupply + totalSupply, 1, "");
        }

        totalSupply += count;
    }

    function purchase(uint32 count) external payable {
        require(saleIsActive(), "Sale inactive");
        require(count > 0, "Count must be greater than 0");
        require(count < 51, "Count must be less than or equal to 50");
        require(totalSupply + count <= maxSupply, "Exceeds max supply");

        if (count > 9) {
            require(msg.value >= bulkPrice * count, "Insufficient funds");
        } else {
            require(msg.value >= phunkPrice * count, "Insufficient funds");
        }

        mint(msg.sender, count);
    }

    function teamMint(uint32 count) external onlyOwner {
        require(totalSupply + count <= maxSupply, "Exceeds max supply");
        mint(msg.sender, count);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        uint256 balance1 = balance * 85 / 100;
        uint256 balance2 = balance * 10 / 100;
        uint256 balance3 = balance * 5 / 100;

        payable(wallet1).transfer(balance1);
        payable(wallet2).transfer(balance2);
        payable(msg.sender).transfer(balance3);
    }
}