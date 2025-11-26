import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/error_widget.dart' as error_widget;
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/payment_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/payment_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
      paymentProvider.loadWalletBalance();
      paymentProvider.loadTransactions(userId: authProvider.user?.id);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _showAddFundsDialog() async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    _amountController.clear();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            const Text(
              'Payment Method: Mobile Money',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && _amountController.text.isNotEmpty) {
      final amount = double.tryParse(_amountController.text);
      if (amount != null && amount > 0) {
        final success = await paymentProvider.addFunds(amount, 'mobile_money');
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funds added successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(paymentProvider.error ?? 'Failed to add funds'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid amount'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await paymentProvider.loadWalletBalance();
          await paymentProvider.loadTransactions(userId: authProvider.user?.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingXL),
                  child: Column(
                    children: [
                      Text(
                        'Current Balance',
                        style: AppTextStyles.bodyMedium(isDark: isDark),
                      ),
                      const SizedBox(height: AppDimensions.spacingSM),
                      if (paymentProvider.isLoading)
                        const CircularProgressIndicator()
                      else
                        Text(
                          CurrencyFormatter.formatCurrency(paymentProvider.walletBalance),
                          style: AppTextStyles.h1(
                            color: AppColors.primary,
                            isDark: isDark,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              CustomButton(
                text: 'Add Funds',
                onPressed: paymentProvider.isLoading ? null : _showAddFundsDialog,
                isLoading: paymentProvider.isLoading,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              Text(
                'Recent Transactions',
                style: AppTextStyles.h3(isDark: isDark),
              ),
              const SizedBox(height: AppDimensions.spacingMD),
              if (paymentProvider.isLoading)
                const LoadingIndicator()
              else if (paymentProvider.transactions.isEmpty)
                error_widget.EmptyStateWidget(
                  message: 'No transactions yet',
                  subtitle: 'Your transaction history will appear here',
                )
              else
                ...paymentProvider.transactions.take(10).map((transaction) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
                    child: ListTile(
                      leading: Icon(
                        transaction.type == TransactionType.credit
                            ? Icons.add_circle_outline
                            : Icons.remove_circle_outline,
                        color: transaction.type == TransactionType.credit
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      title: Text(
                        transaction.description ?? 
                        (transaction.type == TransactionType.credit
                            ? 'Funds Added'
                            : 'Payment'),
                      ),
                      subtitle: Text(
                        DateFormatter.formatBookingDate(transaction.createdAt),
                      ),
                      trailing: Text(
                        '${transaction.type == TransactionType.credit ? '+' : '-'}${CurrencyFormatter.formatCurrency(transaction.amount)}',
                        style: TextStyle(
                          color: transaction.type == TransactionType.credit
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

