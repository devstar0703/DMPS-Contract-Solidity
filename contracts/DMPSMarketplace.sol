// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract DMPSMarketplace is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter ;

    Counters.Counter nft_counter ;

    uint256 public constant MAX_MINT_AMOUNT = 2 ;
    uint256 public constant MAX_SUPPLY = 5555 ;
    uint256 public constant MINT_PRICE = 0.0035 ether ;

    uint256 internal wl_open_time ;
    uint256 internal pb_open_time ;

    mapping(address=>bool) public white_list_addrs;

    constructor() ERC721("Deviants Silver Mint Pass", "DMPS") {
        wl_open_time = block.timestamp + 86400 ;
        pb_open_time = block.timestamp + 86400 * 2 ;

        white_list_addrs[0x61611Be3dB30D0E960918aC4761d744a8D568647] = true;
        white_list_addrs[0xabd43DAA71c365420f7c03ab90140CA5cC70b719] = true;
        white_list_addrs[0x1805c49AE4392F1DF411F665fDB5c6bD77b23D4a] = true;
        white_list_addrs[0xC4c282C70faABF0043FA2f7548DaCf676cfAb0CC] = true;
    }

    function safeMint(address to, uint amount)
        internal
    {
        for(uint x = amount; x > 0; x--){
            uint id = nft_counter.current();

            require(id < MAX_SUPPLY, "mintNFT: overflow supply") ;

            nft_counter.increment();
            _safeMint(to, id);
            _setTokenURI(id, Strings.toString(id));
        }
    }

    function mintNFT(uint amount) public payable returns(bool) {
        require(amount <= MAX_MINT_AMOUNT, "mintNFT: overflow max amount");
        require(MAX_MINT_AMOUNT - balanceOf(msg.sender) >= amount, "mintNFT: overflow total mint amount");
        require(msg.value == MINT_PRICE * (amount - 1) , "mintNFT: insufficient value");

        if (( isWhiteList() && block.timestamp < wl_open_time ) ||
            ( !isWhiteList() && block.timestamp < pb_open_time ) 
        ) {
            safeMint(msg.sender, amount) ;
        } else revert TimeOut();

        return true ;
    }

    function getCurrentTimeStamp() public view returns(uint256) {
        return block.timestamp;
    }

    function isWhiteList() private view returns(bool){
        if(white_list_addrs[msg.sender]) return true ;
        return false;
    }

    function balanceOfMinter() public view returns(uint) {
        return balanceOf(msg.sender);
    }
    
    error TimeOut() ;
}
