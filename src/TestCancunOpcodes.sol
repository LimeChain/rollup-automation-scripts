// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TestBlobHash {
    constructor() {
        bytes32 blob = blobhash(0);
        bytes memory result = abi.encode(blob);
        assembly {
            let dataStart := add(result, 0x20)
            return(dataStart, sub(msize(), dataStart))
        }
    }
}

contract TestBlobBaseFee {
    constructor() {
        uint256 fee = block.blobbasefee;
        bytes memory result = abi.encode(bytes32(fee));
        assembly {
            let dataStart := add(result, 0x20)
            return(dataStart, sub(msize(), dataStart))
        }
    }
}

contract TestTStoreLoad {
    constructor() {
        uint256 store = 0;
        assembly {
            tstore(0, 0x1234)
            store := tload(0)
        }
        bytes memory result = abi.encode(bytes32(store));
        assembly {
            let dataStart := add(result, 0x20)
            return(dataStart, sub(msize(), dataStart))
        }
    }
}

contract TestMcopy {
    constructor() {
        uint256 copy = 0;
        assembly {
            mstore(0x20, 0x56)
            mcopy(0, 0x20, 0x20)
            copy := mload(0)
        }
        bytes memory result = abi.encode(bytes32(copy));
        assembly {
            let dataStart := add(result, 0x20)
            return(dataStart, sub(msize(), dataStart))
        }
    }
}
