
// File: contracts/HDPunks.sol


pragma solidity ^0.8.0;



contract HDPunks is Ownable, ERC721 {

    event Mint(address indexed to, uint indexed _punkId);

    PunksContract public PUNKS = PunksContract(0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB);
    WrapperContract public WRAPPER = WrapperContract(0xb7F7F6C52F2e2fdb1963Eab30438024864c313F6);
    uint public constant TOKEN_LIMIT = 10000;

    uint public numTokens = 0;
    uint public _mintFee = 0.08 ether;
    bool public _publicMinting = false;
    string public _baseTokenURI;
    string public imageHash; // MD5 hash of the megaimage (100k x 100k pixels) containing 10000 punks

    // Random index assignment
    uint internal nonce = 0;
    uint[TOKEN_LIMIT] internal indices;

    constructor() payable ERC721("HD Punks", "HDPUNKS") {}

    /**
     * @dev Mint several HD Punks in a single transaction. Used in presale minting.
     */
    function mintMany(uint[] calldata _punkIds, address to) external payable {
        // Take mint fee
        require(msg.value >= _punkIds.length * mintFee() || to == owner(), "Please include mint fee");
        for (uint i = 0; i < _punkIds.length; i++) {
            _mint(_punkIds[i], to, true);
        }
    }

    /**
     * @dev Mint one HD Punk, same functionality as mintMany. Used in presale minting.
     */
    function mint(uint _punkId, address to) external payable {
        // Take mint fee
        require(msg.value >= mintFee() || to == owner(), "Please include mint fee");
        _mint(_punkId, to, true);
    }

    /**
     * @dev Mint `quantity` HDPunks, but chosen randomly. Used in public minting.
     */
    function mintRandom(address to, uint quantity) external payable {
        require(_publicMinting || to == owner(), "Wait for public minting");
        require(msg.sender == tx.origin, "No funny business");
        require(msg.value >= quantity * mintFee() || to == owner(), "Please include mint fee");
        // TODO: Check that randomness works well
        for (uint i = 0; i < quantity; i++) {
            _mint(randomIndex(), msg.sender, false);
        }
    }

    /**
     * @dev Checks validity of the mint, but not the mint fee.
     */
    function _mint(uint _punkId, address to, bool requireIsOwner) internal {
        // Check if token already exists
        require(!_exists(_punkId), "HDPunk already minted");
        overwriteIndex(_punkId);

        if (requireIsOwner) {
            address punkOwner = PUNKS.punkIndexToAddress(_punkId);
            if (punkOwner == address(WRAPPER)) {
                punkOwner = WRAPPER.ownerOf(_punkId);
            }
            require(to == punkOwner || to == owner(), "Only the owner can mint");
        } else {
            require(_publicMinting || to == owner(), "Public minting not open");
        }

        _mint(to, _punkId);
        numTokens += 1;
        emit Mint(to, _punkId);
    }

    function randomIndex() internal view returns (uint) {
        uint totalSize = TOKEN_LIMIT - numTokens;
        uint index = uint(keccak256(abi.encodePacked(nonce, msg.sender, block.difficulty, block.timestamp))) % totalSize;
        uint value = 0;
        if (indices[index] != 0) {
            value = indices[index]; // If index taken, see what it points to
        } else {
            value = index;
        }

        // Use zero-indexing
        return value;
    }

    function overwriteIndex(uint index) internal {
        uint totalSize = TOKEN_LIMIT - numTokens;
        // Move last value to selected position
        if (indices[totalSize - 1] == 0) {
            // Array position not initialized, so use position
            indices[index] = totalSize - 1;
        } else {
            // Array position holds a value so use that
            indices[index] = indices[totalSize - 1];
        }
        nonce += 1;
    }

    /**
     * @dev Returns the current minting fee
     */
    function mintFee() public view returns (uint) {
        return _mintFee;
    }

    function setMintFee(uint256 __mintFee) public onlyOwner {
        _mintFee = __mintFee;
    }

    /**
     * @dev Withdraw the contract balance to the dev address
     */
    function withdraw() public {
        uint amount = address(this).balance;
        (bool success,) = owner().call{value: amount}("");
        require(success, "Failed to send ether");
    }

    /**
     * @dev Withdraw ERC20 tokens from the contract
     */
    function withdrawFungible(address _tokenContract) public {
      IERC20 token = IERC20(_tokenContract);
      uint256 amount = token.balanceOf(address(this));
      token.transfer(owner(), amount);
    }

    /**
     * @dev Withdraw ERC721 tokens from the contract
     */
    function withdrawNonFungible(address _tokenContract, uint256 _tokenId) public {
        IERC721(_tokenContract).transferFrom(address(this), owner(), _tokenId);
    }

    /**
     * @dev Returns a URI for a given token ID's metadata
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
    }

    /**
     * @dev Updates the base token URI for the metadata
     */
    function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
        _baseTokenURI = __baseTokenURI;
    }

    /**
     * @dev Turn public minting on or off
     */
    function setPublicMinting(bool _val) public onlyOwner {
        _publicMinting = _val;
    }

    /**
     * @dev Set image hash
     */
    function setImageHash(string memory _imageHash) public onlyOwner {
        imageHash = _imageHash;
    }

}

