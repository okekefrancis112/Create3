// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {Create3} from "./library/create3.sol";

struct Work {
    uint8 number;
}

contract Parent {
    /// @notice this function is used to deploy the child
    /// @dev this function uses the provider _salt to deply the child contract
    /// @param _salt: this is a unique 32 bytes memory variable to deploy the child 
    function deploy(bytes32 _salt) public payable returns(address _d)  {
        Work memory w = Work({number: 2});

        uint256 eth = 2 ether;

        _d = Create3.create3(
            _salt, 
            abi.encodePacked(
                type(Child).creationCode,
                abi.encode(
                    w,_salt
                )), eth
            );
    }


    /// @param _child: the is the address of the child to be verified 
    /// @notice this a view function that would return true if the provided address was created by the contract
    function isMyChlid(address _child) view public returns(bool isMine) {
        bytes32 _salt = Child(_child).dna(); 
        address mine = Create3.addressOf(_salt);

        if(mine == _child) {
            isMine = true;
        }
    }

    /// @param _salt from which you want to generate the address 
    /// @notice this function would return the address the provided salt would generate 
    function AddressIsMine(bytes32 _salt) public view returns(address isMine) {
        isMine = Create3.addressOf(_salt);

    }

    /// @notice this is a util function that would return a salt generated from a given address
    function createSalt(string memory name) pure public returns(bytes32 r) {
        r = bytes32(abi.encodePacked(name));
    }
}

/// @notice this is the Child function the Parent would be deployed 
contract Child {
    Work w;
    bytes32 public dna;

    constructor(Work memory _w, bytes32 _salt) payable {
        dna = _salt;
        w = _w;
    }
}