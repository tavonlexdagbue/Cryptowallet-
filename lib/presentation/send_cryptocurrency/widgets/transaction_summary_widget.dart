import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TransactionSummaryWidget extends StatelessWidget {
  final String selectedCoin;
  final double amount;
  final double usdAmount;
  final String recipientAddress;
  final double networkFee;
  final double usdFee;

  const TransactionSummaryWidget({
    Key? key,
    required this.selectedCoin,
    required this.amount,
    required this.usdAmount,
    required this.recipientAddress,
    required this.networkFee,
    required this.usdFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalAmount = amount + networkFee;
    final totalUsdAmount = usdAmount + usdFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Summary',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                'Recipient',
                recipientAddress.isNotEmpty
                    ? '${recipientAddress.substring(0, 8)}...${recipientAddress.substring(recipientAddress.length - 8)}'
                    : 'Not specified',
                isAddress: true,
              ),
              SizedBox(height: 2.h),
              _buildSummaryRow(
                'Amount',
                '${amount.toStringAsFixed(8)} $selectedCoin',
                subtitle: '≈ \$${usdAmount.toStringAsFixed(2)}',
              ),
              SizedBox(height: 2.h),
              _buildSummaryRow(
                'Network Fee',
                '${networkFee.toStringAsFixed(8)} $selectedCoin',
                subtitle: '≈ \$${usdFee.toStringAsFixed(2)}',
              ),
              SizedBox(height: 2.h),
              Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
              SizedBox(height: 2.h),
              _buildSummaryRow(
                'Total',
                '${totalAmount.toStringAsFixed(8)} $selectedCoin',
                subtitle: '≈ \$${totalUsdAmount.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    String? subtitle,
    bool isAddress = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal
                ? AppTheme.lightTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: isAddress
                    ? AppTheme.getMonospaceStyle(
                        isLight: true,
                        fontSize: 14,
                        fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                      )
                    : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                      ),
                textAlign: TextAlign.end,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 0.5.h),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
