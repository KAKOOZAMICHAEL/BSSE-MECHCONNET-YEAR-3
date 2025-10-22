
package com.mechconnect.ug.presentation.screens.find_mechanic

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.mechconnect.ug.domain.model.Mechanic
import com.mechconnect.ug.domain.repository.MechanicRepository
import com.mechconnect.ug.domain.utils.Resource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class FindMechanicViewModel @Inject constructor(
    private val mechanicRepository: MechanicRepository
) : ViewModel() {

    private val _mechanics = MutableStateFlow<Resource<List<Mechanic>>>(Resource.Loading)
    val mechanics = _mechanics.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery = _searchQuery.asStateFlow()

    private val _selectedFilter = MutableStateFlow("Nearest")
    val selectedFilter = _selectedFilter.asStateFlow()

    init {
        getMechanics()
    }

    private fun getMechanics() {
        viewModelScope.launch {
            mechanicRepository.getMechanics().combine(_searchQuery) { mechanics, query ->
                if (mechanics is Resource.Success) {
                    val filteredList = mechanics.data.filter {
                        it.name.contains(query, ignoreCase = true)
                    }
                    Resource.Success(filteredList)
                } else {
                    mechanics
                }
            }.combine(_selectedFilter) { mechanics, filter ->
                if (mechanics is Resource.Success) {
                    val sortedList = when (filter) {
                        "Top-Rated" -> mechanics.data.sortedByDescending { it.rating }
                        "Cheapest" -> mechanics.data.sortedBy { it.distance } // Assuming distance is a proxy for cost
                        else -> mechanics.data.sortedBy { it.distance }
                    }
                    Resource.Success(sortedList)
                } else {
                    mechanics
                }
            }.collect {
                _mechanics.value = it
            }
        }
    }

    fun onSearchQueryChanged(query: String) {
        _searchQuery.value = query
    }

    fun onFilterChanged(filter: String) {
        _selectedFilter.value = filter
    }
}
