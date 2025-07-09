import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddressBookWidget extends StatefulWidget {
  final List<Map<String, dynamic>> addressBook;
  final String selectedCoin;
  final Function(String) onAddressSelected;
  final VoidCallback onClose;

  const AddressBookWidget({
    Key? key,
    required this.addressBook,
    required this.selectedCoin,
    required this.onAddressSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  State<AddressBookWidget> createState() => _AddressBookWidgetState();
}

class _AddressBookWidgetState extends State<AddressBookWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredAddresses = [];

  @override
  void initState() {
    super.initState();
    _filteredAddresses = widget.addressBook
        .where((address) => address['coin'] == widget.selectedCoin)
        .toList();
    _searchController.addListener(_filterAddresses);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAddresses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAddresses = widget.addressBook
          .where((address) =>
              address['coin'] == widget.selectedCoin &&
              (address['name'] as String).toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Address Book',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ),

              // Search
              Container(
                padding: EdgeInsets.all(4.w),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    prefixIcon: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Address List
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 50.h),
                  child: _filteredAddresses.isEmpty
                      ? Container(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'contacts',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No ${widget.selectedCoin} addresses found',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filteredAddresses.length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppTheme.lightTheme.colorScheme.outline,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final address = _filteredAddresses[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(address['avatar'] as String),
                                radius: 20,
                              ),
                              title: Text(
                                address['name'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${(address['address'] as String).substring(0, 12)}...${(address['address'] as String).substring((address['address'] as String).length - 8)}',
                                style: AppTheme.getMonospaceStyle(
                                  isLight: true,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  address['coin'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                              onTap: () {
                                widget.onAddressSelected(
                                    address['address'] as String);
                              },
                            );
                          },
                        ),
                ),
              ),

              // Add New Address Button
              Container(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Navigate to add new address screen
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    label: const Text('Add New Address'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
