//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

/*
ERC721 is an ERC20 token where each token has a unique ID and can have an URL for more MetaData.
It actually has its roots in real estate deeds. A big misconception is that NFT MetaData should be immutable.
but in reality, it is mutable (changeable).
That's why a good practice is to put the MetaData, which is just a regular json file, somewhere on a regular host.
*/

/*
METADATA
Each NFT contract can optionally add the MetaData extension. In reality, most have. The extension defines that a 
json file is downloaded at a specific URI.

The content for that json file can look something like this for example:
{
    "title": "Asset Metadata",
    "type": "object",
    "properties": {
        "name": {
            "type": "string",
            "description": "Identifies the asset to which this NFT represents"
        },
        "description": {
            "type": "string",
            "description": "Describes the asset to which this NFT represents"
        },
        "image": {
            "type": "string",
            "description": "A URI pointing to a resource with mime type image/* 
            representing the asset to which this NFT represents. Consider making 
            any images at a width between 320 and 1080 pixels and aspect ratio 
            between 1.91:1 and 4:5 inclusive."
        }
    }
}

If you'd deploy an ERC721 token that points to this MetaData and you look at it on 
OpenSea, you'd see the content parsed.
*/

/*
EXAMPLE TOKEN 
Let's have a look at an existing example. Take Token #4 from the RTFKT Collection
link -> https://opensea.io/assets/ethereum/0xa49a0e5ef83cf89ac8aae182f22e6464b229efc8/4

Besides the price, you see three things here:

The Animation or a Picture
A Description
A couple of properties

Where do they come from? Let's check out Etherscan...
Above token's address -> 0xa49a0e5ef83cf89ac8aae182f22e6464b229efc8

When i view my acc. on etherscan ->
https://goerli.etherscan.io/address/0x3e900830bfb449ee5f41d853a205dbd5198768d2
if i remove the goerli. from starting and add the above token's address, i'll be able to 
open it on etherscan.

To open the same token on etherscan, copy its address, from your metamask, if you view your acc.
on etherscan, then remove the starting testnetwork name and in the end replace the address with 
the above RTFKT token address, and then select read Contract to read it.

If you query the tokenUri for Token #4 On Etherscan then you'd see an ipfs url pointing to a json file:
Note: add the token no. i.e. 4 in the above input section or else you won't get any ipfs url.
Now, IPFS is a decentralized file storage and all you need to know at this point is that it can host files. 
But how can you access IPFS files? There are two major ways:
You install the IPFS daemon and can browse files locally
You use an IPFS gateway.


If you open the file on an IPFS Gateway, 
like the one from ipfs.io: https://ipfs.io/ipfs/QmU1CNuwJZTxc6FZqKLsUPVjPrR1Fg2U79sNDYQozpBj7w/genesis/4.json, 
you see the following json file:

{
    "name": "CLONE X Genesis Socks 🧬",
    "description": "CLONE X FORGING SEASON 1 🧬⚒️\n\nIntroducing the future of Fashion.\n\nRTFKT invented the world merging Forging mechanic, allowing its collectors to redeem exclusive physical products from NFTs.\n\nToday RTFKT takes Forging to the next level with Clone X Forging. ⚒️\n\n10 unique Brands and bespoke fashion collections for Clone X Holders. Each brand will be accessible for Clone X holders based on the DNA of the Clone they own. 🧬🌸\n\nSee the full collection: [http://lookbook.rtfkt.com](http://lookbook.rtfkt.com) 👀\n\n*Not equipped with NFC Tag 🔗.\n\nDigital Collectible terms and conditions apply, see [https://rtfkt.com/legal-2D](https://rtfkt.com/legal-2D) 👨‍⚖️\n\nDigital Collectible: Wearable & Forging-Eligible (this 1155 Token will be swapped for a 721 Token when forging)\n\nForging terms apply, see: [https://rtfkt.com/legal-1B](https://rtfkt.com/legal-1B) 👨‍⚖️",
    "image": "ipfs://QmWpbme9ECzeNZDbpe5kJKRmiL6WhKGJJZ9RbHb5ioLeHD/genesis/4.webp",
    "animation_url": "ipfs://QmWpbme9ECzeNZDbpe5kJKRmiL6WhKGJJZ9RbHb5ioLeHD/genesis/4.mp4",
    "external_url": "https://rtfkt.com",
    "attributes": [
        {
            "trait_type": "Artefact", 
            "value": "Socks"
        },
        {
            "trait_type": "Collection", 
            "value": "Genesis"
        }
    ]
}
You can compare this to the sample MetaData Schema from above
*/


//? To check my NFT token uri -: 
// Click the Contract tab. Then click Read Contract. Then find a field called tokenURI. 
// Enter your Token ID in this field, then click Query.


//? what is metadata in ERC721 ?
// This standard defines metadata as tokenURI which is referring to IPFS (or other storage 
// provider service) URL (link). ERC721 is using tokenURI which is a unique resource identifier 
// of the NFT itself. This can be linked to a server where the metadata — picture (file) is stored.


// for writing ER721 token, using https://docs.openzeppelin.com/contracts/4.x/wizard , in ER721, select
// mintable - auto increment ids, URI storage ( for storing all tokens with a well defined name )
// i.e. https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/1.json
// and https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_1.json
// So, in the above 2 links, after nftdata/ , in first one, if we don't use URI storage, then directly add the 
// token no. i.e. 1 but if we use URI storage then we can define proper name for calling different tokens like
// nftdata/spacebear_1.json

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Spacebear is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Spacebear", "SBR") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/";
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}

// after deploying this contract on metamask, and using safeMint to any address ( suppose we take the deployed contract 
// address itself, then in uri parameter of safeMint, we type spacebear_1.json and transact this contract, then 
// when you enter 0 in tokenURI, then you will get a string i.e. the link, copy it and paste it on your browser,
// in the browser, you'll get the json code like this - :

// {
// "name": "Spacebear Token 🧸",
// "description": "Introducing the future of Cuteness. A Teddybear Token. Floating in Space. Save them by getting this NFT. Cuddle each one of them. You need them. Buy them now. Also, they are coming from ethereum-blockchain-developer.com",
// "image": "https://ethereum-blockchain-developer.com/2022-06-nft-truffle-hardhat-foundry/nftdata/spacebear_2.webp",
// "external_url": "https://ethereum-blockchain-developer.com",
// "attributes": [
// {
// "trait_type": "Artefact",
// "value": "Teddybear"
// },
// {
// "trait_type": "Collection",
// "value": "Genesis"
// }
// ]
// }

// Now, at the time of deploying , click on view on etherscan to open the block explorer, then in the contract, click on the
// Interacted with (To): address, you'll get navigated to the contract, it is not verified yet, copy the contract address
// and then type https://testnets.opensea.io/assets/goerli/<contract token address that you copied>/<token no.>
// eg. https://testnets.opensea.io/assets/goerli/0xB6EcdA8096c364D6efce271116972d11CC7D0A42/0
// as you press enter, your browser will navigate you to OpenSea Testnets where you can see pulled metadata and it'll
// pull the image from the ethereum blockchain developer service.