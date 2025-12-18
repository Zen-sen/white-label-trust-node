// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TrustBunnies is ERC721 {
    event EggHatched(address indexed owner, uint256 indexed bunnyId, string name, uint256 gene, uint8 rarity);

    struct Bunny {
        string name;
        uint256 gene;        // 256-bit DNA
        uint8  rarity;       // 0=common, 1=rare, 2=epic, 3=legendary
    }

    Bunny[] public bunnies;               // all bunnies ever hatched
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public mintPrice = 0.001 ether; // pay to hatch (like CryptoKitties gen-0)
    uint256 public bunnyCounter;            // total minted

    constructor() ERC721("TrustBunny", "BUNNY") {}

    // ---- CHAPTER 1 ACTION ----
    function hatchEgg(string memory _name) external payable returns (uint256 bunnyId) {
        require(bunnyCounter < MAX_SUPPLY, "All eggs hatched");
        require(msg.value >= mintPrice, "Not enough ether for hatching fee");

        uint256 gene = _generateGene();                 // pseudo-random DNA
        uint8 rarity = _calcRarity(gene);               // 0-3 star rarity

        bunnies.push(Bunny(_name, gene, rarity));
        bunnyId = bunnies.length - 1;
        _safeMint(msg.sender, bunnyId);
        bunnyCounter++;

        emit EggHatched(msg.sender, bunnyId, _name, gene, rarity);
    }

    function _generateGene() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, bunnyCounter)));
    }

    function _calcRarity(uint256 gene) private pure returns (uint8) {
        uint256 raritySeed = gene % 1000;
        if (raritySeed < 700) return 0;      // 70 % common
        if (raritySeed < 900) return 1;      // 20 % rare
        if (raritySeed < 980) return 2;      // 8 % epic
        return 3;                            // 2 % legendary
    }

    function getBunny(uint256 bunnyId) external view returns (Bunny memory) {
        return bunnies[bunnyId];
    }
}
