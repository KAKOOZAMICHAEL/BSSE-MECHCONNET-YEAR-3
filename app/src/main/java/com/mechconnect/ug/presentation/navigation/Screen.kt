
package com.mechconnect.ug.presentation.navigation

sealed class Screen(val route: String) {
    object Splash : Screen("splash")
    object Onboarding : Screen("onboarding")
    object Login : Screen("login")
    object Map : Screen("map")
    object FindMechanic : Screen("find_mechanic")
    object ConfirmBooking : Screen("confirm_booking")
    object Payment : Screen("payment")
    object Profile : Screen("profile")
    object History : Screen("history")
    object Settings : Screen("settings")
}
