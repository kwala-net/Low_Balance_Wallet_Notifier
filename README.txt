# 🔔 Low Balance Wallet Notifier

A blockchain automation project built on [Kwala](https://kwala.network) that monitors Polygon wallet balances and sends real-time Telegram notifications when balances fall below a specified threshold.

## 📋 Overview

This project combines smart contracts and automated workflows to ensure you never run out of gas unexpectedly. It monitors native POL balances on Polygon and alerts you via Telegram when your balance drops below 0.1 POL, giving you time to top up before transactions fail.

## ✨ Features

- **Real-time Monitoring**: Automatically tracks wallet POL balance on Polygon network
- **Dual Trigger System**:
  - Event-based notifications when balance drops below threshold
  - Scheduled polling every minute for continuous monitoring
- **Instant Alerts**: Telegram notifications sent immediately when low balance is detected
- **Low Threshold**: Configurable threshold (default: 0.1 POL)
- **No Manual Checking**: Fully automated - set it and forget it
- **Reliable Execution**: Built-in retry mechanism (up to 5 attempts) for notification delivery

## 🏗️ Architecture

### Components

1. **Smart Contract** (`BalanceCheck.sol`)
   - Deployed on Polygon Amoy Testnet (Chain ID: 80002)
   - Emits `LowPolBalance` event when balance < 0.1 POL
   - Provides read-only balance checking functions

2. **Event-Driven Workflow** (`LowBalanceNotification.yaml`)
   - Listens for `LowPolBalance` events from the smart contract
   - Triggers Telegram notification when event is detected
   - Responds instantly to balance changes

3. **Polling Workflow** (`Polling.yaml`)
   - Calls `checkAndWarn()` function every minute
   - Ensures continuous monitoring even if events are missed
   - Provides redundant safety layer

## 🛠️ Prerequisites

Before you begin, ensure you have:

- A [Kwala](https://kwala.network) account
- A Telegram bot (create one via [@BotFather](https://t.me/botfather))
- Your Telegram Chat ID
- A wallet address to monitor on Polygon
- Access to Polygon Amoy Testnet

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/low-balance-wallet-notifier.git
   cd low-balance-wallet-notifier
   ```

2. **Deploy the Smart Contract**
   - Deploy `BalanceCheck.sol` to Polygon Amoy Testnet
   - Note the deployed contract address
   - Verify the contract on PolygonScan (optional but recommended)

3. **Configure Telegram Bot**
   - Create a bot using [@BotFather](https://t.me/botfather)
   - Get your bot token
   - Get your Chat ID (use [@userinfobot](https://t.me/userinfobot))

## ⚙️ Configuration

### 1. Update Workflow Files

**LowBalanceNotification.yaml:**
```yaml
Trigger:
  TriggerSourceContract: YOUR_CONTRACT_ADDRESS  # Replace with deployed address

Actions:
  - Name: telegram_notifier
    APIEndpoint: https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage
    APIPayload:
      chat_id: 'YOUR_CHAT_ID'
      text: LOW BALANCE! Recharge your wallet. Add 5 POL
```

**Polling.yaml:**
```yaml
Actions:
  - Name: Polling1
    TargetContract: YOUR_CONTRACT_ADDRESS  # Replace with deployed address
    TargetParams:
      - YOUR_WALLET_ADDRESS  # Replace with wallet to monitor
```

### 2. Deploy Workflows to Kwala

1. Log in to your [Kwala Dashboard](https://kwala.network)
2. Create a new workflow
3. Upload `LowBalanceNotification.yaml`
4. Repeat for `Polling.yaml`
5. Activate both workflows

## 🚀 Usage

Once deployed and configured, the system runs automatically:

1. **Continuous Monitoring**: The polling workflow checks your balance every minute
2. **Event Detection**: When balance drops below 0.1 POL, the contract emits an event
3. **Instant Notification**: You receive a Telegram message: "LOW BALANCE! Recharge your wallet. Add 5 POL"
4. **Manual Check**: You can also call `checkMe()` on the contract to trigger an immediate check

### Manual Balance Check

You can manually trigger a balance check by calling the contract:

```javascript
// Using ethers.js
const balance = await contract.checkMe();
console.log(`Your balance: ${ethers.utils.formatEther(balance)} POL`);
```

## 📁 Project Structure

```
low-balance-wallet-notifier/
├── BalanceCheck.sol               # Smart contract for balance checking
├── LowBalanceNotification.yaml    # Event-triggered notification workflow
├── Polling.yaml                   # Scheduled polling workflow
└── README.md                      # This file
```

## 🔧 Smart Contract Functions

### `polBalanceOf(address user)`
- **Type**: View function
- **Returns**: Balance in wei
- **Purpose**: Read-only balance checker

### `checkAndWarn(address user)`
- **Type**: State-changing function
- **Returns**: Balance in wei
- **Purpose**: Checks balance and emits event if below threshold

### `checkMe()`
- **Type**: State-changing function
- **Returns**: Balance in wei
- **Purpose**: Convenience function to check caller's own balance

## 🔍 Events

### `LowPolBalance(address indexed user, uint256 balanceWei)`
Emitted when a wallet's balance falls below 0.1 POL

## 🌐 Network Information

- **Network**: Polygon Amoy Testnet
- **Chain ID**: 80002
- **Threshold**: 0.1 POL (100000000000000000 wei)
- **RPC URL**: https://rpc-amoy.polygon.technology/

## 🎨 Customization

### Change the Threshold

Edit `BalanceCheck.sol` line 8:
```solidity
uint256 public constant THRESHOLD = 0.1 ether; // Change to your desired amount
```

### Modify Notification Message

Edit `LowBalanceNotification.yaml`:
```yaml
text: Your custom message here
```

### Adjust Polling Frequency

Edit `Polling.yaml`:
```yaml
RepeatEvery: 5m  # Options: 1m, 5m, 30m, 1h, etc.
```

## 🛡️ Security Considerations

- Never commit sensitive data (bot tokens, chat IDs) to version control
- Use environment variables or secrets management for production
- Consider implementing access controls on the smart contract
- Monitor Kwala workflow execution logs for anomalies

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Kwala Network](https://kwala.network)
- Deployed on [Polygon](https://polygon.technology)
- Notifications via [Telegram Bot API](https://core.telegram.org/bots/api)

## 📚 Resources

- [Kwala Documentation](https://kwala.network/docs)
- [Kwala Use Case Guide](https://kwala.network/docs/use-cases/low-wallet-balance-notifier)
- [Polygon Documentation](https://docs.polygon.technology)
- [Telegram Bot API](https://core.telegram.org/bots/api)

## 💬 Support

If you encounter any issues or have questions:

- Open an issue on GitHub
- Check [Kwala Documentation](https://kwala.network/docs)
- Join the Kwala community

## 🗺️ Roadmap

- [ ] Support for multiple wallet monitoring
- [ ] Customizable threshold per wallet
- [ ] Support for ERC-20 token balance monitoring
- [ ] Discord/Slack notification options
- [ ] Web dashboard for monitoring multiple wallets
- [ ] Email notification support
- [ ] Multi-chain support (Ethereum, BSC, Arbitrum, etc.)

---

**Made with ❤️ using Kwala Network**

⭐ Star this repo if you find it useful!

https://kwala.network/docs/use-cases/low-wallet-balance-notifier
