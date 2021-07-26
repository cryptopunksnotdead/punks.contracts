

interface PunksContract {

    function balanceOf(address) external view returns (uint256);

    function punkIndexToAddress(uint256) external view returns (address);

}
