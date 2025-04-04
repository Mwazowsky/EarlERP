//
//  AuthSceneDIContainer.swift
//  ExampleMVVM
//
//  Created by MacBook Air MII  on 19/03/25.
//

import Foundation
import UIKit
import SwiftUI

final class AccountSceneDIContainer {
    struct Dependencies {
        let newApiDataTransferervice: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // Replace: Replace with a proper keychain storage to store user login response data
    lazy var moviesQueriesStorage: MoviesQueriesStorage  = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache : MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repositories
    private func makeAuthRepository() -> IAuthRepository {
        return DefaultAuthRepository(
            dataTransferService: dependencies.newApiDataTransferervice
        )
    }
    
    private func makeUserRepository() -> IKeychainRepository {
        return DefaultKeychainRepository()
    }
    
    // MARK: - Use Cases
    func makeLogoutUseCase() -> LogoutUseCase {
        return DefaultLogoutUseCase(authRepository: makeAuthRepository(), keychainRepository: makeUserRepository())
    }
    
    /// User Data Save
    func makeDeleteCurrentUserUseCase() -> DeleteUserUseCase {
        return DefaultDeleteUserUseCase(keychainRepository: makeUserRepository())
    }
    
    // MARK: - View Models
    func makeAccountViewModel(actions: AccountViewModelActions) -> AccountViewModel {
        return DefaultAccountViewModel(
            logoutUseCase: makeLogoutUseCase(),
            actions: actions
        )
    }
    
//    func makeRegisterViewModel(actions: RegisterViewModelActions) -> RegisterViewModel {
//        return DefaultRegisterViewModel(
//            registerUseCase: makeRegisterUseCase(),
//            actions: actions
//        )
//    }
//    
//    func makeResetPasswordViewModel(actions: ResetPasswordViewModelActions) -> ResetPasswordViewModel {
//        return DefaultResetPasswordViewModel(
//            resetPasswordUseCase: makeResetPasswordUseCase(),
//            actions: actions
//        )
//    }
    
    // MARK: - View Controllers
    func makeAccountViewController(actions: AccountViewModelActions) -> AccountVC {
        return AccountVC.create(
            with: makeAccountViewModel(actions: actions)
        )
    }
    
//    func makeRegisterViewController(actions: RegisterViewModelActions) -> RegisterViewController {
//        return RegisterViewController.create(
//            with: makeRegisterViewModel(actions: actions)
//        )
//    }
//    
//    func makeResetPasswordViewController(actions: ResetPasswordViewModelActions) -> ResetPasswordViewController {
//        return ResetPasswordViewController.create(
//            with: makeResetPasswordViewModel(actions: actions)
//        )
//    }
    
    // MARK: - Flow Coordinator
    func makeAccountFlowCoordinator(
        navigationController: UINavigationController,
        delegate: AccountFlowCoordinatorDelegate? = nil
    ) -> AccountFlowCoordinator {
        return AccountFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            delegate: delegate
        )
    }
}

extension AccountSceneDIContainer: AccountFlowCoordinatorDependencies {}
