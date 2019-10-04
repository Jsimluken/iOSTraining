pragma solidity ^0.5;

contract SimpleStorage{
    string data;

    function set(string memory _data) public {
        data = _data;
    }
    function get() public view returns(string memory) {
        return data;
    }
}
