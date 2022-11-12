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
        uint256 juryTookInterview;
        uint256 juryTookDiscussion;
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