
package com.mechconnect.ug.domain.repository

import android.location.Location
import com.mechconnect.ug.domain.utils.Resource
import kotlinx.coroutines.flow.Flow

interface LocationRepository {
    fun getCurrentLocation(): Flow<Resource<Location>>
}
