// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract SupplyChain {
    
    struct Document {
        string ipfsHash;
    }

    enum OrderStatus {
        Importer,
        Exporter,
        Supplier,
        Distributor,
        Sold
    }

    struct PayOrder {
        uint256 orderNumber;
        address payable currentOwner;
        OrderStatus status;
        Document payOrderDocument;
        Document agreementDocument;
        Document deliveredProductDocument;
        Document inwardGatePass;
        Document outwardGatePass;
        string review;
    }

    mapping(uint256 => PayOrder) public payOrders;

    modifier onlyOwner(uint256 orderNumber) {
        require(payOrders[orderNumber].currentOwner == msg.sender, "Only the current owner can call this function");
        _;
    }

    event OrderStatusUpdated(uint256 orderNumber, OrderStatus status);

    function createPayOrder(uint256 orderNumber, Document memory payOrderDocument) external {
        require(payOrders[orderNumber].orderNumber == 0, "Pay order with the given order number already exists");

        PayOrder memory newPayOrder = PayOrder(
            orderNumber,
            payable(msg.sender),
            OrderStatus.Importer,
            payOrderDocument,
            Document(""),
            Document(""),
            Document(""),
            Document(""),
            ""
        );

        payOrders[orderNumber] = newPayOrder;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Importer);
    }
    

    function sendPayOrderToExporter(uint256 orderNumber, Document memory payOrderDocument) external onlyOwner(orderNumber) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.status == OrderStatus.Importer, "Order status must be Importer to send the pay order");

        payOrder.status = OrderStatus.Exporter;
        payOrder.payOrderDocument = payOrderDocument;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Exporter);
    }

    function verifyPayOrder(uint256 orderNumber) external view returns (Document memory) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.orderNumber != 0, "Pay order with the given order number does not exist");

        return payOrder.payOrderDocument;
    }

    function updateOrderStatus(uint256 orderNumber, OrderStatus newStatus)
        external
        onlyOwner(orderNumber)
    {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(
            payOrder.status != OrderStatus.Sold,
            "Order has already been sold"
        );

        payOrder.status = newStatus;

        emit OrderStatusUpdated(orderNumber, newStatus);
    }

    function requestRawMaterials(uint256 orderNumber, Document memory agreementDocument) external onlyOwner(orderNumber) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.status == OrderStatus.Exporter, "Order status must be Exporter to request raw materials");

        payOrder.status = OrderStatus.Supplier;
        payOrder.agreementDocument = agreementDocument;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Supplier);
    }

    function fulfillOrder(uint256 orderNumber, Document memory deliveredProductDocument) external onlyOwner(orderNumber) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.status == OrderStatus.Supplier, "Order status must be Supplier to fulfill the order");

        payOrder.status = OrderStatus.Exporter;
        payOrder.deliveredProductDocument = deliveredProductDocument;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Exporter);
    }

     function transferOwnershipToDistributor(uint256 orderNumber, Document memory inwardGatePass) external onlyOwner(orderNumber) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.status == OrderStatus.Exporter, "Order status must be Exporter to transfer ownership to Distributor");

        payOrder.status = OrderStatus.Distributor;
        payOrder.inwardGatePass = inwardGatePass;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Distributor);
    }

    function transferOwnershipToImporter(uint256 orderNumber, Document memory outwardGatePass) external onlyOwner(orderNumber) {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(payOrder.status == OrderStatus.Distributor, "Order status must be Distributor to transfer ownership to Importer");

        payOrder.status = OrderStatus.Sold;
        payOrder.outwardGatePass = outwardGatePass;

        emit OrderStatusUpdated(orderNumber, OrderStatus.Sold);
    }

    function provideReview(uint256 orderNumber, string memory review)
        external
        onlyOwner(orderNumber)
    {
        PayOrder storage payOrder = payOrders[orderNumber];
        require(
            payOrder.status == OrderStatus.Sold,
            "Order status must be Sold to provide a review"
        );

        payOrder.review = review;
    }
 }
