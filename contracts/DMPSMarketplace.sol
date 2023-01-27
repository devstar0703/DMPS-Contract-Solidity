// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DMPSMarketplace is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter ;

    Counters.Counter nft_counter ;
    Counters.Counter nft_sold_counter ;

    address private marketplace_addr ;

    uint256 private max_supply = 5555 ;
    mapping(uint256 => nft) private nfts ;

    struct nft {
        uint256 nft_id ;
        uint256 option ;
        address minter ;
    }

    uint256 listing_price = 0.0035 ether ;

    constructor() ERC721("Deviants Silver Mint Pass", "DMPS") {
        marketplace_addr = msg.sender ;
    }

    function mintNFT(address minter, uint256 option) public payable returns(uint256) {
        require(msg.value == listing_price * option, "mintNFT: insufficient value");
        require(nft_counter.current() < max_supply, "mintNFT: overflow supply") ;

        nft_counter.increment() ;

        uint256 new_nft_id = nft_counter.current() ;

        _safeMint(minter, new_nft_id) ;
        // _setTokenURI(new_nft_id, uri);

        nfts[new_nft_id] = nft(
            new_nft_id,
            option,
            msg.sender
        );

        _transfer(minter, marketplace_addr, new_nft_id);

        return new_nft_id ;
    }

    function fetchNFTs() public view returns(nft[] memory) {
        nft[] memory all_nfts = new nft[](nft_counter.current());

        for(uint256 i = 0 ; i < nft_counter.current() ; i++){
            all_nfts[i] = nfts[i+1] ;
        }

        return all_nfts ;
    }

}
