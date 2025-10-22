
package com.mechconnect.ug.presentation.screens.confirm_booking

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.mechconnect.ug.domain.model.Mechanic
import com.mechconnect.ug.domain.repository.MechanicRepository
import com.mechconnect.ug.domain.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ConfirmBookingViewModel @Inject constructor(
    private val mechanicRepository: MechanicRepository,
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val _mechanic = MutableStateFlow<Resource<Mechanic>>(Resource.Loading)
    val mechanic = _mechanic.asStateFlow()

    private val mechanicId: String = checkNotNull(savedStateHandle["mechanicId"])

    init {
        getMechanic()
    }

    private fun getMechanic() {
        viewModelScope.launch {
            mechanicRepository.getMechanics().collect {
                if (it is Resource.Success) {
                    val mechanic = it.data.find { it.name == mechanicId } // Using name as ID for now
                    if (mechanic != null) {
                        _mechanic.value = Resource.Success(mechanic)
                    } else {
                        _mechanic.value = Resource.Error("Mechanic not found")
                    }
                } else if (it is Resource.Error) {
                    _mechanic.value = Resource.Error(it.message)
                }
            }
        }
    }
}
