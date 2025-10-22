
package com.mechconnect.ug.data.repository

import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import com.mechconnect.ug.domain.repository.MechanicRepository
import com.mechconnect.ug.presentation.screens.find_mechanic.Mechanic
import com.mechconnect.ug.domain.utils.Resource
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class MechanicRepositoryImpl @Inject constructor(
    private val firebaseDatabase: FirebaseDatabase
) : MechanicRepository {

    override fun getMechanics(): Flow<Resource<List<Mechanic>>> = callbackFlow {
        trySend(Resource.Loading)

        val mechanicRef = firebaseDatabase.getReference("mechanics")

        val valueEventListener = object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val mechanics = snapshot.children.mapNotNull {
                    it.getValue(Mechanic::class.java)
                }
                trySend(Resource.Success(mechanics))
            }

            override fun onCancelled(error: DatabaseError) {
                trySend(Resource.Error(error.message))
            }
        }

        mechanicRef.addValueEventListener(valueEventListener)

        awaitClose { mechanicRef.removeEventListener(valueEventListener) }
    }
}
