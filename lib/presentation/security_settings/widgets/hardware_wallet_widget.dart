import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HardwareWalletWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPairDevice;

  const HardwareWalletWidget({
    super.key,
    required this.isConnected,
    required this.onPairDevice,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> supportedDevices = [
      {
        'name': 'Ledger Nano S/X',
        'icon': 'usb',
        'supported': true,
        'connection': 'USB-C/Lightning',
      },
      {
        'name': 'Trezor Model T',
        'icon': 'usb',
        'supported': true,
        'connection': 'USB-C/Lightning',
      },
      {
        'name': 'KeepKey',
        'icon': 'usb',
        'supported': false,
        'connection': 'Coming Soon',
      },
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
                  iconName: 'hardware',
                  color: AppTheme.primaryLight,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Hardware Wallet Integration',
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
                color: isConnected
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isConnected
                      ? AppTheme.successLight.withValues(alpha: 0.3)
                      : AppTheme.borderLight,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: isConnected ? 'check_circle' : 'cancel',
                    color: isConnected
                        ? AppTheme.successLight
                        : AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      isConnected
                          ? 'Hardware Wallet Connected'
                          : 'No Hardware Wallet Connected',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isConnected
                            ? AppTheme.successLight
                            : AppTheme.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isConnected) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'devices',
                      color: AppTheme.primaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ledger Nano X',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Connected via USB-C • Firmware v2.1.0',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(height: 2.h),
              ElevatedButton.icon(
                onPressed: onPairDevice,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text('Pair Hardware Wallet'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 6.h),
                ),
              ),
            ],
            SizedBox(height: 2.h),
            Text(
              'Supported Devices',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            ...supportedDevices.map((device) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: device['icon'] as String,
                          color: (device['supported'] as bool)
                              ? AppTheme.primaryLight
                              : AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device['name'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: (device['supported'] as bool)
                                      ? AppTheme.textPrimaryLight
                                      : AppTheme.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                device['connection'] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (device['supported'] as bool)
                          CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.successLight,
                            size: 16,
                          )
                        else
                          Text(
                            'Soon',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                )),
            SizedBox(height: 2.h),
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
                    iconName: 'info',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Hardware wallets provide the highest level of security by keeping your private keys offline',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryLight,
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
