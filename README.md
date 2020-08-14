# Profit Splitter solidity smart contracts

This repo contains the source code of the solidity smart contracts that have been implemented on the Kovan Testnet.

You will find three (3) contracts in the code, all of which have been deployed to the testnet at the following addresses.

1. AssociateProfitSplitter: 0x215d0AFAAefF4a656E64C542630691ab55fB4D23

This will accept Ether into the contract and divide the Ether evenly among the associate level employees.
This is only allowed to be executed by the owning address (the address that deployed the contract).

Proof that this contract works (transaction hash on the kovan testnet):
https://kovan.etherscan.io/tx/0x87584655c59efd067b2baafb511e2a7dd28c5d50addf731635b231d01bb74e76

2. TieredProfitSplitter: 0x91c291252a7b15fE45337F7EEa62704A61387CAa

This will distribute different percentages of incoming Ether to employees at different tiers/levels.
For example, the CEO gets paid 60%, CTO 25%, and Bob gets 15%.

Proof that this contract works (transaction hash on the kovan testnet):
https://kovan.etherscan.io/tx/0x34331dbec37aa35c9c9f5a3d5cc4f65ea5110a352ed162bde9096ee5dc1c0434

3. DeferredEquityPlan: 0x71747a7E803A6525d8860118302605D48866f953

This models traditional company stock plans. This contract will automatically manage 1000 shares with an annual distribution of 250 over 4 years for a single employee.

Since this is written to work after one year, we'll come back to you with proof that it works in 2021 (if we don't forget!).
We've added an amended source code to test the DeferredEquityPlan by implementing a "fast-forward" function to allow for testing. You can deploy this in your local testnet to see how it works. The source code for this is in a separate file labeled TestDeferredEquityPlan.sol.
