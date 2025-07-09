import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BackupRecoveryWidget extends StatelessWidget {
  final bool isBackedUp;
  final VoidCallback onViewRecoveryPhrase;
  final VoidCallback onTestRecovery;

  const BackupRecoveryWidget({
    super.key,
    required this.isBackedUp,
    required this.onViewRecoveryPhrase,
    required this.onTestRecovery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'backup',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Backup & Recovery',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isBackedUp
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.errorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isBackedUp
                      ? AppTheme.successLight.withValues(alpha: 0.3)
                      : AppTheme.errorLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: isBackedUp ? 'check_circle' : 'warning',
                    color: isBackedUp
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isBackedUp
                              ? 'Seed Phrase Backed Up'
                              : 'Backup Required',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isBackedUp
                                ? AppTheme.successLight
                                : AppTheme.errorLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (!isBackedUp) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            'Back up your seed phrase to recover your wallet',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.errorLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onViewRecoveryPhrase,
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text('View Recovery Phrase'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTestRecovery,
                    icon: CustomIconWidget(
                      iconName: 'quiz',
                      color: AppTheme.primaryLight,
                      size: 18,
                    ),
                    label: const Text('Test Recovery'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Viewing recovery phrase requires biometric confirmation',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
