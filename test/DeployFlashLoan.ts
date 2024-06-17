import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

async function Main(){
  const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
    const lock = await FlashLoan.deploy("0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A");
   const result = await lock.waitForDeployment();
    console.log("FlashLoan deployed to:", result.target);
}

Main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});