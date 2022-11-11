// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

/**
    @title Types
    @author Neel Deep Dandiwala
*/

library Types {
    struct Jury {
        uint256 juryAddress;
        uint256 marksToFirst;
        uint256 marksToSecond;
        uint256 marksToThird;
    }

    struct Student {
        string studentName;
        uint256 studentId;
    }

    struct Results {
        string resultName;
        uint256 resultMarks;
        uint256 resultId;
    }
}