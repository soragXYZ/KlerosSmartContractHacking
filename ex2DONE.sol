//*** Exercice 2 ***//
// You can buy some object.
// Further purchases are discounted.
// You need to pay basePrice / (1 + objectBought), where objectBought is the number of object you previously bought.
contract DiscountedBuy {
    uint public basePrice = 1 ether;
    mapping (address => uint) public objectBought;

    /// @dev Buy an object.
    function buy() public payable {
        require(msg.value * (1 + objectBought[msg.sender]) == basePrice);
        objectBought[msg.sender]+=1;
    }
    
    /** @dev Return the price you'll need to pay.
     *  @return price The amount you need to pay in wei.
     */
    function price() public view returns (uint) {
        return basePrice/(1 + objectBought[msg.sender]);
    }
    
}

// rounding error with msg.value * (1 + objectBought[msg.sender]) == basePrice
// user can't buy more than 2 objects

// 1 000 000 000 000 000 000 * 1  = 1 ether
//   500 000 000 000 000 000 * 2  = 1 ether
//   333 333 333 333 333 333 * 3 != 1 ether