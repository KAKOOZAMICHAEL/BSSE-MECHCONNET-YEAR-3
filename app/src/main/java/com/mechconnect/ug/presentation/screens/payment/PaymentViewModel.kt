
package com.mechconnect.ug.presentation.screens.payment

import androidx.lifecycle.ViewModel
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject

@HiltViewModel
class PaymentViewModel @Inject constructor() : ViewModel() {

    private val _paymentOptions = MutableStateFlow(listOf("MTN Mobile Money", "Airtel Money", "Visa"))
    val paymentOptions = _paymentOptions.asStateFlow()

    private val _selectedPayment = MutableStateFlow(_paymentOptions.value[0])
    val selectedPayment = _selectedPayment.asStateFlow()

    fun onPaymentMethodSelected(paymentMethod: String) {
        _selectedPayment.value = paymentMethod
    }
}
