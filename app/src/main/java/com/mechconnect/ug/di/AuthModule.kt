
package com.mechconnect.ug.di

import com.mechconnect.ug.data.repository.AuthRepositoryImpl
import com.mechconnect.ug.domain.repository.AuthRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent


@Module
@InstallIn(ViewModelComponent::class)

abstract class AuthModule {

    @Binds
abstract fun bindAuthRepository(impl: AuthRepositoryImpl): AuthRepository
}   
