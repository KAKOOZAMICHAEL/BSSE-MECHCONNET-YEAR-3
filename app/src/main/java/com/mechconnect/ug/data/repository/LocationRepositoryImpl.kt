
package com.mechconnect.ug.data.repository

import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.os.Looper
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.Priority
import com.mechconnect.ug.domain.repository.LocationRepository
import com.mechconnect.ug.domain.utils.Resource
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class LocationRepositoryImpl @Inject constructor(
    @ApplicationContext private val context: Context,
    private val fusedLocationProviderClient: FusedLocationProviderClient
) : LocationRepository {

    @SuppressLint("MissingPermission")
    override fun getCurrentLocation(): Flow<Resource<Location>> = callbackFlow {
        trySend(Resource.Loading)

        val locationRequest = LocationRequest.Builder(
            Priority.PRIORITY_HIGH_ACCURACY, 10000L
        ).build()

        val locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                locationResult.lastLocation?.let {
                    trySend(Resource.Success(it))
                }
            }
        }

        fusedLocationProviderClient.requestLocationUpdates(
            locationRequest,
            locationCallback,
            Looper.getMainLooper()
        )

        awaitClose { fusedLocationProviderClient.removeLocationUpdates(locationCallback) }
    }
}
