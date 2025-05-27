# Stacks Crypto Card NFT Platform

A comprehensive NFT platform for creating, trading, and upgrading collectible crypto cards on the Stacks blockchain.

## Overview

This project implements a full-featured NFT card system with marketplace functionality, rarity tiers, card upgrades, and user statistics tracking. Built on the Stacks blockchain using Clarity smart contracts.

## Features

- **NFT Card Creation**: Mint unique cards with customizable attributes and metadata
- **Rarity System**: Six tiers of rarity from Common to Mythic
- **Marketplace**: List, buy, and sell cards with automatic fee handling
- **Upgrade System**: Earn experience and level up cards
- **Series Management**: Organize cards into series with optional supply limits
- **User Statistics**: Track ownership, trading activity, and more

## Contract Structure

The main contract (`cryptp-card_contract.clar`) contains the following components:

- NFT definition and core functionality
- Data maps for card details, ownership, and status
- Marketplace listings and operations
- User statistics tracking
- Card upgrade mechanics
- Series information management

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) for local development and testing
- [Stacks CLI](https://github.com/blockstack/stacks.js) for deployment

### Setup

1. Clone the repository
2. Install dependencies: `npm install`
3. Run tests: `clarinet test`

### Local Development

Use the Clarinet console to interact with the contract:

```bash
clarinet console
```

## Deployment

### Testnet Deployment

```bash
clarinet deploy --testnet
```

### Mainnet Deployment

```bash
clarinet deploy --mainnet
```

## Testing

Run the test suite:

```bash
clarinet test
```

## License

[MIT License](LICENSE)