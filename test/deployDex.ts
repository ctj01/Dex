import hre from "hardhat";
  
  async function Main(){
    const FlashLoan = await hre.ethers.getContractFactory("Dex");
      const lock = await FlashLoan.deploy();
     const result = await lock.waitForDeployment();
      console.log("Dex deployed to:", result.target);
  }
  
  Main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });