import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';

const config: HardhatUserConfig = {
  solidity: '0.8.9',
  paths: {
    artifacts: '../client/src/artifacts',
  },
};

export default config;
