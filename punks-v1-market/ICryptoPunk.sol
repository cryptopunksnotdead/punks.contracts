
interface ICryptoPunk {
    function punkIndexToAddress(uint punkIndex) external view returns (address);
    function buyPunk(uint punkIndex) external payable;
    function transferPunk(address to, uint punkIndex) external;
    function balanceOf(address) external view returns (uint);
}

