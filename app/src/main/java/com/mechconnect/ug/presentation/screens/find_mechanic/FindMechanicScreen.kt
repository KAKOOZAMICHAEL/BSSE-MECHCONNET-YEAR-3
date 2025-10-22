
package com.mechconnect.ug.presentation.screens.find_mechanic

import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import coil.compose.rememberAsyncImagePainter
import com.mechconnect.ug.domain.model.Mechanic
import com.mechconnect.ug.domain.utils.Resource
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.Primary
import com.mechconnect.ug.presentation.theme.ShimmerEffect
import com.mechconnect.ug.presentation.theme.ShimmerPlaceholder

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FindMechanicScreen(
    navController: NavController,
    viewModel: FindMechanicViewModel = hiltViewModel()
) {
    val mechanicsState by viewModel.mechanics.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    val selectedFilter by viewModel.selectedFilter.collectAsState()
    val context = LocalContext.current

    Scaffold(
        topBar = {
            Column(modifier = Modifier.background(MaterialTheme.colorScheme.background).padding(16.dp)) {
                TopAppBar(
                    title = { Text("Find a Mechanic", fontWeight = FontWeight.Bold, modifier = Modifier.fillMaxWidth(), textAlign = androidx.compose.ui.text.style.TextAlign.Center) },
                    navigationIcon = {
                        IconButton(onClick = { navController.popBackStack() }) {
                            Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                        }
                    },
                    actions = { Spacer(modifier = Modifier.width(48.dp)) },
                    colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent)
                )
                Spacer(modifier = Modifier.height(16.dp))
                TextField(
                    value = searchQuery,
                    onValueChange = { viewModel.onSearchQueryChanged(it) },
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = { Text("Search for a mechanic") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = "Search") },
                    shape = RoundedCornerShape(12.dp),
                    colors = TextFieldDefaults.colors(
                        focusedIndicatorColor = Color.Transparent,
                        unfocusedIndicatorColor = Color.Transparent,
                    )
                )
                Spacer(modifier = Modifier.height(16.dp))
                FilterChips(
                    selectedFilter = selectedFilter,
                    onFilterChanged = { viewModel.onFilterChanged(it) }
                )
            }
        },
        bottomBar = {
            BottomNavigationBar(navController)
        }
    ) { paddingValues ->
        Box(modifier = Modifier.fillMaxSize().padding(paddingValues)) {
            when (val state = mechanicsState) {
                is Resource.Loading -> {
                    ShimmerEffect {
                        LazyColumn(
                            modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.background),
                            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                            verticalArrangement = Arrangement.spacedBy(12.dp)
                        ) {
                            items(10) { 
                                ShimmerMechanicCard() 
                            }
                        }
                    }
                }
                is Resource.Success -> {
                    val mechanics = state.data
                    if (mechanics.isEmpty()) {
                        Text("No mechanics found", modifier = Modifier.align(Alignment.Center))
                    } else {
                        LazyColumn(
                            modifier = Modifier.fillMaxSize().background(MaterialTheme.colorScheme.background),
                            contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
                            verticalArrangement = Arrangement.spacedBy(12.dp)
                        ) {
                            items(mechanics) { mechanic ->
                                MechanicCard(mechanic = mechanic, onClick = {
                                    navController.navigate(Screen.ConfirmBooking.route + "/${mechanic.name}")
                                })
                            }
                        }
                    }
                }
                is Resource.Error -> {
                    val error = state.message
                    Toast.makeText(context, error, Toast.LENGTH_LONG).show()
                }
                else -> Unit
            }
        }
    }
}

@Composable
fun FilterChips(selectedFilter: String, onFilterChanged: (String) -> Unit) {
    val filters = listOf("Nearest", "Top-Rated", "Cheapest")
    LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        items(filters) { filter ->
            val isSelected = filter == selectedFilter
            FilterChip(
                selected = isSelected,
                onClick = { onFilterChanged(filter) },
                label = { Text(filter) },
                trailingIcon = { Icon(Icons.Default.ExpandMore, contentDescription = null) },
                colors = FilterChipDefaults.filterChipColors(
                    selectedContainerColor = Primary.copy(alpha = 0.1f),
                    selectedLabelColor = Primary,
                    selectedTrailingIconColor = Primary
                ),
                border = FilterChipDefaults.filterChipBorder(
                    borderColor = if (isSelected) Primary else MaterialTheme.colorScheme.outline
                )
            )
        }
    }
}

@Composable
fun MechanicCard(mechanic: Mechanic, onClick: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth().clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.2f))
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                painter = rememberAsyncImagePainter(mechanic.imageUrl),
                contentDescription = mechanic.name,
                modifier = Modifier.size(64.dp).clip(CircleShape),
                contentScale = ContentScale.Crop
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(mechanic.name, fontWeight = FontWeight.Bold, fontSize = 18.sp)
                Spacer(modifier = Modifier.height(4.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Star, contentDescription = "Rating", tint = Color(0xFFFFC107), modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("${mechanic.rating}", fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
                    Text(" • ", fontSize = 14.sp)
                    Text("${mechanic.distance}km away", fontSize = 14.sp)
                }
            }
            Icon(Icons.Default.ChevronRight, contentDescription = "Details", tint = Primary, modifier = Modifier.size(32.dp))
        }
    }
}

@Composable
fun ShimmerMechanicCard() {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.2f))
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            ShimmerPlaceholder(modifier = Modifier.size(64.dp).clip(CircleShape))
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                ShimmerPlaceholder(modifier = Modifier.height(18.dp).fillMaxWidth(0.8f))
                Spacer(modifier = Modifier.height(4.dp))
                ShimmerPlaceholder(modifier = Modifier.height(14.dp).fillMaxWidth(0.5f))
            }
        }
    }
}


@Composable
fun BottomNavigationBar(navController: NavController) {
    var selectedItem by remember { mutableStateOf(0) }
    val items = listOf(
        "Home" to Screen.Map.route,
        "History" to Screen.History.route,
        "Profile" to Screen.Profile.route,
        "Settings" to Screen.Settings.route
    )
    val icons = listOf(Icons.Filled.Home, Icons.Filled.History, Icons.Filled.Person, Icons.Filled.Settings)

    NavigationBar(
        containerColor = MaterialTheme.colorScheme.background,
        tonalElevation = 8.dp
    ) {
        items.forEachIndexed { index, item ->
            NavigationBarItem(
                icon = { Icon(icons[index], contentDescription = item.first) },
                label = { Text(item.first) },
                selected = selectedItem == index,
                onClick = {
                    selectedItem = index
                    navController.navigate(item.second) {
                        // Pop up to the map screen to avoid building up a large back stack
                        popUpTo(Screen.Map.route) {
                            saveState = true
                        }
                        // Avoid multiple copies of the same destination when re-selecting the same item
                        launchSingleTop = true
                        // Restore state when re-selecting a previously selected item
                        restoreState = true
                    }
                },
                colors = NavigationBarItemDefaults.colors(
                    selectedIconColor = Primary,
                    unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    selectedTextColor = Primary,
                    unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    indicatorColor = Primary.copy(alpha = 0.1f)
                )
            )
        }
    }
}
