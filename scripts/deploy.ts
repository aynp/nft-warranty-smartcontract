import { ethers } from 'hardhat';

async function main() {
  console.log('Deploying...');
  const WarrantyNFTContract = await ethers.getContractFactory('WarrantyNFT');
  const warrantyNFT = await WarrantyNFTContract.deploy();
  await warrantyNFT.deployed();
  console.log('Warranty NFT deployed at - ', warrantyNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
