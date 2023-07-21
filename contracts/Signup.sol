pragma solidity ^0.8.9;

contract admin_manufacture {
    address public owner;
    uint256 public creationTime;

    enum Role {Seller, Purchaser, Supplier, Distributor}

    struct User {
        string firstname;
        string lastname;
        string companyName;
        string email;
        string number;
        string password;
        Role role;
        address walletAddress; // Added field to store wallet address
    }

    mapping(address => User) public users;
    uint256 public userCount;

    constructor() {
        owner = msg.sender;
        creationTime = block.timestamp;
        userCount = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    function registerUser(
        string memory firstname,
        string memory lastname,
        string memory companyName,
        string memory email,
        string memory number,
        string memory password,
        Role role
    ) public {
        address userAddress = msg.sender;
        require(users[userAddress].role == Role(0), "User already registered.");

        users[userAddress] = User({
            firstname: firstname,
            lastname: lastname,
            companyName: companyName,
            email: email,
            number: number,
            password: password,
           
            role: role,
            walletAddress: userAddress // Store the wallet address
        });
        userCount++;
    }

    function getRoleName(Role role) public pure returns (string memory) {
        if (role == Role.Seller) {
            return "Seller";
        } else if (role == Role.Purchaser) {
            return "Purchaser";
        } else if (role == Role.Supplier) {
            return "Supplier";
        } else if (role == Role.Distributor) {
            return "Distributor";
        }

        return "Unknown Role";
    }

    function getUser(address userAddress) public view returns (
        string memory firstname,
        string memory lastname,
        string memory companyName,
        string memory email,
        string memory number,
        string memory password,
        
        string memory roleName,
        address walletAddress // Include the wallet address in the return value
    ) {
        User memory user = users[userAddress];
        string memory roleString = getRoleName(user.role);

        return (
            user.firstname,
            user.lastname,
            user.companyName,
            user.email,
            user.number,
            user.password,
          
            roleString,
            user.walletAddress
        );
    }

    function getUserByEmailAndPassword(string memory email, string memory password) public view returns (
        string memory firstname,
        string memory lastname,
        string memory companyName,
        string memory number,
       
        Role role,
        address walletAddress // Include the wallet address in the return value
    ) {
        address userAddress = msg.sender;
        User storage user = users[userAddress];

        require(keccak256(abi.encodePacked(user.email)) == keccak256(abi.encodePacked(email)), "Invalid email or password.");
        require(keccak256(abi.encodePacked(user.password)) == keccak256(abi.encodePacked(password)), "Invalid email or password.");

        return (
            user.firstname,
            user.lastname,
            user.companyName,
            user.number,
            user.role,
            user.walletAddress
        );
    }
}



