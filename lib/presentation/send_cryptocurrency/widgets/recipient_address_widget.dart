import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecipientAddressWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final Function(String) onChanged;
  final VoidCallback onQRPressed;
  final VoidCallback onAddressBookPressed;

  const RecipientAddressWidget({
    Key? key,
    required this.controller,
    required this.isValid,
    required this.onChanged,
    required this.onQRPressed,
    required this.onAddressBookPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipient Address',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter wallet address or scan QR code',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  onPressed: onQRPressed,
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'contacts',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  onPressed: onAddressBookPressed,
                ),
              ],
            ),
            prefixIcon: controller.text.isNotEmpty
                ? CustomIconWidget(
                    iconName: isValid ? 'check_circle' : 'error',
                    color:
                        isValid ? AppTheme.successLight : AppTheme.errorLight,
                    size: 20,
                  )
                : null,
          ),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a recipient address';
            }
            if (!isValid) {
              return 'Invalid address format';
            }
            return null;
          },
          maxLines: 2,
          style: AppTheme.getMonospaceStyle(
            isLight: true,
            fontSize: 14,
          ),
        ),
        if (controller.text.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: isValid ? 'verified' : 'warning',
                color: isValid ? AppTheme.successLight : AppTheme.warningLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                isValid ? 'Address verified' : 'Please check address format',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color:
                      isValid ? AppTheme.successLight : AppTheme.warningLight,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
