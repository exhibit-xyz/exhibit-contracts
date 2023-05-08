import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";

const config: HardhatUserConfig = {
  solidity: '0.8.18',
  networks: {
    devnet: {
      url: 'https://rpc.vnet.tenderly.co/devnet/exhibit-devnet/9cc03b7f-91d7-419c-a8fc-151d8033ff23',
      chainId: 1,
    },
  },
};

export default config;
