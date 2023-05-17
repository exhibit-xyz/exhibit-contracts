import axios from 'axios';
import * as env from 'dotenv';
import { ethers, tenderly } from 'hardhat';
env.config();

const { TENDERLY_USER, TENDERLY_PROJECT } = process.env;

async function main() {
  const owners = (await ethers.provider.listAccounts()).slice(0, 3);
  console.log(owners);

  const exhibitBaseFactory = await ethers.getContractFactory('ExhibitBase');

  console.log('Deploying MultiSigWallet...');

  const exhibitBase = await exhibitBaseFactory.deploy(owners, 2);
  console.log(exhibitBase.address);
  await exhibitBase.deployed();

  console.log('Verifying multisig wallet (deployed at ' + exhibitBase.address + ')');

  await tenderly.verify({
    name: 'ExhibitBase',
    address: exhibitBase.address,
  });
  console.log('Deployed to:', exhibitBase.address);

  console.log('Place the address to scripts/constants.ts under `exhibitBase`');

  console.log('Fund multisig');
  const fundingReciept = await ethers.provider.getSigner(owners[0]).sendTransaction({
    to: exhibitBase.address,
    value: ethers.utils.parseUnits('0.01', 'ether'),
  });

  await fundingReciept.wait();

  console.log('Submitting TX to Multisig');
  // this TX only sends some funds to the multisig
  const submitTransaction = await exhibitBase
    .connect(ethers.provider.getSigner(0))
    .submitTransaction((await ethers.provider.listAccounts())[3], 100000, '0x');

  await submitTransaction.wait();

  console.log('Submitted tx!');

  console.log('Executing TX');
  const executionTx = await exhibitBase.populateTransaction.executeTransaction(0, {
    gasLimit: 1000000,
  });

  axios.post(
    `https://api.tenderly.co/api/v1/account/${TENDERLY_USER}/project/${TENDERLY_PROJECT}/simulate`,
    {},
    {
      headers: {
        // TODO: Tenderly Headers
      },
    }
  );
}

main().catch((error) => {
  console.error(error, JSON.stringify(error));
  process.exitCode = 1;
});
