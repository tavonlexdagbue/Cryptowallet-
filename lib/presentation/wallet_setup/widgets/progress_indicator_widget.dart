import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: AppTheme.getElevationShadow(elevation: 1),
      ),
      child: Column(
        children: [
          // Step Indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStepIndicator(
                        stepNumber: stepNumber,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                      ),
                    ),
                    if (index < totalSteps - 1) _buildConnector(isCompleted),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 2.h),

          // Progress Bar
          _buildProgressBar(),

          SizedBox(height: 1.h),

          // Step Labels
          _buildStepLabels(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.tertiary
            : isCurrent
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted
              ? AppTheme.lightTheme.colorScheme.tertiary
              : isCurrent
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 16,
              )
            : Text(
                stepNumber.toString(),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isCurrent
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildConnector(bool isCompleted) {
    return Container(
      width: 4.w,
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = currentStep / totalSteps;

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.tertiary,
              ],
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildStepLabels() {
    final labels = ['Generate', 'Verify', 'Secure', 'Complete'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;

        return Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }
}
