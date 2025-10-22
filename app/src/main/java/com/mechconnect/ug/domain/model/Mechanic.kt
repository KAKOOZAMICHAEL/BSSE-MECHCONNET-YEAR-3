
package com.mechconnect.ug.domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Mechanic(
    val name: String = "",
    val rating: Double = 0.0,
    val distance: Int = 0,
    val imageUrl: String = ""
)
