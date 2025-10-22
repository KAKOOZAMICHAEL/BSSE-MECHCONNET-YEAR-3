
package com.mechconnect.ug.presentation.screens.map

import android.location.Location
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.mechconnect.ug.domain.repository.LocationRepository
import com.mechconnect.ug.domain.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MapViewModel @Inject constructor(
    private val locationRepository: LocationRepository
) : ViewModel() {

    private val _currentLocation = MutableStateFlow<Resource<Location>?>(null)
    val currentLocation = _currentLocation.asStateFlow()

    fun getCurrentLocation() {
        viewModelScope.launch {
            locationRepository.getCurrentLocation().collect {
                _currentLocation.value = it
            }
        }
    }
}
