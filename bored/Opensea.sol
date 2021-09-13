
pragma solidity ^0.8.4;



interface Opensea {
    function balanceOf(address tokenOwner, uint tokenId) external view returns (bool);

    function safeTransferFrom(address _from, address _to, uint _id, uint _value, bytes memory _data) external;
}

