package com.mechconnect.ug.presentation.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.mechconnect.ug.R

val SpaceGrotesk = FontFamily(
    Font(R.font.spacegrotesk_regular),
    Font(R.font.spacegrotesk_medium, FontWeight.Medium),
    Font(R.font.spacegrotesk_bold, FontWeight.Bold)
)

val Inter = FontFamily(
    Font(R.font.inter_regular),
    Font(R.font.inter_medium, FontWeight.Medium),
    Font(R.font.inter_semibold, FontWeight.SemiBold),
    Font(R.font.inter_bold, FontWeight.Bold)
)


// Set of Material typography styles to start with
val Typography = Typography(
    bodyLarge = TextStyle(
        fontFamily = SpaceGrotesk,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
        lineHeight = 24.sp,
        letterSpacing = 0.5.sp
    )
)