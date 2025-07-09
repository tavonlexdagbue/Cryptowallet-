import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/pin_input_widget.dart';
import './widgets/security_header_widget.dart';

class BiometricAuthentication extends StatefulWidget {
  const BiometricAuthentication({super.key});

  @override
  State<BiometricAuthentication> createState() =>
      _BiometricAuthenticationState();
}

class _BiometricAuthenticationState extends State<BiometricAuthentication>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showPinInput = false;
  bool _isLoading = false;
  bool _biometricAvailable = true;
  int _failedAttempts = 0;
  String _errorMessage = '';

  // Mock biometric settings
  final bool _isFaceIdDevice = true; // Simulate iOS Face ID
  final String _mockPin = '123456';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    setState(() {
      _biometricAvailable = true;
    });
  }

  void _handleBiometricAuth() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 2));

    // Mock authentication result (80% success rate)
    final bool success = DateTime.now().millisecond % 5 != 0;

    if (success) {
      _onAuthenticationSuccess();
    } else {
      _onAuthenticationFailure(
          'Biometric authentication failed. Please try again.');
    }
  }

  void _handlePinAuth(String pin) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (pin == _mockPin) {
      _onAuthenticationSuccess();
    } else {
      _failedAttempts++;
      _onAuthenticationFailure('Incorrect PIN. Please try again.');
    }
  }

  void _onAuthenticationSuccess() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/portfolio-dashboard');
  }

  void _onAuthenticationFailure(String message) {
    HapticFeedback.heavyImpact();
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });

    // Progressive delay after multiple failures
    if (_failedAttempts >= 3) {
      _showProgressiveDelay();
    }
  }

  void _showProgressiveDelay() {
    final int delaySeconds = _failedAttempts * 5;
    setState(() {
      _errorMessage =
          'Too many failed attempts. Please wait $delaySeconds seconds.';
    });

    Future.delayed(Duration(seconds: delaySeconds), () {
      if (mounted) {
        setState(() {
          _errorMessage = '';
        });
      }
    });
  }

  void _togglePinInput() {
    setState(() {
      _showPinInput = true;
    });
    _slideController.forward();
  }

  void _hidePinInput() {
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPinInput = false;
        });
      }
    });
  }

  void _handleForgotPin() {
    Navigator.pushNamed(context, '/wallet-setup');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMainContent(),
            if (_showPinInput) _buildPinInputOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          SecurityHeaderWidget(),
          SizedBox(height: 8.h),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BiometricPromptWidget(
                  isFaceId: _isFaceIdDevice,
                  isLoading: _isLoading,
                  pulseAnimation: _pulseAnimation,
                  onBiometricPressed: _handleBiometricAuth,
                ),
                SizedBox(height: 6.h),
                _buildErrorMessage(),
                SizedBox(height: 4.h),
                _buildUsePinButton(),
              ],
            ),
          ),
          _buildEmergencyOptions(),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage.isEmpty) return const SizedBox.shrink();

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
              _errorMessage,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsePinButton() {
    return TextButton(
      onPressed: _isLoading ? null : _togglePinInput,
      child: Text(
        'Use PIN Instead',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildEmergencyOptions() {
    return Column(
      children: [
        TextButton(
          onPressed: _handleForgotPin,
          child: Text(
            'Forgot PIN?',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Your wallet will automatically lock after 30 seconds of inactivity',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPinInputOverlay() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        child: SafeArea(
          child: PinInputWidget(
            onPinEntered: _handlePinAuth,
            onCancel: _hidePinInput,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            failedAttempts: _failedAttempts,
          ),
        ),
      ),
    );
  }
}