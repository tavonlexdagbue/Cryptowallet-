import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_security_widget.dart';
import './widgets/auto_lock_settings_widget.dart';
import './widgets/backup_recovery_widget.dart';
import './widgets/biometric_settings_widget.dart';
import './widgets/hardware_wallet_widget.dart';
import './widgets/pin_management_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/two_factor_auth_widget.dart';

class SecuritySettings extends StatefulWidget {
  const SecuritySettings({super.key});

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  bool _isLoading = false;

  // Mock security settings state
  final Map<String, dynamic> _securitySettings = {
    'biometricEnabled': true,
    'biometricType': 'Face ID',
    'autoLockTimeout': '5 minutes',
    'seedPhraseBackedUp': true,
    'twoFactorEnabled': false,
    'hideBalances': true,
    'requireAuthForScreenshots': true,
    'wipeAfterFailedAttempts': true,
    'failedAttemptsLimit': 10,
    'hardwareWalletConnected': false,
  };

  void _showBiometricConfirmation(String action, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Biometric Authentication Required',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          'Please authenticate to $action',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed();
            },
            child: const Text('Authenticate'),
          ),
        ],
      ),
    );
  }

  void _showWarningDialog(
      String title, String message, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.errorLight,
          ),
        ),
        content: Text(
          message,
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirmed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _securitySettings[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Security Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to help documentation
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Security header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryLight,
                            AppTheme.primaryLight.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: Colors.white,
                            size: 32,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wallet Security',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Protect your digital assets with advanced security features',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Biometric Authentication
                    BiometricSettingsWidget(
                      isEnabled: _securitySettings['biometricEnabled'] as bool,
                      biometricType:
                          _securitySettings['biometricType'] as String,
                      onToggle: (value) {
                        _showBiometricConfirmation(
                          value
                              ? 'enable biometric authentication'
                              : 'disable biometric authentication',
                          () => _updateSetting('biometricEnabled', value),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // PIN Management
                    PinManagementWidget(
                      onChangePIN: () {
                        _showBiometricConfirmation(
                          'change your PIN',
                          () {
                            // Navigate to PIN change screen
                          },
                        );
                      },
                      onResetPIN: () {
                        _showWarningDialog(
                          'Reset PIN',
                          'This will reset your PIN. You will need to authenticate and set a new PIN.',
                          () {
                            // Handle PIN reset
                          },
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Auto-Lock Settings
                    AutoLockSettingsWidget(
                      currentTimeout:
                          _securitySettings['autoLockTimeout'] as String,
                      onTimeoutChanged: (timeout) =>
                          _updateSetting('autoLockTimeout', timeout),
                    ),

                    SizedBox(height: 2.h),

                    // Backup & Recovery
                    BackupRecoveryWidget(
                      isBackedUp:
                          _securitySettings['seedPhraseBackedUp'] as bool,
                      onViewRecoveryPhrase: () {
                        _showBiometricConfirmation(
                          'view your recovery phrase',
                          () {
                            // Show recovery phrase
                          },
                        );
                      },
                      onTestRecovery: () {
                        Navigator.pushNamed(context, '/wallet-setup');
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Two-Factor Authentication
                    TwoFactorAuthWidget(
                      isEnabled: _securitySettings['twoFactorEnabled'] as bool,
                      onToggle: (value) {
                        _showBiometricConfirmation(
                          value
                              ? 'enable two-factor authentication'
                              : 'disable two-factor authentication',
                          () => _updateSetting('twoFactorEnabled', value),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Privacy Settings
                    PrivacySettingsWidget(
                      hideBalances: _securitySettings['hideBalances'] as bool,
                      requireAuthForScreenshots:
                          _securitySettings['requireAuthForScreenshots']
                              as bool,
                      onHideBalancesToggle: (value) =>
                          _updateSetting('hideBalances', value),
                      onRequireAuthToggle: (value) =>
                          _updateSetting('requireAuthForScreenshots', value),
                    ),

                    SizedBox(height: 2.h),

                    // Advanced Security
                    AdvancedSecurityWidget(
                      wipeAfterFailedAttempts:
                          _securitySettings['wipeAfterFailedAttempts'] as bool,
                      failedAttemptsLimit:
                          _securitySettings['failedAttemptsLimit'] as int,
                      onWipeToggle: (value) {
                        if (value) {
                          _showWarningDialog(
                            'Enable Wallet Wipe',
                            'This will permanently delete your wallet after failed authentication attempts. Make sure you have backed up your recovery phrase.',
                            () => _updateSetting(
                                'wipeAfterFailedAttempts', value),
                          );
                        } else {
                          _updateSetting('wipeAfterFailedAttempts', value);
                        }
                      },
                      onAttemptsLimitChanged: (limit) =>
                          _updateSetting('failedAttemptsLimit', limit),
                    ),

                    SizedBox(height: 2.h),

                    // Hardware Wallet Integration
                    HardwareWalletWidget(
                      isConnected:
                          _securitySettings['hardwareWalletConnected'] as bool,
                      onPairDevice: () {
                        // Handle hardware wallet pairing
                      },
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
      ),
    );
  }
}
