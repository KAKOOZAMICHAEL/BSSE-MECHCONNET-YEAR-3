
package com.mechconnect.ug.presentation.screens.login

import android.app.Activity
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.mechconnect.ug.domain.repository.AuthRepository
import com.mechconnect.ug.domain.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class LoginViewModel @Inject constructor(
    private val authRepository: AuthRepository
) : ViewModel() {

    private val _verificationId = MutableStateFlow<String?>(null)

    private val _otpState = MutableStateFlow<Resource<String>?>(null)
    val otpState = _otpState.asStateFlow()

    private val _signInState = MutableStateFlow<Resource<com.google.firebase.auth.AuthResult>?>(null)
    val signInState = _signInState.asStateFlow()

    fun sendOtp(phoneNumber: String, activity: Activity) {
        viewModelScope.launch {
            authRepository.sendOtp(phoneNumber, activity).collect {
                _otpState.value = it
                if (it is Resource.Success) {
                    _verificationId.value = it.data
                }
            }
        }
    }

    fun verifyOtp(otp: String) {
        viewModelScope.launch {
            _verificationId.value?.let {
                authRepository.verifyOtp(it, otp).collect {
                    _signInState.value = it
                }
            }
        }
    }

    fun signInWithGoogle(idToken: String) {
        viewModelScope.launch {
            authRepository.signInWithGoogle(idToken).collect {
                _signInState.value = it
            }
        }
    }
}
