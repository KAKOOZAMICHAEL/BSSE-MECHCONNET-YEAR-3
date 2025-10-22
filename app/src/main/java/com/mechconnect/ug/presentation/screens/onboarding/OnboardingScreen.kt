package com.mechconnect.ug.presentation.screens.onboarding

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.CheckCircle
import androidx.compose.material.icons.rounded.FlashOn
import androidx.compose.material.icons.rounded.Schedule
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.rememberAsyncImagePainter
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.Primary

@Composable
fun OnboardingScreen(navController: NavController) {
    Scaffold(
        bottomBar = {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                shadowElevation = 8.dp,
                color = MaterialTheme.colorScheme.background
            ) {
                Button(
                    onClick = { navController.navigate(Screen.Login.route) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)
                        .height(56.dp),
                    shape = RoundedCornerShape(12.dp),
                    colors = ButtonDefaults.buttonColors(containerColor = Primary)
                ) {
                    Text("Get Started", fontSize = 18.sp, fontWeight = FontWeight.Bold)
                }
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .background(MaterialTheme.colorScheme.background)
        ) {
            Box(modifier = Modifier.fillMaxWidth().height(300.dp)) {
                Image(
                    painter = rememberAsyncImagePainter("https://lh3.googleusercontent.com/aida-public/AB6AXuAtQYN1feLqQ-FIBjz4-4K_uquiy53yqpiaQeBytSKTyJ4P5RnQc3_9-LA_1vZUueKx4GFVhvxQ4zu-BmfozvFTmpXnkqiB9x3vQBlt8-pIfd4WiABe1jUG4cUjrigUBtIl4lR3Y1B0kEr8DTNfhzbnhrJw4IXA_oTbBfrHYF7PUrPDyYK48CNwq2I2hB3iVo2tTOM2P0M1zdmL5jOq4zd-7tOW6IbubkdtTIbQlK2ghrz9xIJWkl5deXY6toFgvo4PT8DBqmxhUkQ"),
                    contentDescription = "Mechanic working on car",
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize()
                )
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .background(
                            Brush.verticalGradient(
                                colors = listOf(
                                    Color.Transparent,
                                    MaterialTheme.colorScheme.background
                                ),
                                startY = 200f
                            )
                        )
                )
            }

            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp)
                    .offset(y = (-64).dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Find Trusted Mechanics and Emergency Services",
                    fontWeight = FontWeight.Bold,
                    fontSize = 26.sp,
                    textAlign = TextAlign.Center,
                    lineHeight = 32.sp,
                    color = MaterialTheme.colorScheme.onBackground
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = "MechConnect Uganda connects you with vetted mechanics and emergency ambulance services in real time, ensuring safety and reliability on the road.",
                    textAlign = TextAlign.Center,
                    fontSize = 16.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            Column(
                modifier = Modifier.padding(horizontal = 24.dp),
                verticalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                FeatureCard(
                    icon = Icons.Rounded.CheckCircle,
                    title = "Vetted Professionals",
                    description = "Access a network of highly skilled and verified mechanics."
                )
                FeatureCard(
                    icon = Icons.Rounded.FlashOn,
                    title = "Real-Time Assistance",
                    description = "Get instant help with real-time location tracking."
                )
                FeatureCard(
                    icon = Icons.Rounded.Schedule,
                    title = "Emergency Ready",
                    description = "Quick access to ambulance services when you need them most."
                )
            }
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
fun FeatureCard(icon: ImageVector, title: String, description: String) {
    Card(
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(RoundedCornerShape(50))
                    .background(Primary.copy(alpha = 0.1f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = title,
                    tint = Primary,
                    modifier = Modifier.size(24.dp)
                )
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column {
                Text(
                    text = title,
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 18.sp,
                    color = MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = description,
                    fontSize = 14.sp,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
