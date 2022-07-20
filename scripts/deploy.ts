import { ethers } from 'hardhat';

async function main() {
  const WarrentyNFTContract = await ethers.getContractFactory('WarrentyNFT');
  const warrentyNFT = await WarrentyNFTContract.deploy();
  await warrentyNFT.deployed();
  console.log('Warrenty NFT deployed at - ', warrentyNFT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
