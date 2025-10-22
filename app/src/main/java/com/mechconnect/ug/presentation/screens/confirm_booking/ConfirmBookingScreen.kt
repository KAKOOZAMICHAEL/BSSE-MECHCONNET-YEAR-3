
package com.mechconnect.ug.presentation.screens.confirm_booking

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Build
import androidx.compose.material.icons.filled.Payments
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import coil.compose.rememberAsyncImagePainter
import com.mechconnect.ug.domain.model.Mechanic
import com.mechconnect.ug.domain.utils.Resource
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.IconBackgroundDark
import com.mechconnect.ug.presentation.theme.IconBackgroundLight
import com.mechconnect.ug.presentation.theme.Primary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ConfirmBookingScreen(
    navController: NavController,
    viewModel: ConfirmBookingViewModel = hiltViewModel()
) {
    val mechanicState by viewModel.mechanic.collectAsState()
    val context = LocalContext.current

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Confirm Booking", fontWeight = FontWeight.Bold, modifier = Modifier.fillMaxWidth(), textAlign = TextAlign.Center) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = { Spacer(modifier = Modifier.width(48.dp)) },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent)
            )
        },
        bottomBar = {
            Surface(shadowElevation = 8.dp, color = MaterialTheme.colorScheme.background) {
                Button(
                    onClick = { navController.navigate(Screen.Payment.route) },
                    modifier = Modifier.fillMaxWidth().padding(16.dp).height(56.dp),
                    shape = RoundedCornerShape(16.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = Primary),
                    enabled = mechanicState is Resource.Success
                ) {
                    Text("Confirm Booking", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                }
            }
        }
    ) { paddingValues ->
        Box(modifier = Modifier.fillMaxSize().padding(paddingValues)) {
            when (val state = mechanicState) {
                is Resource.Loading -> {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }
                is Resource.Success -> {
                    val mechanic = state.data
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(horizontal = 16.dp)
                            .verticalScroll(rememberScrollState())
                    ) {
                        Spacer(modifier = Modifier.height(16.dp))
                        Text("Service Details", fontSize = 22.sp, fontWeight = FontWeight.Bold)
                        Spacer(modifier = Modifier.height(16.dp))

                        Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            ServiceDetailCard(
                                icon = null,
                                imageUrl = mechanic.imageUrl,
                                title = mechanic.name,
                                subtitle = "Mechanic"
                            )
                            ServiceDetailCard(
                                icon = Icons.Default.Build,
                                title = "Engine Diagnostics",
                                subtitle = "Service"
                            )
                            ServiceDetailCard(
                                icon = Icons.Default.Schedule,
                                title = "30-45 minutes",
                                subtitle = "Estimated Arrival"
                            )
                            ServiceDetailCard(
                                icon = Icons.Default.Payments,
                                title = "UGX 50,000",
                                subtitle = "Total Cost"
                            )
                        }
                    }
                }
                is Resource.Error -> {
                    val error = state.message
                    Toast.makeText(context, error, Toast.LENGTH_LONG).show()
                }
            }
        }
    }
}

@Composable
fun ServiceDetailCard(
    icon: ImageVector?,
    title: String,
    subtitle: String,
    imageUrl: String? = null
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.surface, RoundedCornerShape(12.dp))
            .padding(12.dp)
    ) {
        Box(
            modifier = Modifier
                .size(56.dp)
                .clip(if (imageUrl != null) CircleShape else RoundedCornerShape(12.dp))
                .background(if (androidx.compose.foundation.isSystemInDarkTheme()) IconBackgroundDark else IconBackgroundLight),
            contentAlignment = Alignment.Center
        ) {
            if (imageUrl != null) {
                Image(
                    painter = rememberAsyncImagePainter(imageUrl),
                    contentDescription = title,
                    modifier = Modifier.fillMaxSize(),
                    contentScale = ContentScale.Crop
                )
            } else if (icon != null) {
                Icon(
                    imageVector = icon,
                    contentDescription = title,
                    modifier = Modifier.size(32.dp),
                    tint = MaterialTheme.colorScheme.onSurface
                )
            }
        }
        Spacer(modifier = Modifier.width(16.dp))
        Column {
            Text(title, fontWeight = FontWeight.Bold, fontSize = 16.sp)
            Text(subtitle, fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    }
}
