
package com.mechconnect.ug.di

import com.mechconnect.ug.data.repository.LocationRepositoryImpl
import com.mechconnect.ug.domain.repository.LocationRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent

@Module
@InstallIn(ViewModelComponent::class)
abstract class LocationModule {

    @Binds
abstract fun bindLocationRepository(impl: LocationRepositoryImpl): LocationRepository
}
