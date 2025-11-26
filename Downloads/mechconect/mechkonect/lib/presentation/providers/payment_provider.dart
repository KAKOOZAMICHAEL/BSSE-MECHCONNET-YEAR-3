import 'package:flutter/foundation.dart';
import '../../data/models/payment_model.dart';
import '../../data/repositories/payment_repository.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentRepository _paymentRepository;

  double _walletBalance = 0.0;
  List<PaymentModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  PaymentProvider(this._paymentRepository);

  double get walletBalance => _walletBalance;
  List<PaymentModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<PaymentModel> get creditTransactions =>
      _transactions.where((t) => t.type == TransactionType.credit).toList();

  List<PaymentModel> get debitTransactions =>
      _transactions.where((t) => t.type == TransactionType.debit).toList();

  // Load wallet balance
  Future<void> loadWalletBalance() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _walletBalance = await _paymentRepository.getWalletBalance();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load transactions
  Future<void> loadTransactions({String? userId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _paymentRepository.getTransactions(userId: userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add funds to wallet
  Future<bool> addFunds(double amount, String paymentMethod) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payment = await _paymentRepository.addFunds(amount, paymentMethod);
      _transactions.insert(0, payment);
      
      // Update balance
      if (payment.status == PaymentStatus.completed) {
        _walletBalance += amount;
      }
      
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Process payment for booking
  Future<bool> processPayment({
    required String bookingId,
    required double amount,
    String? paymentMethod,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if wallet has sufficient balance
      if (paymentMethod == null || paymentMethod == 'wallet') {
        if (_walletBalance < amount) {
          _error = 'Insufficient wallet balance';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      final payment = await _paymentRepository.processPayment(
        bookingId: bookingId,
        amount: amount,
        paymentMethod: paymentMethod,
      );

      _transactions.insert(0, payment);

      // Update balance if payment was successful
      if (payment.status == PaymentStatus.completed &&
          (paymentMethod == null || paymentMethod == 'wallet')) {
        _walletBalance -= amount;
      }

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

