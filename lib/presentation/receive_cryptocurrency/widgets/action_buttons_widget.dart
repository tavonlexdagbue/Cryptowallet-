import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onSharePressed;
  final VoidCallback onSavePressed;
  final VoidCallback onGenerateNewPressed;
  final bool isGenerating;

  const ActionButtonsWidget({
    Key? key,
    required this.onSharePressed,
    required this.onSavePressed,
    required this.onGenerateNewPressed,
    required this.isGenerating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onSharePressed,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Share QR Code'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSavePressed,
                icon: CustomIconWidget(
                  iconName: 'save_alt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Save to Photos'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Generate New Address Button
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: isGenerating ? null : onGenerateNewPressed,
            icon: isGenerating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
            label: Text(
              isGenerating
                  ? 'Generating New Address...'
                  : 'Generate New Address',
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Privacy Note
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Generate new addresses for enhanced privacy and security',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
