pragma solidity ^0.5.3;
contract Auction {
    // Data
    //Structure to hold details of the item
    struct Item {
        uint itemId; // id of the item
        uint[] itemTokens; //tokens bid in favor of the item
    }
    //Structure to hold the details of a persons
    struct Person {
        uint remainingTokens; // tokens remaining with bidder
        uint personId; // it serves as tokenId as well
        address addr;//address of the bidder
    }
    mapping(address => Person) tokenDetails; //address to person
    Person[4] bidders;//Array containing 4 person objects
    Item[3] public items;//Array containing 3 item objects
    address[3] public winners;//Array for address of winners
    address public beneficiary;//owner of the smart contract

    uint bidderCount=0;//counter
    //functions
    constructor() public payable { //constructor
        //Part 1 Task 1. Initialize beneficiary with address of smart contract’s owner
        //Hint. In the constructor,"msg.sender" is the address of the owner.
        // ** Start code here. 1 line approximately. **/
        beneficiary = msg.sender;
        //** End code here. **/
        uint[] memory emptyArray;

        items[0] = Item({itemId:0,itemTokens:emptyArray});
        //Part 1 Task 2. Initialize two items with at index 1 and 2.
        // ** Start code here. 2 lines approximately. **/
        items[1] = Item({itemId:1,itemTokens:emptyArray});
        items[2] = Item({itemId:2,itemTokens:emptyArray});
        //** End code here**/
    }
    function getTokensFromItem(uint id) public view returns(uint[] memory){
        uint[] memory itemTokens;
        itemTokens = items[id].itemTokens;
        return itemTokens;
    }
    function getBidder(address addr) public view returns(uint id,uint token){
        return (tokenDetails[addr].personId,tokenDetails[addr].remainingTokens);
    }
    function register() public payable{
        bidders[bidderCount].personId = bidderCount+1;
        //Part 1 Task 3. Initialize the address of the bidder
        /*Hint. Here the bidders[bidderCount].addr should be initialized with
        address of the registrant.*/
        // ** Start code here. 1 line approximately. **/
        bidders[bidderCount].addr=msg.sender;
        //** End code here. **
        bidders[bidderCount].remainingTokens = 5; // only 5 tokens
        tokenDetails[msg.sender]=bidders[bidderCount];
        bidderCount++;
    }
    function bid(uint _itemId, uint _count) public payable {
    /*
        Bids tokens to a particular item.
        Arguments:
        _itemId -- uint, id of the item
        _count -- uint, count of tokens to bid for the item
    */
    /*
        Part 1 Task 4. Implement the three conditions below.
        4.1 If the number of tokens remaining with the bidder is < count of tokens bid, revert
        4.2 If there are no tokens remaining with the bidder,revert.
        4.3 If the id of the item for which bid is placed, is greater than 2, revert.
        Hint: "tokenDetails[msg.sender].remainingTokens" gives the details of the number of tokens remaining with the bidder.

    */
    // ** Start code here. 2 lines approximately. **/
    if( tokenDetails[msg.sender].remainingTokens < _count){
        revert("Your bid tokens' number is bigger than remaining tokens number");
    }
    if( tokenDetails[msg.sender].remainingTokens <= 0){
        revert('You are out of tokens');
    }
    if(_itemId>2){
        revert('Item is greater than 2');
    }
    //** End code here. **
    /*Part 1 Task 5. Decrement the remainingTokens by the number of tokens bid
    Hint. "tokenDetails[msg.sender].remainingTokens" should be decremented by "_count". */
    // ** Start code here. 1 line approximately. **
    tokenDetails[msg.sender].remainingTokens-=_count;
    //** End code here. **
    bidders[tokenDetails[msg.sender].personId-1].remainingTokens= tokenDetails[msg.sender].remainingTokens; //updating the same balance in bidders map.
    Item storage bidItem = items[_itemId];
        for(uint i=0; i<_count;i++) {
            bidItem.itemTokens.push(tokenDetails[msg.sender].personId);
        }
    }
    function revealWinners() public payable onlyOwner{

    /*
        Iterate over all the items present in the auction. If at least on person has placed a bid, randomly select the winner
    */
        for (uint id = 0; id < 3; id++) {
            Item storage currentItem=items[id];
            if(currentItem.itemTokens.length != 0){
            // generate random# from block number
            uint randomIndex = (block.number /
            currentItem.itemTokens.length)% currentItem.itemTokens.length;
            // Obtain the winning tokenId
            uint winnerId = currentItem.itemTokens[randomIndex] - 1;
            /* Part 1 Task 6. Assign the winners.
            Hint." bidders[winnerId] " will give you the person object with the winnerId.
            you need to assign the address of the person obtained above to winners[id] */
            // ** Start coding here *** 1 line approximately.
            winners[id]=bidders[winnerId].addr;
            //** end code here*
            }
        }
}

    function getWinners() public view returns(address[3] memory){
        return winners;
    }
     modifier onlyOwner(){
        require( beneficiary == msg.sender,'Unauthorised access');
        _; /*Stop execute*/
    }
    //  Miscellaneous methods: Below methods are used to assist Grading. Please
    // DONOT CHANGE THEM.
    // function getPersonDetails(uint id) public constant
    // returns(uint,uint,address){
    // return
    // (bidders[id].remainingTokens,bidders[id].personId,bidders[id].addr);
    // }
}
