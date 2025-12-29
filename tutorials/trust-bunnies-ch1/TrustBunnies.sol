// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Lesson 1 – DNA Factory
uint256 constant DNA_DIGITS = 16;
uint256 constant DNA_MODULUS = 10 ** DNA_DIGITS;

/**
 * @title TrustBunnies
 * @author Zen-sen
 * @notice Chapter 1 – Hatch courier-bunny NFTs. Gene determines rarity.
 */
contract TrustBunnies is ERC721 {
    event EggHatched(address indexed owner, uint256 indexed bunnyId, string name, uint256 gene, uint8 rarity);

    uint256 public constant MAX_SUPPLY = 10_000;
    uint256 public constant MINT_PRICE  = 0.001 ether;

    struct Bunny {
        string  name;
        uint256 gene;
        uint8   rarity;        // 0-99 roll
        uint32  cooldownEnd;   // Chapter-2 ready
        uint32  parentIdA;     // lineage
        uint32  parentIdB;
    }

    Bunny[] public bunnies;
    uint256 public bunnyCounter;

    constructor() ERC721("TrustBunny", "BUNNY") {}

    function hatchEgg(string memory _name) external payable returns (uint256 bunnyId) {
        require(bunnyCounter < MAX_SUPPLY, "All eggs hatched");
        require(msg.value >= MINT_PRICE,   "Not enough ether for hatching fee");

        uint256 gene = _generateRandomDna(_name);
        _createBunny(_name, gene);
        bunnyId = bunnies.length - 1;
    }

    function getBunny(uint256 bunnyId) external view returns (Bunny memory) {
        return bunnies[bunnyId];
    }

    function _createBunny(string memory _name, uint256 _dna) internal {
        uint8 rarity = uint8(_dna % 100);
        bunnies.push(Bunny(_name, _dna, rarity, 0, 0, 0));
        uint256 id = bunnies.length - 1;
        _safeMint(msg.sender, id);
        bunnyCounter++;
        emit EggHatched(msg.sender, id, _name, _dna, rarity);
    }

    function _generateRandomDna(string memory _str) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_str, block.timestamp, block.difficulty, bunnyCounter))) % DNA_MODULUS;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://zen-sen.github.io/white-label-trust-node/bunnies/";
    }
}