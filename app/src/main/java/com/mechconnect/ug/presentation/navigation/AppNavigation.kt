
package com.mechconnect.ug.presentation.navigation

import androidx.compose.animation.ExperimentalAnimationApi
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.navArgument
import com.google.accompanist.navigation.animation.AnimatedNavHost
import com.google.accompanist.navigation.animation.composable
import com.google.accompanist.navigation.animation.rememberAnimatedNavController
import com.mechconnect.ug.presentation.screens.splash.SplashScreen
import com.mechconnect.ug.presentation.screens.onboarding.OnboardingScreen
import com.mechconnect.ug.presentation.screens.login.LoginScreen
import com.mechconnect.ug.presentation.screens.map.MapScreen
import com.mechconnect.ug.presentation.screens.find_mechanic.FindMechanicScreen
import com.mechconnect.ug.presentation.screens.confirm_booking.ConfirmBookingScreen
import com.mechconnect.ug.presentation.screens.payment.PaymentScreen
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.mechconnect.ug.presentation.screens.history.HistoryScreen
import com.mechconnect.ug.presentation.screens.profile.ProfileScreen
import com.mechconnect.ug.presentation.screens.settings.SettingsScreen

@OptIn(ExperimentalAnimationApi::class)
@Composable
fun AppNavigation(googleSignInClient: GoogleSignInClient) {
    val navController = rememberAnimatedNavController()
    AnimatedNavHost(navController = navController, startDestination = Screen.Splash.route) {
        val enterTransition = fadeIn(animationSpec = tween(durationMillis = 300))
        val exitTransition = fadeOut(animationSpec = tween(durationMillis = 300))

        composable(
            Screen.Splash.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            SplashScreen(navController = navController)
        }
        composable(
            Screen.Onboarding.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            OnboardingScreen(navController = navController)
        }
        composable(
            Screen.Login.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            LoginScreen(navController = navController, googleSignInClient = googleSignInClient)
        }
        composable(
            Screen.Map.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            MapScreen(navController = navController)
        }
        composable(
            Screen.FindMechanic.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            FindMechanicScreen(navController = navController)
        }
        composable(
            route = Screen.ConfirmBooking.route + "/{mechanicId}",
            arguments = listOf(navArgument("mechanicId") { type = NavType.StringType }),
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            ConfirmBookingScreen(navController = navController)
        }
        composable(
            Screen.Payment.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            PaymentScreen(navController = navController)
        }
        composable(
            Screen.Profile.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            ProfileScreen()
        }
        composable(
            Screen.History.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            HistoryScreen()
        }
        composable(
            Screen.Settings.route,
            enterTransition = { enterTransition },
            exitTransition = { exitTransition },
        ) {
            SettingsScreen()
        }
    }
}
