
package com.mechconnect.ug.presentation.screens.map

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.*
import com.mechconnect.ug.domain.utils.PermissionUtils
import com.mechconnect.ug.domain.utils.Resource
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.Primary
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MapScreen(
    navController: NavController,
    viewModel: MapViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val cameraPositionState = rememberCameraPositionState {
        position = CameraPosition.fromLatLngZoom(LatLng(1.3733, 32.2903), 7f)
    }
    var searchText by remember { mutableStateOf("") }
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val scope = rememberCoroutineScope()

    val currentLocation by viewModel.currentLocation.collectAsState()

    val locationPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission(),
        onResult = {
            if (it) {
                viewModel.getCurrentLocation()
            } else {
                Toast.makeText(context, "Location permission denied", Toast.LENGTH_SHORT).show()
            }
        }
    )

    val callPermissionLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.RequestPermission(),
        onResult = {
            if (it) {
                val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:999"))
                context.startActivity(intent)
            } else {
                Toast.makeText(context, "Call permission denied", Toast.LENGTH_SHORT).show()
            }
        }
    )

    LaunchedEffect(Unit) {
        if (PermissionUtils.hasLocationPermission(context)) {
            viewModel.getCurrentLocation()
        } else {
            locationPermissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }

    LaunchedEffect(currentLocation) {
        if (currentLocation is Resource.Success) {
            val location = (currentLocation as Resource.Success).data
            cameraPositionState.position = CameraPosition.fromLatLngZoom(LatLng(location.latitude, location.longitude), 15f)
        }
    }

    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = { 
            DrawerContent(navController = navController) 
        }
    ) {
        Scaffold(
            bottomBar = {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(MaterialTheme.colorScheme.background)
                        .padding(16.dp)
                ) {
                    Button(
                        onClick = { navController.navigate(Screen.FindMechanic.route) },
                        modifier = Modifier.fillMaxWidth().height(56.dp),
                        shape = RoundedCornerShape(12.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Primary)
                    ) {
                        Text("Request Mechanic", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                    Button(
                        onClick = {
                            if (ContextCompat.checkSelfPermission(
                                    context,
                                    Manifest.permission.CALL_PHONE
                                ) == PackageManager.PERMISSION_GRANTED
                            ) {
                                val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:999"))
                                context.startActivity(intent)
                            } else {
                                callPermissionLauncher.launch(Manifest.permission.CALL_PHONE)
                            }
                        },
                        modifier = Modifier.fillMaxWidth().height(56.dp),
                        shape = RoundedCornerShape(12.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Color.Red)
                    ) {
                        Text("SOS", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                    }
                }
            }
        ) { paddingValues ->
            Box(modifier = Modifier.fillMaxSize().padding(paddingValues)) {
                GoogleMap(
                    modifier = Modifier.fillMaxSize(),
                    cameraPositionState = cameraPositionState,
                    uiSettings = MapUiSettings(zoomControlsEnabled = false)
                ) {
                    if (currentLocation is Resource.Success) {
                        val location = (currentLocation as Resource.Success).data
                        Marker(
                            state = MarkerState(position = LatLng(location.latitude, location.longitude)),
                            title = "My Location"
                        )
                    }
                }

                // Header
                TopAppBar(
                    title = { Text("MechConnect", fontWeight = FontWeight.Bold) },
                    navigationIcon = {
                        IconButton(onClick = { 
                            scope.launch { 
                                drawerState.open() 
                            }
                        }) {
                            Icon(Icons.Default.Menu, contentDescription = "Menu")
                        }
                    },
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = MaterialTheme.colorScheme.background.copy(alpha = 0.8f)
                    )
                )

                // Search and Map Controls
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(top = 80.dp, start = 16.dp, end = 16.dp, bottom = 16.dp),
                    verticalArrangement = Arrangement.SpaceBetween
                ) {
                    // Search Bar
                    TextField(
                        value = searchText,
                        onValueChange = { searchText = it },
                        modifier = Modifier
                            .fillMaxWidth()
                            .shadow(8.dp, RoundedCornerShape(12.dp)),
                        placeholder = { Text("Search for a location") },
                        leadingIcon = { Icon(Icons.Default.Search, contentDescription = "Search") },
                        shape = RoundedCornerShape(12.dp),
                        colors = TextFieldDefaults.colors(
                            focusedIndicatorColor = Color.Transparent,
                            unfocusedIndicatorColor = Color.Transparent,
                            disabledIndicatorColor = Color.Transparent,
                            cursorColor = Primary
                        )
                    )

                    // Map Controls
                    Column(horizontalAlignment = Alignment.End, modifier = Modifier.fillMaxWidth()) {
                        FloatingActionButton(
                            onClick = { cameraPositionState.move(CameraUpdateFactory.zoomIn()) },
                            shape = CircleShape,
                            modifier = Modifier.size(48.dp)
                        ) {
                            Icon(Icons.Default.Add, contentDescription = "Zoom In")
                        }
                        Spacer(modifier = Modifier.height(8.dp))
                        FloatingActionButton(
                            onClick = { cameraPositionState.move(CameraUpdateFactory.zoomOut()) },
                            shape = CircleShape,
                            modifier = Modifier.size(48.dp)
                        ) {
                            Icon(Icons.Default.Remove, contentDescription = "Zoom Out")
                        }
                        Spacer(modifier = Modifier.height(16.dp))
                        FloatingActionButton(
                            onClick = { 
                                if (currentLocation is Resource.Success) {
                                    val location = (currentLocation as Resource.Success).data
                                    cameraPositionState.position = CameraPosition.fromLatLngZoom(LatLng(location.latitude, location.longitude), 15f)
                                }
                            },
                            shape = RoundedCornerShape(12.dp),
                            containerColor = MaterialTheme.colorScheme.background,
                            modifier = Modifier.size(56.dp)
                        ) {
                            Icon(Icons.Default.NearMe, contentDescription = "My Location", tint = Primary)
                        }
                    }
                }
            }
        }
    }
}
