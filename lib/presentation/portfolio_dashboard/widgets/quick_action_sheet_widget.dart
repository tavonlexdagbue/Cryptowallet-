import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionSheetWidget extends StatelessWidget {
  final VoidCallback onSendPressed;
  final VoidCallback onReceivePressed;
  final VoidCallback onAddCoinPressed;

  const QuickActionSheetWidget({
    Key? key,
    required this.onSendPressed,
    required this.onReceivePressed,
    required this.onAddCoinPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Text(
                  'Quick Actions',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: 'send',
                      label: 'Send Money',
                      color: AppTheme.lightTheme.primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                        onSendPressed();
                      },
                    ),
                    _buildActionButton(
                      icon: 'qr_code',
                      label: 'Receive Payment',
                      color: AppTheme.successLight,
                      onPressed: () {
                        Navigator.pop(context);
                        onReceivePressed();
                      },
                    ),
                    _buildActionButton(
                      icon: 'add_circle',
                      label: 'Add New Coin',
                      color: AppTheme.warningLight,
                      onPressed: () {
                        Navigator.pop(context);
                        onAddCoinPressed();
                      },
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Additional options
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor
                        .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: 'history',
                        title: 'Transaction History',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Opening transaction history')),
                          );
                        },
                      ),
                      Divider(color: AppTheme.borderLight),
                      _buildListTile(
                        icon: 'security',
                        title: 'Security Settings',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/security-settings');
                        },
                      ),
                      Divider(color: AppTheme.borderLight),
                      _buildListTile(
                        icon: 'backup',
                        title: 'Backup Wallet',
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Opening backup options')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
