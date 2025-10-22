
package com.mechconnect.ug.data.repository

import android.app.Activity
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import com.mechconnect.ug.domain.repository.AuthRepository
import com.mechconnect.ug.domain.utils.Resource
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class AuthRepositoryImpl @Inject constructor(
    private val firebaseAuth: FirebaseAuth
): AuthRepository {
    override fun sendOtp(phoneNumber: String, activity: Activity): Flow<Resource<String>> = callbackFlow{
        trySend(Resource.Loading)

        val callbacks = object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {
            override fun onVerificationCompleted(credential: AuthCredential) {
                // Auto-retrieval may sign the user in
            }

            override fun onVerificationFailed(e: com.google.firebase.FirebaseException) {
                trySend(Resource.Error(e.message ?: "An unknown error occurred"))
            }

            override fun onCodeSent(verificationId: String, token: PhoneAuthProvider.ForceResendingToken) {
                trySend(Resource.Success(verificationId))
            }
        }

        val options = PhoneAuthOptions.newBuilder(firebaseAuth)
            .setPhoneNumber(phoneNumber)
            .setTimeout(60L, TimeUnit.SECONDS)
            .setActivity(activity)
            .setCallbacks(callbacks)
            .build()
        PhoneAuthProvider.verifyPhoneNumber(options)

        awaitClose { /* Cleanup */ }
    }

    override fun verifyOtp(verificationId: String, otp: String): Flow<Resource<AuthResult>> = callbackFlow {
        trySend(Resource.Loading)
        val credential = PhoneAuthProvider.getCredential(verificationId, otp)
        firebaseAuth.signInWithCredential(credential)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    trySend(Resource.Success(task.result))
                } else {
                    trySend(Resource.Error(task.exception?.message ?: "An unknown error occurred"))
                }
            }
        awaitClose {}
    }

    override fun signInWithCredential(credential: AuthCredential): Flow<Resource<AuthResult>> = callbackFlow {
        trySend(Resource.Loading)
        firebaseAuth.signInWithCredential(credential)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    trySend(Resource.Success(task.result))
                } else {
                    trySend(Resource.Error(task.exception?.message ?: "An unknown error occurred"))
                }
            }
        awaitClose {}
    }

    override fun signInWithGoogle(idToken: String): Flow<Resource<AuthResult>> = callbackFlow {
        trySend(Resource.Loading)
        val credential = GoogleAuthProvider.getCredential(idToken, null)
        firebaseAuth.signInWithCredential(credential)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    trySend(Resource.Success(task.result))
                } else {
                    trySend(Resource.Error(task.exception?.message ?: "An unknown error occurred"))
                }
            }
        awaitClose {}
    }
}
