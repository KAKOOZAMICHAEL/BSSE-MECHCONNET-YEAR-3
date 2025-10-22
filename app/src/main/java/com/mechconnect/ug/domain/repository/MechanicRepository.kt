
package com.mechconnect.ug.domain.repository

import com.mechconnect.ug.presentation.screens.find_mechanic.Mechanic
import com.mechconnect.ug.domain.utils.Resource
import kotlinx.coroutines.flow.Flow

interface MechanicRepository {
    fun getMechanics(): Flow<Resource<List<Mechanic>>>
}
