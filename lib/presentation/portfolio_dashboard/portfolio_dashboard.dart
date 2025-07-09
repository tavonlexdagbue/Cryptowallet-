import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/crypto_card_widget.dart';
import './widgets/portfolio_header_widget.dart';
import './widgets/quick_action_sheet_widget.dart';

class PortfolioDashboard extends StatefulWidget {
  const PortfolioDashboard({Key? key}) : super(key: key);

  @override
  State<PortfolioDashboard> createState() => _PortfolioDashboardState();
}

class _PortfolioDashboardState extends State<PortfolioDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBalanceHidden = false;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _cryptoData = [
    {
      "id": "bitcoin",
      "name": "Bitcoin",
      "symbol": "BTC",
      "icon": "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
      "balance": 0.00234567,
      "usdValue": 156.78,
      "percentageChange": 2.45,
      "isPositive": true,
    },
    {
      "id": "ethereum",
      "name": "Ethereum",
      "symbol": "ETH",
      "icon": "https://cryptologos.cc/logos/ethereum-eth-logo.png",
      "balance": 0.15678,
      "usdValue": 245.32,
      "percentageChange": -1.23,
      "isPositive": false,
    },
    {
      "id": "cardano",
      "name": "Cardano",
      "symbol": "ADA",
      "icon": "https://cryptologos.cc/logos/cardano-ada-logo.png",
      "balance": 1250.0,
      "usdValue": 487.50,
      "percentageChange": 5.67,
      "isPositive": true,
    },
    {
      "id": "solana",
      "name": "Solana",
      "symbol": "SOL",
      "icon": "https://cryptologos.cc/logos/solana-sol-logo.png",
      "balance": 12.5,
      "usdValue": 1875.25,
      "percentageChange": -3.45,
      "isPositive": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceHidden = !_isBalanceHidden;
    });
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionSheetWidget(
        onSendPressed: () =>
            Navigator.pushNamed(context, '/send-cryptocurrency'),
        onReceivePressed: () =>
            Navigator.pushNamed(context, '/receive-cryptocurrency'),
        onAddCoinPressed: () => Navigator.pushNamed(context, '/wallet-setup'),
      ),
    );
  }

  void _navigateToCoinDetail(Map<String, dynamic> coin) {
    // Navigate to coin detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${coin["name"]} details'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showCoinContextMenu(Map<String, dynamic> coin) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'send',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Send ${coin["symbol"]}'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/send-cryptocurrency');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Receive ${coin["symbol"]}'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/receive-cryptocurrency');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'key',
                color: AppTheme.warningLight,
                size: 24,
              ),
              title: const Text('Export Keys'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/security-settings');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: const Text('Remove Coin'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('${coin["name"]} removed from portfolio')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double get _totalPortfolioValue {
    return (_cryptoData as List)
        .fold(0.0, (sum, coin) => sum + (coin["usdValue"] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'CryptoVault',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _toggleBalanceVisibility,
            icon: CustomIconWidget(
              iconName: _isBalanceHidden ? 'visibility' : 'visibility_off',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/security-settings'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Portfolio'),
            Tab(text: 'Send'),
            Tab(text: 'Receive'),
            Tab(text: 'History'),
            Tab(text: 'Settings'),
          ],
          onTap: (index) {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, '/send-cryptocurrency');
                break;
              case 2:
                Navigator.pushNamed(context, '/receive-cryptocurrency');
                break;
              case 4:
                Navigator.pushNamed(context, '/security-settings');
                break;
            }
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPortfolioTab(),
          Container(), // Send tab placeholder
          Container(), // Receive tab placeholder
          Container(), // History tab placeholder
          Container(), // Settings tab placeholder
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActionSheet,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child:
          _cryptoData.isEmpty ? _buildEmptyState() : _buildPortfolioContent(),
    );
  }

  Widget _buildPortfolioContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          PortfolioHeaderWidget(
            totalValue: _totalPortfolioValue,
            isBalanceHidden: _isBalanceHidden,
            isRefreshing: _isRefreshing,
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _cryptoData.length,
            itemBuilder: (context, index) {
              final coin = _cryptoData[index];
              return Dismissible(
                key: Key(coin["id"] as String),
                background: _buildSwipeBackground(isLeft: false),
                secondaryBackground: _buildSwipeBackground(isLeft: true),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    // Quick actions (Send/Receive)
                    _showQuickActionSheet();
                  } else {
                    // Advanced options
                    _showCoinContextMenu(coin);
                  }
                  // Reset the item
                  setState(() {});
                },
                child: CryptoCardWidget(
                  coin: coin,
                  isBalanceHidden: _isBalanceHidden,
                  onTap: () => _navigateToCoinDetail(coin),
                  onLongPress: () => _showCoinContextMenu(coin),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.errorLight : AppTheme.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'more_horiz' : 'swap_horiz',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Options' : 'Actions',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  "https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=300&h=300&fit=crop",
              width: 40.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'No Cryptocurrencies Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start building your crypto portfolio by adding your first coin',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/wallet-setup'),
              child: const Text('Add Your First Coin'),
            ),
          ],
        ),
      ),
    );
  }
}
