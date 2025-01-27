# Memecoin Treasury Smart Contract

A Clarity smart contract implementation for managing a memecoin treasury with sBTC integration. This project demonstrates a vesting schedule mechanism for token releases with proper access controls.

## Overview

The Memecoin Treasury consists of two main contracts:
- `sbtc-token.clar`: A mock sBTC token implementation for testing purposes
- `memecoin-treasury.clar`: The main treasury contract that manages deposits and scheduled withdrawals

## Features

- 🔒 Secure treasury management
- 📅 Configurable release schedule
- 🔄 sBTC deposit and withdrawal functionality
- 👤 Owner-only administrative functions
- 📊 Balance and schedule tracking

## Installation

1. Install Clarinet:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install clarinet
```

2. Clone the repository:
```bash
git clone https://github.com/yourusername/memecoin-treasury.git
cd memecoin-treasury
```

3. Test the contracts:
```bash
clarinet check
clarinet test
```

## Contract Details

### sBTC Token Contract

A mock implementation of the sBTC token for testing purposes.

```clarity
(define-trait sbtc-trait
    (
        (transfer (uint principal principal) (response bool uint))
    )
)
```

### Treasury Contract

The main treasury contract that handles:
- Deposit of sBTC tokens
- Scheduled withdrawals
- Release schedule management

```clarity
(define-public (deposit-sbtc (sbtc-token <sbtc-trait>) (amount uint))
(define-public (withdraw-sbtc (sbtc-token <sbtc-trait>))
(define-public (set-release-schedule (schedule (list 10 {amount: uint, block-height: uint})))
```

## Usage Examples

### Setting a Release Schedule

```clarity
;; Create a release schedule
(contract-call? .memecoin-treasury set-release-schedule 
    (list 
        {amount: u1000, block-height: u100}
        {amount: u2000, block-height: u200}
        {amount: u3000, block-height: u300}
    )
)
```

### Depositing sBTC

```clarity
;; Deposit 1000 sBTC into the treasury
(contract-call? .memecoin-treasury deposit-sbtc .sbtc-token u1000)
```

### Withdrawing sBTC

```clarity
;; Withdraw available sBTC based on the release schedule
(contract-call? .memecoin-treasury withdraw-sbtc .sbtc-token)
```

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Owner-only function called by non-owner |
| u101 | Invalid amount specified |
| u102 | Invalid release schedule |
| u103 | Funds are locked (not withdrawable) |

## Testing

Run the test suite:
```bash
clarinet test
```

## Development

1. Make changes to the contracts in the `contracts/` directory
2. Run `clarinet check` to verify syntax
3. Run `clarinet test` to run the test suite
4. Deploy using Clarinet console or your preferred deployment method

## Security Considerations

- Only the contract owner can set the release schedule and withdraw funds
- Release schedule cannot be modified once tokens are deposited
- Withdrawals are strictly controlled by the block height-based schedule
- All functions include proper checks and balances

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Support

For support, please open an issue in the GitHub repository or contact the development team.

---

Built with ❤️ using Clarity and Stacks blockchain technology.