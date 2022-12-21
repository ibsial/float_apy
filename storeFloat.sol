// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;


contract Float {

    mapping(address => PositionData) position;

    address[] public tokens;
    bytes32[] public values; //we can store 16 values

    struct PositionData {
        uint64 slot; // array number
        uint64 fraction; // first half-byte in the slot
    }

    function addNumber(bytes32 _preparedNumber) public {
        

            values.push(_preparedNumber);
        
    }

    function addTokens(address[] memory _token, PositionData[] memory _position) public {
        for (uint i = 0; i < _token.length; i++) {
            position[_token[i]] = _position[i];
        }
    }

    // get number from bytes32
    // having a hex number like
    // 0x2710 (10 000 in decimal)
    // we first access 27 
    // then shift by 2 positions (8 bits or 2 half-bytes)
    // concat with 10
    bytes32 public vvalue;
    function _getValue(uint _slot, uint _fraction) public returns(bytes32) {
        bytes32 value = values[_fraction][_slot+1];
        value = (value >> 8) | values[_fraction][_slot];
        vvalue = value;
        return value;
    }

    // decode hex number to uint256
    // consider mantissa taking first 2 bits
    uint256 public result;
    uint256 public num;
    function _decodeValue(bytes32 _value) public {
        num = uint256(_value >> 240);
        uint256 mantissa = num >> 14;
        uint256 body = (num << 242) >> 242;

        result = body * (10 ** mantissa);

    }

    // look at an example
    // having bits 10_10011101110101 (3 and 10101 in dec)
    // we want to mean a float number 10.101
    // these bits are converted to a hex number 
    // A775
    function getValuesForTokens(address[] memory _token) public {

        for (uint i = 0; i < _token.length; i++) {

        }
    }

    // bytes32 public value = 0x0000000000000000000000000000000000000000000000000000000000000001;

    // function shiftBytes() public {
    //     value = value << 4;
    // }

    // bytes1 public posValue;

    // function revealPosValue(uint8 pos) public {
    //     posValue = value[pos];
    // }
}