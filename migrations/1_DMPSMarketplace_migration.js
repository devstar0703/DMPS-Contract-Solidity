const DMPSMarketplace = artifacts.require("DMPSMarketplace");

module.exports = async function (deployer) {
  await deployer.deploy(DMPSMarketplace);

  const deployed_dmps_nft_contract = await DMPSMarketplace.deployed() ;

  console.log("DMPS NFT Contract Address:", deployed_dmps_nft_contract.address);
};