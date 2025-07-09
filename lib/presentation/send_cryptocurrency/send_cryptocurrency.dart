import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/address_book_widget.dart';
import './widgets/amount_input_widget.dart';
import './widgets/coin_selector_widget.dart';
import './widgets/network_fee_widget.dart';
import './widgets/qr_scanner_widget.dart';
import './widgets/recipient_address_widget.dart';
import './widgets/transaction_summary_widget.dart';

class SendCryptocurrency extends StatefulWidget {
  const SendCryptocurrency({Key? key}) : super(key: key);

  @override
  State<SendCryptocurrency> createState() => _SendCryptocurrencyState();
}

class _SendCryptocurrencyState extends State<SendCryptocurrency>
    with TickerProviderStateMixin {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customFeeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedCoin = 'BTC';
  String _selectedFeeType = 'Standard';
  bool _isLoading = false;
  bool _showQRScanner = false;
  bool _showAddressBook = false;
  bool _showCustomFee = false;
  bool _isAddressValid = false;
  double _usdConversion = 0.0;
  String _transactionHash = '';
  bool _transactionSuccess = false;

  // Mock data for cryptocurrencies
  final List<Map<String, dynamic>> _cryptocurrencies = [
    {
      "symbol": "BTC",
      "name": "Bitcoin",
      "balance": 0.00234567,
      "usdValue": 42350.50,
      "icon": "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
    },
    {
      "symbol": "ETH",
      "name": "Ethereum",
      "balance": 1.45678901,
      "usdValue": 2650.75,
      "icon": "https://cryptologos.cc/logos/ethereum-eth-logo.png",
    },
    {
      "symbol": "ADA",
      "name": "Cardano",
      "balance": 1250.789,
      "usdValue": 0.485,
      "icon": "https://cryptologos.cc/logos/cardano-ada-logo.png",
    },
    {
      "symbol": "DOT",
      "name": "Polkadot",
      "balance": 45.6789,
      "usdValue": 7.25,
      "icon": "https://cryptologos.cc/logos/polkadot-new-dot-logo.png",
    },
  ];

  // Mock data for address book
  final List<Map<String, dynamic>> _addressBook = [
    {
      "name": "John Doe",
      "address": "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa",
      "coin": "BTC",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "name": "Alice Smith",
      "address": "0x742d35Cc6634C0532925a3b8D404fddBD4f4d4d4",
      "coin": "ETH",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "name": "Bob Johnson",
      "address":
          "addr1qx2fxv2umyhttkxyxp8x0dlpdt3k6cwng5pxj3jhsydzer3jcu5d8ps7zex2k2xt3uqxgjqnnj0vs2qd4a",
      "coin": "ADA",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  // Mock data for network fees
  final Map<String, Map<String, dynamic>> _networkFees = {
    "Slow": {
      "time": "30-60 min",
      "fee": 0.00001,
      "usdFee": 0.42,
    },
    "Standard": {
      "time": "10-20 min",
      "fee": 0.00003,
      "usdFee": 1.27,
    },
    "Fast": {
      "time": "2-5 min",
      "fee": 0.00008,
      "usdFee": 3.39,
    },
  };

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateUSDConversion);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _customFeeController.dispose();
    super.dispose();
  }

  void _updateUSDConversion() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final selectedCrypto = _cryptocurrencies.firstWhere(
      (crypto) => crypto['symbol'] == _selectedCoin,
      orElse: () => _cryptocurrencies[0],
    );
    setState(() {
      _usdConversion = amount * (selectedCrypto['usdValue'] as double);
    });
  }

  void _validateAddress(String address) {
    setState(() {
      _isAddressValid = address.length > 20 && address.isNotEmpty;
    });
  }

  void _onQRScanned(String scannedData) {
    setState(() {
      _addressController.text = scannedData;
      _showQRScanner = false;
    });
    _validateAddress(scannedData);
  }

  void _onAddressSelected(String address) {
    setState(() {
      _addressController.text = address;
      _showAddressBook = false;
    });
    _validateAddress(address);
  }

  void _setMaxAmount() {
    final selectedCrypto = _cryptocurrencies.firstWhere(
      (crypto) => crypto['symbol'] == _selectedCoin,
      orElse: () => _cryptocurrencies[0],
    );
    setState(() {
      _amountController.text = (selectedCrypto['balance'] as double).toString();
    });
  }

  Future<void> _sendTransaction() async {
    if (!_formKey.currentState!.validate() || !_isAddressValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate biometric authentication
    await _showBiometricDialog();

    // Simulate transaction processing
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isLoading = false;
      _transactionSuccess = true;
      _transactionHash = '0x1234567890abcdef1234567890abcdef12345678';
    });

    _showSuccessDialog();
  }

  Future<void> _showBiometricDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'fingerprint',
                size: 64,
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Biometric Authentication',
                style: AppTheme.lightTheme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Please verify your identity to complete the transaction',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Authenticate'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                size: 64,
                color: AppTheme.successLight,
              ),
              SizedBox(height: 2.h),
              Text(
                'Transaction Sent!',
                style: AppTheme.lightTheme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your transaction has been broadcast to the network',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _transactionHash,
                  style: AppTheme.getMonospaceStyle(
                    isLight: true,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: _transactionHash));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Transaction hash copied')),
                        );
                      },
                      child: const Text('Copy Hash'),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Send Cryptocurrency'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coin Selector
                    CoinSelectorWidget(
                      cryptocurrencies: _cryptocurrencies,
                      selectedCoin: _selectedCoin,
                      onCoinSelected: (coin) {
                        setState(() {
                          _selectedCoin = coin;
                        });
                        _updateUSDConversion();
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Recipient Address
                    RecipientAddressWidget(
                      controller: _addressController,
                      isValid: _isAddressValid,
                      onChanged: _validateAddress,
                      onQRPressed: () {
                        setState(() {
                          _showQRScanner = true;
                        });
                      },
                      onAddressBookPressed: () {
                        setState(() {
                          _showAddressBook = true;
                        });
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Amount Input
                    AmountInputWidget(
                      controller: _amountController,
                      selectedCoin: _selectedCoin,
                      usdConversion: _usdConversion,
                      onMaxPressed: _setMaxAmount,
                      balance: (_cryptocurrencies.firstWhere(
                        (crypto) => crypto['symbol'] == _selectedCoin,
                        orElse: () => _cryptocurrencies[0],
                      )['balance'] as double),
                    ),

                    SizedBox(height: 3.h),

                    // Network Fee
                    NetworkFeeWidget(
                      selectedFeeType: _selectedFeeType,
                      networkFees: _networkFees,
                      showCustomFee: _showCustomFee,
                      customFeeController: _customFeeController,
                      onFeeTypeSelected: (feeType) {
                        setState(() {
                          _selectedFeeType = feeType;
                          _showCustomFee = false;
                        });
                      },
                      onCustomFeePressed: () {
                        setState(() {
                          _showCustomFee = !_showCustomFee;
                        });
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Transaction Summary
                    TransactionSummaryWidget(
                      selectedCoin: _selectedCoin,
                      amount: double.tryParse(_amountController.text) ?? 0.0,
                      usdAmount: _usdConversion,
                      recipientAddress: _addressController.text,
                      networkFee: _showCustomFee
                          ? double.tryParse(_customFeeController.text) ?? 0.0
                          : (_networkFees[_selectedFeeType]?['fee']
                                  as double? ??
                              0.0),
                      usdFee: _showCustomFee
                          ? (double.tryParse(_customFeeController.text) ??
                                  0.0) *
                              (_cryptocurrencies.firstWhere(
                                (crypto) => crypto['symbol'] == _selectedCoin,
                                orElse: () => _cryptocurrencies[0],
                              )['usdValue'] as double)
                          : (_networkFees[_selectedFeeType]?['usdFee']
                                  as double? ??
                              0.0),
                    ),

                    SizedBox(height: 4.h),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ||
                                _addressController.text.isEmpty ||
                                _amountController.text.isEmpty ||
                                !_isAddressValid
                            ? null
                            : _sendTransaction,
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : const Text('Send Transaction'),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),

          // QR Scanner Overlay
          if (_showQRScanner)
            QRScannerWidget(
              onScanned: _onQRScanned,
              onClose: () {
                setState(() {
                  _showQRScanner = false;
                });
              },
            ),

          // Address Book Overlay
          if (_showAddressBook)
            AddressBookWidget(
              addressBook: _addressBook,
              selectedCoin: _selectedCoin,
              onAddressSelected: _onAddressSelected,
              onClose: () {
                setState(() {
                  _showAddressBook = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
