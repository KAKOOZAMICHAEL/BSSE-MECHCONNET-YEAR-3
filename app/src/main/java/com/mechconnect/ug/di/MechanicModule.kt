
package com.mechconnect.ug.di

import com.mechconnect.ug.data.repository.MechanicRepositoryImpl
import com.mechconnect.ug.domain.repository.MechanicRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent

@Module
@InstallIn(ViewModelComponent::class)
abstract class MechanicModule {

    @Binds
    abstract fun bindMechanicRepository(impl: MechanicRepositoryImpl): MechanicRepository
}
