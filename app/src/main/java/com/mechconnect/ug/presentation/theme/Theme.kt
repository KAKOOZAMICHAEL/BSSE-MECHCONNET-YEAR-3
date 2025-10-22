package com.mechconnect.ug.presentation.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColorScheme = darkColorScheme(
    primary = Primary,
    background = BackgroundDark,
    surface = BackgroundDark,
    onPrimary = Color.White,
    onBackground = TextDark,
    onSurface = TextDark,
)

private val LightColorScheme = lightColorScheme(
    primary = Primary,
    background = BackgroundLight,
    surface = BackgroundLight,
    onPrimary = Color.White,
    onBackground = TextLight,
    onSurface = TextLight
)

@Composable
fun MechConnectTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}