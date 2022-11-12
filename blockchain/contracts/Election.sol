// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.4.25 <0.9.0;

import "./Types.sol";

/**
    @title Election 
    @author Neel Deep Dandiwala
*/

contract Election {
    Types.Student[] public students;
    mapping(uint256 => Types.Jury) jury;
    mapping(uint256 => Types.Student) student;
    mapping(uint256 => uint256) internal resultObtainedMarks;

    address electionMaster;
    uint256 private electionStartTime;
    uint256 private electionEndTime;

    constructor(uint256 startTime_, uint256 endTime_){
        initializeStudentDatabase_();
        initializeJuryDatabase_();
        electionStartTime = startTime_;
        electionEndTime = endTime_;
        electionMaster = msg.sender;
    }

    function getStudentsList(uint256 juryAddress) public view returns (Types.Student[] memory) {
        return students;
    }

    function didCurrentJuryInterview(uint256 juryAddress) public view returns (bool juryInterviewed_) {
        juryInterviewed_ = (jury[juryAddress].juryTookInterview != 0);
        return juryInterviewed_;

    }

    function didCurrentJuryDiscussion(uint256 juryAddress) public view returns (bool juryDiscussion_) {
        juryDiscussion_ = (jury[juryAddress].juryTookDiscussion != 0);
        return juryDiscussion_;

    }

    function interview (
        uint256[] memory marks, uint256 juryAddress, uint256 currentTime_
    ) 
        public
        electionIsOpen(currentTime_)
        isEligibleMarks(juryAddress)
    {
        jury[juryAddress].juryTookInterview = 1;

        for (uint256 i = 0; i < students.length; i++){
            uint256 resultMarks_ = resultObtainedMarks[students[i].studentId];
            require(0 <= marks[i] && marks[i] <= 10);
            resultObtainedMarks[students[i].studentId] = resultMarks_ + marks[i];
        }
         
    }

    function discussion (
        uint256[] memory marks, uint256 juryAddress, uint256 currentTime_
    ) 
        public
        electionIsOpen(currentTime_)
        isEligibleMarks(juryAddress)
    {
        jury[juryAddress].juryTookDiscussion = 1;

        for (uint256 i = 0; i < students.length; i++){
            uint256 resultMarks_ = resultObtainedMarks[students[i].studentId];
            require(0 <= marks[i] && marks[i] <= 10);
            resultObtainedMarks[students[i].studentId] = resultMarks_ + marks[i];
        }
         
    }

    function getElectionEndTime() public view returns (uint256 electionEndTime_) {
        electionEndTime_ = electionEndTime;
    }

    function getResults(uint256 currentTime_) public view returns (Types.Results[] memory) {
        require(electionEndTime < currentTime_);
        Types.Results[] memory resultDetails_ = new Types.Results[](
            students.length
        );
        for (uint256 i = 0; i < students.length; i++) {
            resultDetails_[i] = Types.Results({
                resultName: students[i].studentName,
                resultMarks: resultObtainedMarks[students[i].studentId],
                resultId: students[i].studentId
            });
        }

        return resultDetails_;
    }

    function getWinner(uint256 currentTime_) public view returns (Types.Results memory) {
        require(electionEndTime < currentTime_);
        Types.Results memory winnerDetails_;
        uint256 highestMarks_ = 0;
        for (uint256 i = 0; i < students.length; i++) {
            if (resultObtainedMarks[students[i].studentId] > highestMarks_) {
                highestMarks_ = resultObtainedMarks[students[i].studentId];
                winnerDetails_ = Types.Results({
                    resultName: students[i].studentName,
                    resultMarks: resultObtainedMarks[students[i].studentId],
                    resultId: students[i].studentId
                });
            }
        }

        return winnerDetails_;
    }

    modifier electionIsOpen(uint256 currentTime_) {
        require(currentTime_ >= electionStartTime);
        require(currentTime_ <= electionEndTime);
        _;
    }

    modifier isEligibleMarks(uint256 juryAddress_) {
        Types.Jury memory jury_ = jury[juryAddress_];
        
        require(jury_.juryTookInterview == 0);
        require(jury_.juryTookDiscussion == 0);
        _;
    }

    modifier isElectionMaster() {
        require(msg.sender == electionMaster);
        _;
    }    

    function initializeStudentDatabase_() internal {
        Types.Student[] memory students_ =  new Types.Student[](3);

        students_[0] = Types.Student({
            studentName: "Keval",
            studentId: uint256(1)
        });
        students_[1] = Types.Student({
            studentName: "Atharv",
            studentId: uint256(2)
        });
        students_[2] = Types.Student({
            studentName: "Moon",
            studentId: uint256(3)
        });

        for(uint256 i = 0; i < students_.length; i++){
            student[students_[i].studentId] = students_[i];
            students.push(students_[i]);
        }
    }

    function initializeJuryDatabase_() internal {
        jury[uint256(1)] = Types.Jury({
            juryAddress: uint256(11),
            juryTookInterview: uint256(0),
            juryTookDiscussion: uint256(0)
        });
        jury[uint256(2)] = Types.Jury({
            juryAddress: uint256(12),
            juryTookInterview: uint256(0),
            juryTookDiscussion: uint256(0)
        });
        jury[uint256(3)] = Types.Jury({
            juryAddress: uint256(13),
            juryTookInterview: uint256(0),
            juryTookDiscussion: uint256(0)
        });
        jury[uint256(4)] = Types.Jury({
            juryAddress: uint256(14),
            juryTookInterview: uint256(0),
            juryTookDiscussion: uint256(0)
        });
        jury[uint256(5)] = Types.Jury({
            juryAddress: uint256(15),
            juryTookInterview: uint256(0),
            juryTookDiscussion: uint256(0)
        });
    }
}