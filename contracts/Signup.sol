pragma solidity ^0.8.9;

contract admin_manufacture {
    address public owner;
    uint256 public creationTime;

    enum Role {Importer, Exporter, Supplier, Distributor}

    struct User {
        string firstName;
        string lastName;
        string companyName;
        string email;
        string phoneNumber;
        string password;
        string confirmPassword;
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
        string memory firstName,
        string memory lastName,
        string memory companyName,
        string memory email,
        string memory phoneNumber,
        string memory password,
        string memory confirmPassword,
        Role role
    ) public {
        address userAddress = msg.sender;
        require(users[userAddress].role == Role(0), "User already registered.");

        users[userAddress] = User({
            firstName: firstName,
            lastName: lastName,
            companyName: companyName,
            email: email,
            phoneNumber: phoneNumber,
            password: password,
            confirmPassword: confirmPassword,
            role: role,
            walletAddress: userAddress // Store the wallet address
        });
        userCount++;
    }

    function getRoleName(Role role) public pure returns (string memory) {
        if (role == Role.Importer) {
            return "Importer";
        } else if (role == Role.Exporter) {
            return "Exporter";
        } else if (role == Role.Supplier) {
            return "Supplier";
        } else if (role == Role.Distributor) {
            return "Distributor";
        }

        return "Unknown Role";
    }

    function getUser(address userAddress) public view returns (
        string memory firstName,
        string memory lastName,
        string memory companyName,
        string memory email,
        string memory phoneNumber,
        string memory password,
        string memory confirmPassword,
        string memory roleName,
        address walletAddress // Include the wallet address in the return value
    ) {
        User memory user = users[userAddress];
        string memory roleString = getRoleName(user.role);

        return (
            user.firstName,
            user.lastName,
            user.companyName,
            user.email,
            user.phoneNumber,
            user.password,
            user.confirmPassword,
            roleString,
            user.walletAddress
        );
    }

    function getUserByEmailAndPassword(string memory email, string memory password) public view returns (
        string memory firstName,
        string memory lastName,
        string memory companyName,
        string memory phoneNumber,
        string memory confirmPassword,
        Role role,
        address walletAddress // Include the wallet address in the return value
    ) {
        address userAddress = msg.sender;
        User storage user = users[userAddress];

        require(keccak256(abi.encodePacked(user.email)) == keccak256(abi.encodePacked(email)), "Invalid email or password.");
        require(keccak256(abi.encodePacked(user.password)) == keccak256(abi.encodePacked(password)), "Invalid email or password.");

        return (
            user.firstName,
            user.lastName,
            user.companyName,
            user.phoneNumber,
            user.confirmPassword,
            user.role,
            user.walletAddress
        );
    }
}



