import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

import dotenv from 'dotenv';
dotenv.config();

const { API_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: '0.8.9',
  defaultNetwork: 'mumbai',
  networks: {
    hardhat: {},
    mumbai: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    goerli: {
      url: `${API_URL}`,
      accounts: [PRIVATE_KEY as string],
    },
  },
  paths: {
    artifacts: '../nft-warrenty-client/src/artifacts',
  },
};

export default config;
