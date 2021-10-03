interface CryptoPunksAssets {
    function composite(bytes1, bytes1, bytes1, bytes1, bytes1) external view returns (bytes4);
    function getAsset(uint8) external view returns (bytes memory);
    function getAssetName(uint8) external view returns (string memory);
    function getAssetType(uint8) external view returns (uint8);
    function getAssetIndex(string calldata, bool) external view returns (uint8);
    function getMappedAsset(uint8, bool) external view returns (uint8);
}

