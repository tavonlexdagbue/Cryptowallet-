import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricSettingsWidget extends StatelessWidget {
  final bool isEnabled;
  final String biometricType;
  final ValueChanged<bool> onToggle;

  const BiometricSettingsWidget({
    super.key,
    required this.isEnabled,
    required this.biometricType,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> supportedMethods = [
      {'name': 'Face ID', 'icon': 'face', 'available': true},
      {'name': 'Touch ID', 'icon': 'fingerprint', 'available': true},
      {'name': 'Fingerprint', 'icon': 'fingerprint', 'available': false},
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
                  iconName: 'fingerprint',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Biometric Authentication',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: onToggle,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isEnabled
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isEnabled
                      ? AppTheme.successLight.withValues(alpha: 0.3)
                      : AppTheme.borderLight,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: isEnabled ? 'check_circle' : 'cancel',
                    color: isEnabled
                        ? AppTheme.successLight
                        : AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    isEnabled ? 'Enabled - $biometricType' : 'Disabled',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isEnabled
                          ? AppTheme.successLight
                          : AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Supported Methods',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            ...supportedMethods.map((method) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: method['icon'] as String,
                        color: (method['available'] as bool)
                            ? AppTheme.primaryLight
                            : AppTheme.textSecondaryLight,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          method['name'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: (method['available'] as bool)
                                ? AppTheme.textPrimaryLight
                                : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ),
                      if (method['available'] as bool)
                        CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.successLight,
                          size: 16,
                        )
                      else
                        Text(
                          'Not Available',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
