
package com.mechconnect.ug.domain.repository

import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.AuthResult
import com.mechconnect.ug.domain.utils.Resource
import kotlinx.coroutines.flow.Flow

interface AuthRepository {

    fun sendOtp(phoneNumber: String, activity: android.app.Activity): Flow<Resource<String>>

    fun verifyOtp(verificationId: String, otp: String): Flow<Resource<AuthResult>>

    fun signInWithCredential(credential: AuthCredential): Flow<Resource<AuthResult>>

    fun signInWithGoogle(idToken: String): Flow<Resource<AuthResult>>
}   
