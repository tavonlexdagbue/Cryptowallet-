import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onScanned;
  final VoidCallback onClose;

  const QRScannerWidget({
    Key? key,
    required this.onScanned,
    required this.onClose,
  }) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  bool _flashEnabled = false;
  final TextEditingController _manualController = TextEditingController();
  bool _showManualEntry = false;

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  void _simulateQRScan() {
    // Simulate QR code scanning with mock address
    const mockAddress = '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa';
    widget.onScanned(mockAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan QR Code',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Scanner Area
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(8.w),
                child: Stack(
                  children: [
                    // Mock camera view
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'qr_code_scanner',
                            color: Colors.white,
                            size: 64,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Position QR code within the frame',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2.h),
                          ElevatedButton(
                            onPressed: _simulateQRScan,
                            child: const Text('Simulate Scan'),
                          ),
                        ],
                      ),
                    ),

                    // Scanning overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: AppTheme.lightTheme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Corner indicators
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                    left: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                    right: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                    left: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                    right: BorderSide(
                                      color: AppTheme.lightTheme.primaryColor,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: _flashEnabled ? 'flash_on' : 'flash_off',
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _flashEnabled = !_flashEnabled;
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showManualEntry = !_showManualEntry;
                          });
                        },
                        child: Text(
                          _showManualEntry
                              ? 'Hide Manual Entry'
                              : 'Enter Manually',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showManualEntry) ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _manualController,
                            decoration: const InputDecoration(
                              hintText: 'Enter wallet address',
                              border: InputBorder.none,
                            ),
                            style: AppTheme.getMonospaceStyle(
                              isLight: true,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_manualController.text.isNotEmpty) {
                                  widget.onScanned(_manualController.text);
                                }
                              },
                              child: const Text('Use Address'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
