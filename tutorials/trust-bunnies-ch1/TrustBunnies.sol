// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title TrustBunnies
 * @author Zen-sen
 * @notice Chapter 1 – Hatch courier-bunny NFTs. Gene determines rarity.
 */
contract TrustBunnies is ERC721 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event EggHatched(address indexed owner, uint256 indexed bunnyId, string name, uint256 gene, uint8 rarity);

    /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/
    uint256 public constant MAX_SUPPLY = 10_000; // narrative cap (like CryptoKitties)
    uint256 public constant MINT_PRICE = 0.001 ether; // cheap on Mumbai

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/
    struct Bunny {
        string name;
        uint256 gene; // 256-bit DNA
        uint8  rarity; // 0=common, 1=rare, 2=epic, 3=legendary
    }

    Bunny[] public bunnies;               // all parcels ever hatched
    uint256 public bunnyCounter;          // total minted

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() ERC721("TrustBunny", "BUNNY") {}

    /*//////////////////////////////////////////////////////////////
                            MINT LOGIC
    //////////////////////////////////////////////////////////////*/
    /// @notice Hatch a new courier bunny egg; caller becomes owner.
    /// @param _name Bunny’s call-sign (visible in NFT metadata).
    /// @return bunnyId Token ID of the newly minted NFT.
    function hatchEgg(string memory _name) external payable returns (uint256 bunnyId) {
        require(bunnyCounter < MAX_SUPPLY, "All eggs hatched");
        require(msg.value >= MINT_PRICE, "Not enough ether for hatching fee");

        uint256 gene = _generateGene();
        uint8 rarity = _calcRarity(gene);

        bunnies.push(Bunny(_name, gene, rarity));
        bunnyId = bunnies.length - 1;
        _safeMint(msg.sender, bunnyId);
        bunnyCounter++;

        emit EggHatched(msg.sender, bunnyId, _name, gene, rarity);
    }

    /*//////////////////////////////////////////////////////////////
                            VIEW HELPERS
    //////////////////////////////////////////////////////////////*/
    /// @dev Returns full Bunny struct for front-end.
    function getBunny(uint256 bunnyId) external view returns (Bunny memory) {
        return bunnies[bunnyId];
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL UTILS
    //////////////////////////////////////////////////////////////*/
    function _generateGene() private view returns (uint256) {
        // Uses prevrandao (post-Paris) to avoid Remix warning
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender, bunnyCounter)));
    }

    function _calcRarity(uint256 gene) private pure returns (uint8) {
        uint256 seed = gene % 1000;
        if (seed < 700) return 0;      // 70 % common
        if (seed < 900) return 1;      // 20 % rare
        if (seed < 980) return 2;      // 8 % epic
        return 3;                      // 2 % legendary
    }

    /// @dev Base URI for metadata (GitHub Pages ready).
    function _baseURI() internal pure override returns (string memory) {
        return "https://zen-sen.github.io/white-label-trust-node/bunnies/";
    }
}