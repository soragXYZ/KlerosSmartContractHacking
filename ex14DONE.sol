//*** Exercice 14 ***//
// This is a piggy bank.
// The owner can deposit 1 ETH whenever he wants.
// He can only withdraw when the deposited amount reaches 10 ETH.
contract PiggyBank {

    address owner;

    /// @dev Set msg.sender as owner
    constructor() {
        owner = msg.sender;
    }

    /// @dev Deposit 1 ETH in the smart contract
    function deposit() public payable {
        require(msg.sender == owner && msg.value == 1 ether && address(this).balance <= 10 ether);
    }

    /// @dev Withdraw the entire smart contract balance
    function withdrawAll() public {
        require(msg.sender == owner && address(this).balance == 10 ether);
        payable(owner).send(address(this).balance);
    }
}

// line 21 address(this).balance == 10 ether
// the owner can still call deposit() even if the contract holds 10 ETH
// the contract now holds 11 ETH, so the owner can't withdraw

// and someone can send 1 wei to the contract using selfdestruct -> the owner can't withdraw