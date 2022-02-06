

interface CryptoPhunksV1Interface {
  function ownerOf ( uint256 tokenId ) external view returns ( address );
  function getApproved ( uint256 tokenId ) external view returns ( address );
  function isApprovedForAll ( address owner, address operator ) external view returns ( bool );
  function safeTransferFrom ( address from, address to, uint256 tokenId ) external;
}

