import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../models/payment_model.dart';

class PaymentRepository {
  final ApiService _apiService;
  final LocalStorageService _localStorage;

  PaymentRepository({
    required ApiService apiService,
    required LocalStorageService localStorage,
  })  : _apiService = apiService,
        _localStorage = localStorage;

  // Get wallet balance
  Future<double> getWalletBalance() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Return cached balance if available
        final transactions = await _localStorage.getPayments('');
        double balance = 0.0;
        for (final transaction in transactions) {
          if (transaction.status == PaymentStatus.completed) {
            if (transaction.type == TransactionType.credit) {
              balance += transaction.amount;
            } else if (transaction.type == TransactionType.debit) {
              balance -= transaction.amount;
            }
          }
        }
        return balance;
      }

      final response = await _apiService.getWalletBalance();
      return (response['balance'] as num).toDouble();
    } catch (e) {
      // Fallback to local calculation
      final transactions = await _localStorage.getPayments('');
      double balance = 0.0;
      for (final transaction in transactions) {
        if (transaction.status == PaymentStatus.completed) {
          if (transaction.type == TransactionType.credit) {
            balance += transaction.amount;
          } else if (transaction.type == TransactionType.debit) {
            balance -= transaction.amount;
          }
        }
      }
      return balance;
    }
  }

  // Add funds to wallet
  Future<PaymentModel> addFunds(double amount, String paymentMethod) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection. Please connect to add funds.');
      }

      final payment = await _apiService.addFunds({
        'amount': amount,
        'paymentMethod': paymentMethod,
      });

      await _localStorage.insertPayment(payment);
      return payment;
    } catch (e) {
      throw Exception('Failed to add funds: ${e.toString()}');
    }
  }

  // Get transactions
  Future<List<PaymentModel>> getTransactions({String? userId}) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return await _localStorage.getPayments(userId ?? '');
      }

      final transactions = await _apiService.getTransactions();
      
      // Cache transactions
      for (final transaction in transactions) {
        await _localStorage.insertPayment(transaction);
      }

      // Filter by userId if provided
      if (userId != null) {
        return transactions.where((t) => t.userId == userId).toList();
      }

      return transactions;
    } catch (e) {
      // Fallback to local storage
      return await _localStorage.getPayments(userId ?? '');
    }
  }

  // Process payment for booking
  Future<PaymentModel> processPayment({
    required String bookingId,
    required double amount,
    String? paymentMethod,
  }) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        throw Exception('No internet connection. Please connect to process payment.');
      }

      final payment = await _apiService.processPayment({
        'bookingId': bookingId,
        'amount': amount,
        'paymentMethod': paymentMethod ?? 'wallet',
      });

      await _localStorage.insertPayment(payment);
      return payment;
    } catch (e) {
      throw Exception('Failed to process payment: ${e.toString()}');
    }
  }
}

