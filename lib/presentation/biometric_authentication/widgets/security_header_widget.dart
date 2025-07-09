import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecurityHeaderWidget extends StatelessWidget {
  const SecurityHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWalletIcon(),
        SizedBox(height: 3.h),
        _buildTitle(),
        SizedBox(height: 1.h),
        _buildSubtitle(),
      ],
    );
  }

  Widget _buildWalletIcon() {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 8.w,
          ),
          Positioned(
            top: 2.w,
            right: 2.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'security',
                color: Colors.white,
                size: 3.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'CryptoVault',
      style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Secure Cryptocurrency Wallet',
      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
