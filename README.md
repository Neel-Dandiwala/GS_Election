<p align="center">
  <img width="100%"  src="https://github.com/Neel-Dandiwala/GS_Election/blob/master/sample-images/4.png?raw=true">
</p>


## Problem Statement
Write a contract to elect the General Secretary (GS) in an education institute. Any number of students can contest the election. Every registered candidate shall give an interview and participate in a group discussion. Five jury members will bestow marks out of 10 pertaining to the interview and 10 more marks pertaining to the group discussion. The candidate who scores highest marks will be elected as the General Secretary of the institute. If two candidates receive same marks then the main jury will make decision based on their experience to finalise the winner.

## Solution

First structures and manual data types are constructed. Using those structures which are encompassed in a library, we got to initialise two databases which included the list of jury members and the student candidates. Then we implemented functions that helped the jury members give out marks to the students by conducting interviews and group discussion sessions with them. Each jury member is recognised by their address. In the end, two functions were implemented to retrieve the results and the winner when the election ended. The election master’s identity was verified at each step by employing the address of the one who triggers the smart contract.

## Implementation of electronic election:

### Required:

- Address of the jury member as unique indentification.
- Smart Contract consisting of all the rules and protocols required for conducting the election.
- Blockchain Network to deploy the Contract. I have used Remix IDE's Test Network for the contract.

### Who can give marks:

- Every jury member who's address is listed in the Jury Database can allocate marks during the interview and group discussion sessions.
- Jury's address should be valid and linked with the stored equivalent in the database.

### Who cannot vote:

- Already casted vote.
- Entity's address not matched with ongoing Election's Jury Database.


## Solidity Functions

### Modifiers

```c++
    /**
     * 
     * @param currentTime_ Current epoch time of the jury
     */
        modifier electionIsOpen(uint256 currentTime_) {
            require(currentTime_ >= electionStartTime);
            require(currentTime_ <= electionEndTime);
            _;
        }
    /**
    * @param juryAddress_
     */
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
```

### Voting timelines

- Election will only take place between a particular date(s) & election master has the right to update the start & end dates of the process.


### Results

Everyone can check the results once the election is closed

```c++
    /**
     * 
     * @param currentTime_ Current epoch time of length 10.
     * To get the Results
     */
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

    /**
     * 
     * @param currentTime_ Current epoch time of length 10.
     * To get the ultimate winner
     */
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
```

### Custom Types

```c++
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
```

### Voting Methods

| **Function Name**       | **Input Params**                                                                  | **Return Value**                   | **Description**                                                                                                                            |
| ----------------------- | --------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| didCurrentJuryInterview()       | juryAddress                                                                 | Boolean `juryInterviewed_`           | To check if the current jury member has submitted their marks for interview or not. If submitted then returns true |
| didCurrentJuryDiscussion()  | juryAddress                                                                 | Boolean `juryDiscussion_`,<br>Candidate | To check if the current jury member has submitted their marks for group discussion or not. If submitted then returns true |
| getStudentsList()      | juryAddress                                                                                 | Types.Student as `students`                | To get the list of student candidates                                                                                                                 |
| interview()      | `juryAddress` of jury,<br>`marks` as Array,<br>current Time in `epoch`                                                                  | Candidate[]                        | To submit one's marks to the students in regards to the interview round                                                              |
| discussion()                  | `juryAddress` of jury,<br>`marks` as Array,<br>current Time in `epoch` | -                                  | To submit one's marks to the students in regards to the discussion round                                                          |
| getResults()            | current time in `epoch`                                                           | Results[]                          | To get the election results. Can be called by anyone but only after the voting lines are closed                                              |
|                         |                                                                                   |                                    |                                                                                                                                            |
| getWinner() | current time in `epoch`                                 | Results                                  | To get the winner from the results. Can be called by anyone but only after the voting lines are closed                                                          |
| getElectionEndTime()      | -                                   | `electionEndTime_`                                  | To get the ending timeline of the election                                     |


### Quick Start

1.  Create a new workspace on Remix
<br />
<a href="https://remix.ethereum.org/"> Remix IDE </a>

2.  Upload the files

        Election.sol
        Types.sol

3.  Compile the files


4.  Deploy the contracts

        Add the electionStartTime and electionEndTime parameters
        e.g. 1649250142, 1662550200

5.  Start executing the required functions. Beginning from interview() and discussion()

_Note the parameters for both functions mentioned above may be like \[marks...\], juryAddress,  currentTime_


6.  After executing the functions for all jury members, call getResults() and getWinner() functions

        


### Test Jury

| User Name     | Aadhar Number | 
| ------------- | ------------- | 
| John          |       11      |
| Aloe          |       12      |
| Minyoung      |       13      |
| Vishal        |       14      |
| Shuri         |       15      |


### Test Students

| Candidate Name     |      ID    | 
| ------------------ | ---------- | 
| Keval              | 1          | 
| Atharv             | 2          | 
| Moon               | 3          | 


## Author 

Neel Dandiwala
<a href="https://www.linkedin.com/in/neel-dandiwala-9102921b7/" title="Code">LinkedIn💻</a>


## Sample Images

<img src="https://github.com/Neel-Dandiwala/GS_Election/blob/master/sample-images/1.png?raw=true"><br>
<img src="https://github.com/Neel-Dandiwala/GS_Election/blob/master/sample-images/2.png?raw=true"><br>
<img src="https://github.com/Neel-Dandiwala/GS_Election/blob/master/sample-images/3.png?raw=true"><br>
<img src="https://github.com/Neel-Dandiwala/GS_Election/blob/master/sample-images/4.png?raw=true"><br>
