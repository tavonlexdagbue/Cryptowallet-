import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PinInputWidget extends StatefulWidget {
  final Function(String) onPinEntered;
  final VoidCallback onCancel;
  final bool isLoading;
  final String errorMessage;
  final int failedAttempts;

  const PinInputWidget({
    super.key,
    required this.onPinEntered,
    required this.onCancel,
    required this.isLoading,
    required this.errorMessage,
    required this.failedAttempts,
  });

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  String _pin = '';
  final int _pinLength = 6;

  void _onNumberPressed(String number) {
    if (_pin.length < _pinLength && !widget.isLoading) {
      HapticFeedback.lightImpact();
      setState(() {
        _pin += number;
      });

      if (_pin.length == _pinLength) {
        widget.onPinEntered(_pin);
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty && !widget.isLoading) {
      HapticFeedback.lightImpact();
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _clearPin() {
    setState(() {
      _pin = '';
    });
  }

  @override
  void didUpdateWidget(PinInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage.isNotEmpty &&
        oldWidget.errorMessage != widget.errorMessage) {
      _clearPin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 6.h),
          _buildPinDots(),
          SizedBox(height: 4.h),
          _buildErrorMessage(),
          SizedBox(height: 4.h),
          Expanded(
            child: _buildNumericKeypad(),
          ),
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Enter PIN',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Enter your 6-digit PIN to unlock your wallet',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pinLength, (index) {
        final bool isFilled = index < _pin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            border: Border.all(
              color: isFilled
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage() {
    if (widget.errorMessage.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              widget.errorMessage,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    final List<String> numbers = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'backspace'
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final String number = numbers[index];

        if (number.isEmpty) {
          return const SizedBox.shrink();
        }

        if (number == 'backspace') {
          return _buildBackspaceButton();
        }

        return _buildNumberButton(number);
      },
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isLoading ? null : () => _onNumberPressed(number),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: widget.isLoading
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5)
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isLoading ? null : _onBackspacePressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.lightTheme.colorScheme.surface,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'backspace',
              color: widget.isLoading
                  ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5)
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: widget.isLoading ? null : widget.onCancel,
      child: Text(
        'Cancel',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
