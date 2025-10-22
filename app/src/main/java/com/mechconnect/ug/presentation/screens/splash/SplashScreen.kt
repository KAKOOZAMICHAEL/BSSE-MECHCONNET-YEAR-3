package com.mechconnect.ug.presentation.screens.splash

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Build
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.mechconnect.ug.R
import com.mechconnect.ug.presentation.navigation.Screen
import com.mechconnect.ug.presentation.theme.Primary
import kotlinx.coroutines.delay

@Composable
fun SplashScreen(navController: NavController) {
    LaunchedEffect(key1 = true) {
        delay(3000L)
        navController.navigate(Screen.Onboarding.route) {
            popUpTo(Screen.Splash.route) { inclusive = true }
        }
    }

    val infiniteTransition = rememberInfiniteTransition(label = "spin")
    val angle by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 3000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ), label = "rotation"
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Box(contentAlignment = Alignment.Center, modifier = Modifier.size(112.dp)) {
                Icon(
                    imageVector = ImageVector.vectorResource(id = R.drawable.ic_loader_circle),
                    contentDescription = "Loading spinner",
                    tint = Primary,
                    modifier = Modifier.matchParentSize().rotate(angle)
                )
                Icon(
                    imageVector = ImageVector.vectorResource(id = R.drawable.ic_app_logo),
                    contentDescription = "App Logo",
                    tint = Primary,
                    modifier = Modifier.size(64.dp)
                )
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "MechConnect Uganda",
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onBackground
            )
        }

        Column(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(bottom = 48.dp, start = 32.dp, end = 32.dp)
                .fillMaxWidth(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // This can be replaced with a determinate progress bar if you have actual loading progress
            Box(modifier = Modifier.fillMaxWidth().height(10.dp).background(Primary.copy(alpha = 0.2f), shape = MaterialTheme.shapes.extraLarge)) {
                Box(modifier = Modifier.fillMaxWidth(0.75f).height(10.dp).background(Primary, shape = MaterialTheme.shapes.extraLarge))
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Connecting you to help...",
                fontSize = 14.sp,
                color = Color.Gray
            )
        }
    }
}
