
package com.mechconnect.ug.presentation.screens.payment

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBackIosNew
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.mechconnect.ug.R
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.Inter
import com.mechconnect.ug.presentation.theme.Primary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaymentScreen(
    navController: NavController,
    viewModel: PaymentViewModel = hiltViewModel()
) {
    var phoneNumber by remember { mutableStateOf("") }
    val paymentOptions by viewModel.paymentOptions.collectAsState()
    val selectedPayment by viewModel.selectedPayment.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Payment", fontFamily = Inter, fontWeight = FontWeight.Bold, modifier = Modifier.fillMaxWidth(), textAlign = TextAlign.Center) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.ArrowBackIosNew, contentDescription = "Back")
                    }
                },
                actions = { Spacer(modifier = Modifier.width(48.dp)) },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent)
            )
        },
        bottomBar = {
            Surface(shadowElevation = 8.dp, color = MaterialTheme.colorScheme.background) {
                Button(
                    onClick = {
                        // TODO: Handle payment confirmation logic
                        navController.navigate(Screen.Onboarding.route) {
                            popUpTo(Screen.Onboarding.route) { inclusive = true }
                        }
                    },
                    modifier = Modifier.fillMaxWidth().padding(16.dp).height(56.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = Primary)
                ) {
                    Icon(Icons.Default.Lock, contentDescription = null)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Confirm Payment", fontSize = 16.sp, fontWeight = FontWeight.Bold, fontFamily = Inter)
                }
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(horizontal = 16.dp)
                .verticalScroll(rememberScrollState())
        ) {
            Spacer(modifier = Modifier.height(16.dp))
            Text("Payment Method", fontFamily = Inter, fontWeight = FontWeight.SemiBold, fontSize = 18.sp)
            Spacer(modifier = Modifier.height(16.dp))

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                paymentOptions.forEach { option ->
                    PaymentOption(
                        text = option,
                        iconRes = when (option) {
                            "MTN Mobile Money" -> R.drawable.ic_mtn
                            "Airtel Money" -> R.drawable.ic_airtel
                            else -> R.drawable.ic_visa
                        },
                        selected = selectedPayment == option,
                        onSelected = { viewModel.onPaymentMethodSelected(option) }
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            Text("Phone Number", fontFamily = Inter, fontWeight = FontWeight.Medium, fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = phoneNumber,
                onValueChange = { phoneNumber = it },
                modifier = Modifier.fillMaxWidth(),
                placeholder = { Text("Enter your phone number") },
                leadingIcon = { Icon(Icons.Default.Phone, contentDescription = "Phone") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedBorderColor = Primary,
                    unfocusedBorderColor = MaterialTheme.colorScheme.outline
                ),
                singleLine = true
            )
        }
    }
}

@Composable
fun PaymentOption(text: String, iconRes: Int, selected: Boolean, onSelected: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(12.dp))
            .selectable(
                selected = selected,
                onClick = onSelected,
                role = Role.RadioButton
            ),
        shape = RoundedCornerShape(12.dp),
        border = BorderStroke(
            width = if (selected) 2.dp else 1.dp,
            color = if (selected) Primary else MaterialTheme.colorScheme.outline
        ),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Image(
                    painter = painterResource(id = iconRes),
                    contentDescription = text,
                    modifier = Modifier.height(32.dp).width(40.dp)
                )
                Spacer(modifier = Modifier.width(16.dp))
                Text(text, fontFamily = Inter, fontWeight = FontWeight.Medium, color = MaterialTheme.colorScheme.onSurface)
            }
            RadioButton(
                selected = selected,
                onClick = null, // Handled by selectable modifier
                colors = RadioButtonDefaults.colors(selectedColor = Primary)
            )
        }
    }
}
