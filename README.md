cat <<EOF >> README.md

## 📁 Repository Structure
\`\`\`text
.
├── contracts/
│   ├── Diamond.sol                 # The Prism (Proxy)
│   ├── facets/                     # Logic Scrolls
│   │   ├── BunnyFactoryFacet.sol   # Breeding & Minting
│   │   └── AncestralHeritageFacet.sol # Tribal Alignment
│   ├── libraries/                  # Shared Wisdom
│   │   ├── LibAppStorage.sol       # State Memory
│   │   └── AncestralUtils.sol      # Genetic Math
│   └── interfaces/                 # Sacred Contracts
├── scripts/                        # Deployment Rites
├── docs/                           # GDD & White Paper
└── hardhat.config.ts               # The Blueprint Config
\`\`\`
EOF
