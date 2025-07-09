import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/address_book_widget.dart';
import './widgets/address_display_widget.dart';
import './widgets/amount_request_widget.dart';
import './widgets/balance_display_widget.dart';
import './widgets/coin_selector_widget.dart';
import './widgets/qr_code_widget.dart';

class ReceiveCryptocurrency extends StatefulWidget {
  const ReceiveCryptocurrency({Key? key}) : super(key: key);

  @override
  State<ReceiveCryptocurrency> createState() => _ReceiveCryptocurrencyState();
}

class _ReceiveCryptocurrencyState extends State<ReceiveCryptocurrency> {
  String selectedCoin = 'Bitcoin';
  String walletAddress = '';
  double requestAmount = 0.0;
  bool isGeneratingAddress = false;
  List<Map<String, dynamic>> addressHistory = [];

  // Mock cryptocurrency data
  final List<Map<String, dynamic>> supportedCoins = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'icon': 'currency_bitcoin',
      'address': 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
      'balance': 0.00234567,
      'usdValue': 156.78,
    },
    {
      'name': 'Ethereum',
      'symbol': 'ETH',
      'icon': 'account_balance_wallet',
      'address': '0x742d35Cc6634C0532925a3b8D0c9e4e7fDc5c4e8',
      'balance': 1.2345,
      'usdValue': 2456.89,
    },
    {
      'name': 'Litecoin',
      'symbol': 'LTC',
      'icon': 'monetization_on',
      'address': 'ltc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4',
      'balance': 5.67890,
      'usdValue': 423.45,
    },
    {
      'name': 'Cardano',
      'symbol': 'ADA',
      'icon': 'account_balance',
      'address': 'addr1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
      'balance': 1250.0,
      'usdValue': 312.50,
    },
  ];

  // Mock address book data
  final List<Map<String, dynamic>> savedAddresses = [
    {
      'label': 'Exchange Wallet',
      'address': 'bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh',
      'coin': 'Bitcoin',
      'lastUsed': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'label': 'Hardware Wallet',
      'address': '0x742d35Cc6634C0532925a3b8D0c9e4e7fDc5c4e8',
      'coin': 'Ethereum',
      'lastUsed': DateTime.now().subtract(Duration(days: 5)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeWalletAddress();
  }

  void _initializeWalletAddress() {
    final selectedCoinData = supportedCoins.firstWhere(
      (coin) => (coin['name'] as String) == selectedCoin,
      orElse: () => supportedCoins.first,
    );
    setState(() {
      walletAddress = selectedCoinData['address'] as String;
    });
  }

  void _onCoinChanged(String newCoin) {
    setState(() {
      selectedCoin = newCoin;
      _initializeWalletAddress();
      requestAmount = 0.0;
    });
  }

  void _onAmountChanged(double amount) {
    setState(() {
      requestAmount = amount;
    });
  }

  Future<void> _generateNewAddress() async {
    setState(() {
      isGeneratingAddress = true;
    });

    // Simulate address generation delay
    await Future.delayed(Duration(seconds: 2));

    final selectedCoinData = supportedCoins.firstWhere(
      (coin) => (coin['name'] as String) == selectedCoin,
    );

    // Mock new address generation
    String newAddress;
    switch (selectedCoin) {
      case 'Bitcoin':
        newAddress =
            'bc1q${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        break;
      case 'Ethereum':
        newAddress =
            '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
        break;
      case 'Litecoin':
        newAddress =
            'ltc1q${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
        break;
      default:
        newAddress =
            'addr1q${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    }

    // Add to address history
    addressHistory.insert(0, {
      'address': walletAddress,
      'coin': selectedCoin,
      'generatedAt': DateTime.now(),
    });

    setState(() {
      walletAddress = newAddress;
      isGeneratingAddress = false;
    });

    Fluttertoast.showToast(
      msg: "New address generated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _copyAddress() async {
    await Clipboard.setData(ClipboardData(text: walletAddress));
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: "Address copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _shareQRCode() async {
    // Mock sharing functionality
    HapticFeedback.mediumImpact();

    Fluttertoast.showToast(
      msg: "QR code shared successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> _saveToPhotos() async {
    // Mock save to photos functionality
    HapticFeedback.mediumImpact();

    Fluttertoast.showToast(
      msg: "QR code saved to photos",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showAddressBook() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressBookWidget(
        savedAddresses: savedAddresses,
        onAddressSelected: (address) {
          setState(() {
            walletAddress = address;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCoinData = supportedCoins.firstWhere(
      (coin) => (coin['name'] as String) == selectedCoin,
      orElse: () => supportedCoins.first,
    );

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Receive Cryptocurrency',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddressBook,
            icon: CustomIconWidget(
              iconName: 'contact_page',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/security-settings'),
            icon: CustomIconWidget(
              iconName: 'security',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Balance Display
              BalanceDisplayWidget(
                coinData: selectedCoinData,
              ),

              SizedBox(height: 3.h),

              // Coin Selector
              CoinSelectorWidget(
                supportedCoins: supportedCoins,
                selectedCoin: selectedCoin,
                onCoinChanged: _onCoinChanged,
              ),

              SizedBox(height: 4.h),

              // QR Code Display
              QRCodeWidget(
                walletAddress: walletAddress,
                requestAmount: requestAmount,
                coinSymbol: selectedCoinData['symbol'] as String,
              ),

              SizedBox(height: 3.h),

              // Address Display
              AddressDisplayWidget(
                walletAddress: walletAddress,
                onCopyPressed: _copyAddress,
              ),

              SizedBox(height: 3.h),

              // Amount Request
              AmountRequestWidget(
                coinSymbol: selectedCoinData['symbol'] as String,
                onAmountChanged: _onAmountChanged,
              ),

              SizedBox(height: 4.h),

              // Action Buttons
              ActionButtonsWidget(
                onSharePressed: _shareQRCode,
                onSavePressed: _saveToPhotos,
                onGenerateNewPressed: _generateNewAddress,
                isGenerating: isGeneratingAddress,
              ),

              SizedBox(height: 2.h),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/portfolio-dashboard'),
                      child: Text('Portfolio'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/send-cryptocurrency'),
                      child: Text('Send Crypto'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
