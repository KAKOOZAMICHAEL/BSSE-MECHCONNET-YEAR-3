import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../providers/payment_provider.dart';
import '../../providers/booking_provider.dart';
import '../../../data/models/booking_model.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String bookingId;

  const PaymentConfirmationScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
      final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
      
      // Load booking details
      bookingProvider.loadBooking(widget.bookingId);
      
      // Load wallet balance
      paymentProvider.loadWalletBalance();
    });
  }

  Future<void> _processPayment() async {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    
    final booking = bookingProvider.selectedBooking;
    if (booking == null || booking.cost == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cost not available'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final amount = booking.cost!;

    // Check wallet balance
    if (paymentProvider.walletBalance < amount) {
      if (mounted) {
        final shouldAddFunds = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Insufficient Balance'),
            content: Text(
              'Your wallet balance (${CurrencyFormatter.formatCurrency(paymentProvider.walletBalance)}) '
              'is less than the required amount (${CurrencyFormatter.formatCurrency(amount)}).\n\n'
              'Would you like to add funds?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Add Funds'),
              ),
            ],
          ),
        );

        if (shouldAddFunds == true) {
          context.push('/wallet');
          return;
        }
      }
      return;
    }

    // Process payment
    final success = await paymentProvider.processPayment(
      bookingId: widget.bookingId,
      amount: amount,
      paymentMethod: 'wallet',
    );

    if (!mounted) return;

    if (success) {
      // Update booking status to confirmed
      try {
        await bookingProvider.updateBookingStatus(
          widget.bookingId,
          BookingStatus.confirmed,
        );
      } catch (e) {
        // Log error but don't block user
        debugPrint('Failed to update booking status: $e');
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment processed successfully'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(paymentProvider.error ?? 'Payment failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookingProvider = Provider.of<BookingProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    
    final booking = bookingProvider.selectedBooking;
    final amount = booking?.cost ?? 0.0;
    final isLoading = bookingProvider.isLoading || paymentProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: isLoading && booking == null
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (booking != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.spacingMD),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Details',
                              style: AppTextStyles.h3(isDark: isDark),
                            ),
                            const SizedBox(height: AppDimensions.spacingSM),
                            Text('Service: ${booking.serviceType.name.toUpperCase()}'),
                            if (booking.vehicleModel != null)
                              Text('Vehicle: ${booking.vehicleModel}'),
                            if (booking.mechanicName != null)
                              Text('Mechanic: ${booking.mechanicName}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLG),
                  ],
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingXL),
                      child: Column(
                        children: [
                          Text(
                            'Service Cost',
                            style: AppTextStyles.bodyMedium(isDark: isDark),
                          ),
                          const SizedBox(height: AppDimensions.spacingSM),
                          Text(
                            CurrencyFormatter.formatCurrency(amount),
                            style: AppTextStyles.h1(
                              color: AppColors.primary,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLG),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.spacingMD),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet Balance',
                            style: AppTextStyles.bodyMedium(isDark: isDark),
                          ),
                          const SizedBox(height: AppDimensions.spacingSM),
                          Text(
                            CurrencyFormatter.formatCurrency(paymentProvider.walletBalance),
                            style: AppTextStyles.h3(isDark: isDark),
                          ),
                          if (paymentProvider.walletBalance < amount)
                            Padding(
                              padding: const EdgeInsets.only(top: AppDimensions.spacingSM),
                              child: Text(
                                'Insufficient balance',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXL),
                  CustomButton(
                    text: 'Pay from Wallet',
                    onPressed: isLoading || amount == 0 || paymentProvider.walletBalance < amount
                        ? null
                        : _processPayment,
                    isLoading: isLoading,
                  ),
                  if (paymentProvider.walletBalance < amount) ...[
                    const SizedBox(height: AppDimensions.spacingMD),
                    TextButton(
                      onPressed: () => context.push('/wallet'),
                      child: const Text('Add Funds to Wallet'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

