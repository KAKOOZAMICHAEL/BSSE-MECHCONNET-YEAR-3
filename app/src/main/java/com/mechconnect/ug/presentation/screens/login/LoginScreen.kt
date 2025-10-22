
package com.mechconnect.ug.presentation.screens.login

import android.app.Activity
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.HelpOutline
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.common.api.ApiException
import com.mechconnect.ug.R
import com.mechconnect.ug.domain.utils.Resource
import com.mechconnect.ug.presentation.navigation.Screen
import com.mech.connect.ug.presentation.theme.Primary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(
    navController: NavController, 
    viewModel: LoginViewModel = hiltViewModel(),
    googleSignInClient: GoogleSignInClient
) {
    var phoneNumber by remember { mutableStateOf("") }
    var otp by remember { mutableStateOf("") }
    var showOtpDialog by remember { mutableStateOf(false) }
    val context = LocalContext.current as Activity

    val otpState by viewModel.otpState.collectAsState()
    val signInState by viewModel.signInState.collectAsState()

    val googleSignInLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult(),
        onResult = { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val task = GoogleSignIn.getSignedInAccountFromIntent(result.data)
                try {
                    val account = task.getResult(ApiException::class.java)
                    account?.idToken?.let {
                        viewModel.signInWithGoogle(it)
                    }
                } catch (e: ApiException) {
                    Toast.makeText(context, e.localizedMessage, Toast.LENGTH_SHORT).show()
                }
            }
        }
    )

    LaunchedEffect(otpState) {
        when (otpState) {
            is Resource.Success -> {
                showOtpDialog = true
                Toast.makeText(context, context.getString(R.string.otp_sent), Toast.LENGTH_SHORT).show()
            }
            is Resource.Error -> {
                val error = (otpState as Resource.Error).message
                Toast.makeText(context, error, Toast.LENGTH_LONG).show()
            }
            else -> Unit
        }
    }

    LaunchedEffect(signInState) {
        when (signInState) {
            is Resource.Success -> {
                navController.navigate(Screen.Map.route) {
                    popUpTo(Screen.Login.route) { inclusive = true }
                }
            }
            is Resource.Error -> {
                val error = (signInState as Resource.Error).message
                Toast.makeText(context, error, Toast.LENGTH_LONG).show()
            }
            else -> Unit
        }
    }

    if (showOtpDialog) {
        AlertDialog(
            onDismissRequest = { showOtpDialog = false },
            title = { Text(stringResource(R.string.enter_otp)) },
            text = {
                OutlinedTextField(
                    value = otp,
                    onValueChange = { otp = it },
                    label = { Text(stringResource(R.string.otp)) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                )
            },
            confirmButton = {
                Button(onClick = { viewModel.verifyOtp(otp) }) {
                    Text(stringResource(R.string.verify))
                }
            }
        )
    }

    Scaffold(
        containerColor = MaterialTheme.colorScheme.background
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(horizontal = 24.dp)
                .verticalScroll(rememberScrollState())
        ) {
            // Header
            Box(modifier = Modifier.fillMaxWidth().padding(top = 16.dp), contentAlignment = Alignment.CenterEnd) {
                IconButton(onClick = { /* TODO: Help action */ }) {
                    Icon(Icons.Default.HelpOutline, contentDescription = stringResource(R.string.help), tint = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }

            Spacer(modifier = Modifier.weight(0.5f))

            // Main Content
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text(
                    text = stringResource(R.string.welcome_to_mechconnect),
                    fontSize = 26.sp,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    text = stringResource(R.string.enter_phone_to_continue),
                    fontSize = 16.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.height(40.dp))

                // Phone Number Input
                OutlinedTextField(
                    value = phoneNumber,
                    onValueChange = { phoneNumber = it },
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = { Text(stringResource(R.string.phone_number_hint)) },
                    leadingIcon = {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text(stringResource(R.string.country_code), fontWeight = FontWeight.Medium, fontSize = 16.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Spacer(modifier = Modifier.width(8.dp))
                        }
                    },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                    shape = RoundedCornerShape(12.dp),
                    colors = TextFieldDefaults.outlinedTextFieldColors(
                        containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f),
                        unfocusedBorderColor = Color.Transparent,
                        focusedBorderColor = Primary
                    ),
                    singleLine = true
                )
                Spacer(modifier = Modifier.height(24.dp))

                // Send OTP Button
                Button(
                    onClick = { viewModel.sendOtp("${stringResource(R.string.country_code)}$phoneNumber", context) },
                    modifier = Modifier.fillMaxWidth().height(50.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = Primary)
                ) {
                    if (otpState is Resource.Loading) {
                        CircularProgressIndicator(color = Color.White)
                    } else {
                        Text(stringResource(R.string.send_otp), fontWeight = FontWeight.Bold, fontSize = 16.sp)
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Divider
            Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
                Divider(modifier = Modifier.weight(1f), color = MaterialTheme.colorScheme.outlineVariant)
                Text(
                    stringResource(R.string.or_continue_with),
                    modifier = Modifier.padding(horizontal = 16.dp),
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Divider(modifier = Modifier.weight(1f), color = MaterialTheme.colorScheme.outlineVariant)
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Social Logins
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                SocialButton(
                    text = stringResource(R.string.facebook),
                    iconRes = R.drawable.ic_facebook,
                    onClick = { /* TODO */ },
                    modifier = Modifier.weight(1f)
                )
                SocialButton(
                    text = stringResource(R.string.google),
                    iconRes = R.drawable.ic_google,
                    onClick = { googleSignInLauncher.launch(googleSignInClient.signInIntent) },
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.weight(1f))

            // Footer
            Text(
                text = stringResource(R.string.terms_and_conditions),
                fontSize = 12.sp,
                textAlign = TextAlign.Center,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(vertical = 24.dp)
            )
        }
    }
}

@Composable
fun SocialButton(text: String, iconRes: Int, onClick: () -> Unit, modifier: Modifier = Modifier) {
    OutlinedButton(
        onClick = onClick,
        modifier = modifier.height(50.dp),
        shape = RoundedCornerShape(12.dp),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(painter = painterResource(id = iconRes), contentDescription = text, modifier = Modifier.size(20.dp), tint = Color.Unspecified)
            Spacer(modifier = Modifier.width(8.dp))
            Text(text, fontWeight = FontWeight.SemiBold, color = MaterialTheme.colorScheme.onSurface)
        }
    }
}
