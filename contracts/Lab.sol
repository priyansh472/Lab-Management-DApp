pragma solidity  <0.9.0;

contract Lab {
    
    uint public productCount = 0;
    mapping(uint => Product) public products;
    mapping(address => Request_wrapper) public requests_wrapper;
    mapping(uint => ProductHistory) public product_history;
    mapping(address => UserHistory) public user_history;
  

    struct Product {
        uint id;
        string name;
        address  owner;
        bool status;
        address original_owner;
    }

     struct Request {
        
        uint productID;
        address  owner;
        
    }

     struct Request_wrapper{

        uint requestCount; 
        mapping(uint => Request) requests;

    }

      struct transaction {
        uint id;
        address  from;
        address  to;
        
    }

     struct ProductHistory{

        uint TransactionCount; 
        mapping(uint => transaction) transactions;

    }
    struct UserHistory{

        uint TransactionCount; 
        mapping(uint => transaction) transactions;

    }
    Product[]public productlist;

    function getRequestCount() public view returns(uint) {

    return requests_wrapper[msg.sender].requestCount;
   
    }


    function getRequest(uint _rcount) public view returns(Request memory) {
        return requests_wrapper[msg.sender].requests[_rcount];

    }


    function getProductTransactionCount(uint _id) public view returns(uint) {

    return product_history[_id].TransactionCount;
   
    }L


    function getProductTransaction(uint _id,uint _rcount) public view returns(transaction memory) {
        return product_history[_id].transactions[_rcount];

    }

    function getUserTransactionCount() public view returns(uint) {

    return user_history[msg.sender].TransactionCount;
   
    }


    function getUserTransaction(uint _rcount) public view returns(transaction memory) {
        return user_history[msg.sender].transactions[_rcount];

    }
    event EquipmentCreated(
        uint id,
        string name,
        address  owner,
        bool status,
        address original_owner
    );
    event RequestCreated(
        uint id,
        address  owner
    );

    event EquipmentTransfered(
        uint id,
        string name,
        address  owner
    );

   
    uint256 a;


    function setter(uint256 _a) public {
        a = _a;
    }

    function getter() public view returns (uint) {
        return a;
    }
    function createProduct(string memory _name) public {
        // Require a valid name
        // require(bytes(_name).length > 0);
        // // Require a valid price
       
        // Increment product count
        productCount ++;
        productlist.push(Product(productCount, _name,msg.sender,true,msg.sender));

        // Create the product
        products[productCount] = Product(productCount, _name, msg.sender,true,msg.sender);
        // Trigger an event
        emit EquipmentCreated(productCount, _name,  msg.sender,true,msg.sender);
    }
    function deleteProduct(uint id) public{
        if(msg.sender == productlist[id-1].owner)
        {
            productlist[id-1].status=false;
            products[id-1].status = false;
        }
    }

    function purchaseProduct(uint _rcount) public  {
        Request memory _request=getRequest(_rcount);
        // Fetch the product
        Product memory _product = products[_request.productID];
        // Fetch the owner
        address  _seller = _product.owner;
        // Make sure the product has a valid id
       // require(_product.id > 0 && _product.id <= productCount);
        // Require that there is enough Ether in the transaction
      
        require(_seller != _request.owner);
        require(_seller==msg.sender);
        // Transfer ownership to the buyer
        _product.owner = _request.owner;
        productlist[_rcount-1].owner = _request.owner;
       products[_request.productID] = _product;

        // transaction memory trans=transaction(_request.productID,_seller,_request.owner);

        // product_history[_request.productID].TransactionCount++;
        // product_history[_request.productID].transactions[product_history[_request.productID].TransactionCount]=trans;
        // user_history[_seller].TransactionCount++;
        // user_history[_seller].transactions[user_history[_seller].TransactionCount]=trans;
        // user_history[_request.owner].TransactionCount++;
        // user_history[_request.owner].transactions[user_history[_request.owner].TransactionCount]=trans;



    //   requests_wrapper[_seller].requests[_rcount]= requests_wrapper[_seller].requests[requests_wrapper[_seller].requestCount];
    //      requests_wrapper[_seller].requestCount--;
    deleteRequest(_rcount);
        emit EquipmentTransfered(productCount, _product.name, _request.owner);
    }

   function deleteRequest(uint _rcount) public  {
       address  _seller=msg.sender;
          requests_wrapper[_seller].requests[_rcount]= requests_wrapper[_seller].requests[requests_wrapper[_seller].requestCount];
         requests_wrapper[_seller].requestCount--;
         Request memory _request=getRequest(_rcount);
         Product memory _product = products[_request.productID];
         emit EquipmentTransfered(productCount, _product.name, _request.owner);
 }
    

    function requestProduct(uint _id) public  {
        // Fetch the product
        Product memory _product = products[_id];
        // Fetch the owner
        address  _seller = _product.owner;
        // Make sure the product has a valid id
        require(_product.id > 0 && _product.id <= productCount);
        
        require(_seller != msg.sender);

        

        requests_wrapper[_seller].requestCount++;
        requests_wrapper[_seller].requests[requests_wrapper[_seller].requestCount]=Request(_id,msg.sender) ;
        emit RequestCreated(productCount,  msg.sender);

        


    // requests_wrapper[_seller]=_requests;  
    }
    function _getProductList(bool finished) private view returns (Product[] memory)
    {
    Product[] memory temporary = new Product[](productlist.length);
    uint counter = 0;
    for(uint i=0; i<productlist.length; i++) {
        temporary[counter] = productlist[i];
        counter++;
    }

    Product[] memory result = new Product[](counter);
    for(uint i=0; i<counter; i++) {
      result[i] = temporary[i];
    }
    return result;
    }
    function getAll()public view returns(Product[] memory){

        // Product[] memory id = new Product[](productCount);
        // for(uint i=0;i<productCount;i++)
        // {
        //     id[i] = productlist[i];
        // }
        return productlist;
    }
    
}