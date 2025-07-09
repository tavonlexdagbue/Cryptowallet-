import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class NetworkFeeWidget extends StatelessWidget {
  final String selectedFeeType;
  final Map<String, Map<String, dynamic>> networkFees;
  final bool showCustomFee;
  final TextEditingController customFeeController;
  final Function(String) onFeeTypeSelected;
  final VoidCallback onCustomFeePressed;

  const NetworkFeeWidget({
    Key? key,
    required this.selectedFeeType,
    required this.networkFees,
    required this.showCustomFee,
    required this.customFeeController,
    required this.onFeeTypeSelected,
    required this.onCustomFeePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Network Fee',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            TextButton(
              onPressed: onCustomFeePressed,
              child: Text(showCustomFee ? 'Hide Custom' : 'Custom Fee'),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        if (!showCustomFee) ...[
          ...networkFees.entries.map((entry) {
            final feeType = entry.key;
            final feeData = entry.value;
            final isSelected = selectedFeeType == feeType;

            return Container(
              margin: EdgeInsets.only(bottom: 1.h),
              child: InkWell(
                onTap: () => onFeeTypeSelected(feeType),
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: feeType,
                        groupValue: selectedFeeType,
                        onChanged: (value) {
                          if (value != null) {
                            onFeeTypeSelected(value);
                          }
                        },
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  feeType,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${feeData['fee']} BTC',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  feeData['time'] as String,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                Text(
                                  '≈ \$${feeData['usdFee']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ] else ...[
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Fee (BTC)',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: customFeeController,
                  decoration: const InputDecoration(
                    hintText: '0.00001',
                    border: InputBorder.none,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: AppTheme.getMonospaceStyle(
                    isLight: true,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Higher fees result in faster confirmation times',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
