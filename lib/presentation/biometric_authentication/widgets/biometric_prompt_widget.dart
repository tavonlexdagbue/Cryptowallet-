import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricPromptWidget extends StatelessWidget {
  final bool isFaceId;
  final bool isLoading;
  final Animation<double> pulseAnimation;
  final VoidCallback onBiometricPressed;

  const BiometricPromptWidget({
    super.key,
    required this.isFaceId,
    required this.isLoading,
    required this.pulseAnimation,
    required this.onBiometricPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBiometricIcon(),
        SizedBox(height: 4.h),
        _buildInstructionText(),
        SizedBox(height: 6.h),
        _buildBiometricButton(),
      ],
    );
  }

  Widget _buildBiometricIcon() {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isLoading ? pulseAnimation.value : 1.0,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: isLoading
                ? _buildLoadingIndicator()
                : _buildBiometricTypeIcon(),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 8.w,
        height: 8.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricTypeIcon() {
    return Center(
      child: CustomIconWidget(
        iconName: isFaceId ? 'face' : 'fingerprint',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 12.w,
      ),
    );
  }

  Widget _buildInstructionText() {
    return Column(
      children: [
        Text(
          'Unlock your wallet',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          isFaceId
              ? 'Look at your device to authenticate with Face ID'
              : 'Place your finger on the sensor to authenticate',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      width: 80.w,
      height: 7.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onBiometricPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 5.w,
                height: 5.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 3.w),
            ] else ...[
              CustomIconWidget(
                iconName: isFaceId ? 'face' : 'fingerprint',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
            ],
            Text(
              isLoading
                  ? 'Authenticating...'
                  : isFaceId
                      ? 'Use Face ID'
                      : 'Use Fingerprint',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
