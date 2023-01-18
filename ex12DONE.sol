//*** Exercice 12 ***//
// A Token contract that keeps a record of the users past balances.
contract SnapShotToken {
    mapping(address => uint) public balances;
    mapping(address => mapping(uint => uint)) public balanceAt;

    event BalanceUpdated(address indexed user, uint oldBalance, uint newBalance);
    
    /// @dev Buy token at the price of 1ETH/token.
    function buyToken() public payable {
        uint _balance = balances[msg.sender];
        uint _newBalance = _balance + msg.value / 1 ether;
        balances[msg.sender] = _newBalance;

        _updateCheckpoint(msg.sender, _balance, _newBalance);
    }
    
    /** @dev Transfer tokens.
     *  @param _to The recipient.
     *  @param _value The amount to send.
     */
    function transfer(address _to, uint _value) public {
        uint _balancesFrom = balances[msg.sender];
        uint _balancesTo = balances[_to];

        uint _balancesFromNew = _balancesFrom - _value;
        balances[msg.sender] = _balancesFromNew;

        uint _balancesToNew = _balancesTo + _value;
        balances[_to] = _balancesToNew;

        _updateCheckpoint(msg.sender, _balancesFrom, _balancesFromNew);
        _updateCheckpoint(_to, _balancesTo, _balancesToNew);
    }
    
    /**
     * @dev Record the users balance at this blocknumber
     *
     * @param _user The address who's balance is updated.
     * @param _oldBalance The previous balance.
     * @param _newBalance The updated balance.
     */
    function _updateCheckpoint(address _user, uint _oldBalance, uint _newBalance) internal {
        balanceAt[_user][block.timestamp] = _newBalance;
        emit BalanceUpdated(_user, _oldBalance, _newBalance);
    }
}

// an attacker can send tokens to himselfto trick the balance record
// attacker has 1 token, send 1 token to himself ->
// _updateCheckpoint(addr, 1, 0)
// _updateCheckpoint(addr, 1, 2)