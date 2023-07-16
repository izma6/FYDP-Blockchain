const { ethers } = require("hardhat");

async function main() {

  // Deploy contract
  const Signup = await ethers.getContractFactory(
    "admin_manufacture"
  );
  const signup = await Signup.deploy();
  await signup.deployed();

  console.log(
    `Deployed Signup Contract at: ${signup.address}\n`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
