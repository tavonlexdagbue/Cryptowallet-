import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AutoLockSettingsWidget extends StatelessWidget {
  final String currentTimeout;
  final ValueChanged<String> onTimeoutChanged;

  const AutoLockSettingsWidget({
    super.key,
    required this.currentTimeout,
    required this.onTimeoutChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> timeoutOptions = [
      'Immediate',
      '1 minute',
      '5 minutes',
      '15 minutes',
    ];

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
                  iconName: 'timer',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Auto-Lock Settings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Choose when your wallet should automatically lock',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 2.h),
            ...timeoutOptions.map((option) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: RadioListTile<String>(
                    title: Text(
                      option,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    value: option,
                    groupValue: currentTimeout,
                    onChanged: (value) {
                      if (value != null) {
                        onTimeoutChanged(value);
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                )),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Current setting: $currentTimeout',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.w500,
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
