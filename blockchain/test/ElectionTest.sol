//  // SPDX-License-Identifier: GPL-3.0
//  pragma solidity >=0.4.25 <0.9.0;
//  import "../contracts/Election.sol";
//  contract ElectionTest {
//      Election electionToTest = new Election(1649250142, 1662550200);
//      function isJuryInterviewed() public {
//          electionToTest.interview([uint256(3), uint256(4), uint256(5)], 15, 1647943642);
//          assert.equal(
//              electionToTest.didCurrentJuryInterview(15), // Since this returns 2 params as an array
//              true,
//              "Vishal already interviewed the students"
//          );
//      }
//  }
// // 