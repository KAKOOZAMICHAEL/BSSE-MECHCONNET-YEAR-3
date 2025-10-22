
package com.mechconnect.ug.presentation.screens.map

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.mechconnect.ug.R
import com.mechconnect.ug.presentation.navigation.Screen

@Composable
fun DrawerContent(navController: NavController) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(16.dp)
    ) {
        // Profile Section
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(bottom = 16.dp)
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_profile_placeholder),
                contentDescription = "Profile Picture",
                modifier = Modifier
                    .size(64.dp)
                    .clip(CircleShape),
                contentScale = ContentScale.Crop
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text("John Doe", fontWeight = FontWeight.Bold, fontSize = 18.sp)
                Text("+256 771 234 567", fontSize = 14.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
        Divider()

        // Navigation Items
        Column(modifier = Modifier.padding(top = 16.dp)) {
            DrawerItem(icon = Icons.Default.Home, text = "Home") {
                navController.navigate(Screen.Map.route)
            }
            DrawerItem(icon = Icons.Default.Person, text = "Profile") {
                navController.navigate(Screen.Profile.route)
            }
            DrawerItem(icon = Icons.Default.History, text = "Ride History") {
                navController.navigate(Screen.History.route)
            }
            DrawerItem(icon = Icons.Default.Settings, text = "Settings") {
                navController.navigate(Screen.Settings.route)
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        // Logout Button
        DrawerItem(icon = Icons.Default.ExitToApp, text = "Logout") {
            // TODO: Handle Logout
            navController.navigate(Screen.Login.route) {
                popUpTo(Screen.Map.route) { inclusive = true }
            }
        }
    }
}

@Composable
private fun DrawerItem(
    icon: ImageVector,
    text: String,
    onItemClick: () -> Unit
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onItemClick() }
            .padding(vertical = 12.dp)
    ) {
        Icon(imageVector = icon, contentDescription = text, tint = MaterialTheme.colorScheme.primary)
        Spacer(modifier = Modifier.width(16.dp))
        Text(text, fontSize = 16.sp, color = MaterialTheme.colorScheme.onSurface)
    }
}
