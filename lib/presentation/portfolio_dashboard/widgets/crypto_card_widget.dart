import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CryptoCardWidget extends StatelessWidget {
  final Map<String, dynamic> coin;
  final bool isBalanceHidden;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CryptoCardWidget({
    Key? key,
    required this.coin,
    required this.isBalanceHidden,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPositive = coin["isPositive"] as bool;
    final double percentageChange = coin["percentageChange"] as double;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.getElevationShadow(elevation: 2),
        ),
        child: Row(
          children: [
            // Crypto icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: coin["icon"] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 4.w),

            // Coin info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coin["name"] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    coin["symbol"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Balance and value
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isBalanceHidden
                      ? '••••••'
                      : '${(coin["balance"] as double).toStringAsFixed(8)} ${coin["symbol"]}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isBalanceHidden
                          ? '••••••'
                          : '\$${(coin["usdValue"] as double).toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppTheme.successLight.withValues(alpha: 0.1)
                            : AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName:
                                isPositive ? 'trending_up' : 'trending_down',
                            color: isPositive
                                ? AppTheme.successLight
                                : AppTheme.errorLight,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isPositive
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
