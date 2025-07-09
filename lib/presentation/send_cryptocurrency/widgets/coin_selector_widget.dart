import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CoinSelectorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cryptocurrencies;
  final String selectedCoin;
  final Function(String) onCoinSelected;

  const CoinSelectorWidget({
    Key? key,
    required this.cryptocurrencies,
    required this.selectedCoin,
    required this.onCoinSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedCrypto = cryptocurrencies.firstWhere(
      (crypto) => crypto['symbol'] == selectedCoin,
      orElse: () => cryptocurrencies[0],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Cryptocurrency',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCoin,
              isExpanded: true,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              items: cryptocurrencies.map<DropdownMenuItem<String>>((crypto) {
                return DropdownMenuItem<String>(
                  value: crypto['symbol'] as String,
                  child: Row(
                    children: [
                      CustomImageWidget(
                        imageUrl: crypto['icon'] as String,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              crypto['name'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${crypto['balance']} ${crypto['symbol']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${((crypto['balance'] as double) * (crypto['usdValue'] as double)).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onCoinSelected(newValue);
                }
              },
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Balance',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Text(
              '${selectedCrypto['balance']} ${selectedCrypto['symbol']}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
