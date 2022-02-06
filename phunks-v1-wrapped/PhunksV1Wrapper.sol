// File: contracts/PhunksV1Wrapper.sol



pragma solidity ^0.8.0;



contract PhunksV1Wrapper is Ownable, ERC721, IERC721Receiver {
    using Strings for uint256;

    CryptoPhunksV1Interface public immutable phunkContract;

    string private _baseTokenURI;
    string private _baseTokenImageURI;
    uint256 private _tokenSupply;

    // I tried to mimic the Wrapped V1 Punk (0x282bdd42f4eb70e7a9d9f40c8fea0825b7f68c5d) description
    // as closely as possible. Taken as a whole, this project presents some conceptual ambiguity
    // as to whether it is a wrapping of the V1 Phunks or a flipping of the wrapped V1 Punks.
    // This is intentional.
    string public constant contractDescription = "V1 Phunks are the original NFT set of the well known CryptoPhunks NFT set released in 2021. However, due to various misunderstandings about the nature of conceptual art, the tokens were deemed non-tradable in their original form by OpenSea after it was discovered that when someone bought these Phunks, they also got the artwork of the associated CryptoPunk, effectively acquiring the NFT at no cost!\\n\\nV1 Phunk owners are now able to wrap their Phunks into an ERC-721 contract and patch over the issue where every Phunk image is Philip the Intern. This recovery of the original Phunks smart contract is a community led and rapidly growing phenomenon consisting of one person. There is no clear leader and all important decisions are voted on by community members.\\n\\nV1 Phunks are not a derivative, but are in fact the original set of Phunks released in 2021 (and actually predate the release of CryptoPhunks NFTs). This is verified on the Ethereum blockchain and is immutable.";

    // The image of Philip in the V1 metadata is hosted on S3! Let's put him on IPFS for safety.
    // Someday I hope to upload his likeness to the blockchain itself in SVG form.
    // However this is out of scope for the current project.
    string public constant philipImageURI = "ipfs://QmbGgTwzukwHEe4mcvSQtZ55dfv6cEE8Djm9CUtMBfkYwA";

    string public constant contractImageURI = "ipfs://QmYDfMywCGmHwEmBipuGGRpxB4EWdeFoaLpTVhXJdjphox";
    string public constant contractBannerImageURI = "ipfs://QmVvBLMYrQgZuXZ5LixZXTuU3ru3eB2qQ7P769ZX2etD41";

    // Mimicing the www.v1punks.io
    string public constant contractExternalURI = "https://www.v1phunks.io/";

    // Again, name and symbol flipped from the Punk wrapper
    constructor(address _phunkAddress) ERC721("V1 Cryptophunks (Wrapped)", "WPHV1") {
        _baseTokenURI = "ipfs://QmXwc9E4Mjq5oHspuL77DCQwQQ4TvP7Bse35BRpTXeFtZp/";
        _baseTokenImageURI = "ipfs://QmQd5kibvRWNecTxSKE55YnKbWKN7f4fDjgyXPZU1YxN6o/";

        phunkContract = CryptoPhunksV1Interface(_phunkAddress);
    }

    // This essentially reimplements the internal _isApprovedOrOwner() function. I consider there not
    // being a public version of this method to be a design flaw in ERC721. If ownerOf() is public
    // there should also be a public way of seeing who can act as the owner under a variety of circumstances
    function canBeWrappedByUser(address user, uint tokenId) public view returns (bool) {
        address tokenOwner = phunkContract.ownerOf(tokenId);

        return (
            user == tokenOwner ||
            phunkContract.getApproved(tokenId) == user ||
            phunkContract.isApprovedForAll(tokenOwner, user)
        );
    }

    function canBeUnwrappedByUser(address user, uint tokenId) public view returns (bool) {
        return _isApprovedOrOwner(user, tokenId);
    }

    // To wrap a V1 Phunk you use safeTransferFrom() to send the Phunk to this contract.
    // The wrapping happens automatically in this callback.
    //
    // Somewhat unbelievably, there is no standard for wrapping an ERC721 token—the V1 Punk wrapper is of course
    // of a very specific non-ERC721 NFT. I took this approach from
    // https://www.reddit.com/r/ethdev/comments/c64sok/methods_to_wrap_erc721_tokens/
    // The more straightforward route is to have a wrap() function on the wrapper that moves the original
    // token on behalf of the user, but that would require an additional transaction for approval
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external virtual override returns (bytes4) {
        require(msg.sender == address(phunkContract), "I can only wrap V1 Phunks");
        require(phunkContract.ownerOf(tokenId) == address(this), "I cannot wrap a Phunk unless I own it");

        // A notable improvement over the V1 Punk wrapper which increments via the
        // more verbose `_tokenSupply +=1`
        _tokenSupply++;
        _safeMint(from, tokenId);

        return IERC721Receiver.onERC721Received.selector;
    }

    function unwrap(uint tokenId) external {
        require(canBeUnwrappedByUser(msg.sender, tokenId), "Not authorized to unwrap");

        _tokenSupply--;
        _burn(tokenId);

        phunkContract.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // The image URIs presented a significant artistic decision. Flipping the V1 Punk wrapping would
    // mean mimicing their image URIs which are bare IPFS links (not so fun). Instead, I decided to copy
    // the Phunk V2 image URIs, including the zero-padding for the ids which drives me crazy why
    // would you do that? This is what the URIs look like:
    //
    // ipfs://QmQd5kibvRWNecTxSKE55YnKbWKN7f4fDjgyXPZU1YxN6o/notwrappedpunk3100.png
    //
    // HOWEVER, note that the original filenames were of the form notpunk3100.png. This presented me
    // with an extremely difficult artistic decision:
    // Should the wraps be wrappednotpunk3100.png or notwrappedpunk3100.png?

    // The fact that I chose the latter strongly implies that my intent is to flip the wrapped punks, NOT
    // to wrap the flipped Punks (i.e., the Phunks)!

    // I gave all the images a purple background to, again, mimic the V1 Punk wrapper. V1 Punks had
    // transparent backgrounds which makes it easy to add the purple. Phunks have a solid color
    // background with varying border colors which made replacing the background color on 10k images
    // not so easy to do! But I think it looks cool and we have to distinguish them from their V2 brethren.
    function wrapPreviewImageURI(uint phunkId) public view returns (string memory) {
        string memory idString = phunkId.toString();

        while (bytes(idString).length < 4) {
            idString = string(abi.encodePacked("0", idString));
        }

        return string(abi.encodePacked(_baseTokenImageURI, "notwrappedpunk", idString, ".png"));
    }

    function wrapPreviewTokenJSON(uint phunkId) public view returns (string memory) {
        return string(abi.encodePacked(_baseURI(), phunkId.toString()));
    }

    function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
        _baseTokenURI = __baseTokenURI;
    }

    function setBaseTokenImageURI(string memory __baseTokenImageURI) public onlyOwner {
        _baseTokenImageURI = __baseTokenImageURI;
    }

    function exists(uint256 tokenId) external view virtual returns (bool) {
        return _exists(tokenId);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenSupply;
    }

    function contractURI() public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{',
                                '"name":"', "V1 Phunks (Wrapped)", '",'
                                '"description":"', contractDescription, '",'
                                '"image":"', contractImageURI, '",'
                                '"external_link":"', contractExternalURI, '"'
                                '}'
                            )
                        )
                    )
                )
            );
    }
}