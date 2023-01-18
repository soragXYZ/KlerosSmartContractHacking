//*** Exercice 15 ***//.
// This is a game where an Owner considered as TRUSTED can set rounds with rewards.
// The Owner allows several users to compete for the rewards. The fastest user gets all the rewards.
// The users can propose new rounds but it's up to the Owner to fund them.
// The Owner can clear the rounds to create fresh new ones.
contract WinnerTakesAll {

    struct Round {
        uint rewards;
        mapping(address => bool) isAllowed;
    }

    address owner;
    Round[] rounds;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function createNewRounds(uint _numberOfRounds) external {
        for (uint i = 0; i < _numberOfRounds; i++) {
            rounds.push();
        }
    }

    function setRewardsAtRound(uint _roundIndex) external payable onlyOwner() {
        require(rounds[_roundIndex].rewards == 0);
        rounds[_roundIndex].rewards = msg.value;
    }

    function setRewardsAtRoundfor(uint _roundIndex, address[] calldata _recipients) external onlyOwner() {
        for (uint i; i < _recipients.length; i++) {
            rounds[_roundIndex].isAllowed[_recipients[i]] = true;
        }
    }

    function isAllowedAt(uint _roundIndex, address _recipient) external view returns (bool) {
        return rounds[_roundIndex].isAllowed[_recipient];
    }

    function withdrawRewards(uint _roundIndex) external {
        require(rounds[_roundIndex].isAllowed[msg.sender]);
        uint amount = rounds[_roundIndex].rewards;
        rounds[_roundIndex].rewards = 0;
        payable(msg.sender).transfer(amount);
    }

    function clearRounds() external onlyOwner {
        delete rounds;
    }

    function withrawETH() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}

// a player can scan the memory pool and increase gas fees in order to be the first player to call withdrawRewards() -> frontrunning
// or a player can also directly pay a miner to have his Tx included in a block without going through the memory pool