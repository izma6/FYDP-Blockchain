require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("dotenv").config();

const ALCHEMY_API_KEY = "ydkWOeBladP261GdZGLD2cO6_xHai-9r";
const SEPOLIA_RPC_URL = "https://eth-sepolia.g.alchemy.com/v2/";
const ETHERSCAN_API_KEY = "1T3N227PYDVY313N8SKDVEVZYDS4DTP8RE";
const PRIVATE_KEY1 = "1eb9abf58684737a7a514dc7b6097a43c9fb79bacc72d58ff0f11a0fd0213afa";

module.exports = {
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  defaultNetwork: "hardhat",

  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
      allowUnlimitedContractSize: true,
    },
    localhost: {
      chainId: 31337,
      allowUnlimitedContractSize: true,
    },

    sepolia: {
      chainId: 11155111,
      blockConfirmations: 6,
      allowUnlimitedContractSize: true,
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: "1eb9abf58684737a7a514dc7b6097a43c9fb79bacc72d58ff0f11a0fd0213afa" !== undefined && ["1eb9abf58684737a7a514dc7b6097a43c9fb79bacc72d58ff0f11a0fd0213afa"],
    },
  },

  etherscan: {
    apiKey: "1T3N227PYDVY313N8SKDVEVZYDS4DTP8RE",
    customChains: [],
  },

  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  mocha: {
    timeout: 500000, // 300 sec max
  },
};