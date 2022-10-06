//
//  UserStateViewModel.swift
//  YZBox
//
//  Created by Apple on 10/7/22.
//

import Foundation

enum UserStateError: Error{
    case signInError, signOutError
}

@MainActor
class UserStateViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var isSessionWorking = false
    
//    func signIn(email: String, password: String) async -> Result<Bool, UserStateError>  {
//        isBusy = true
//        do{
//            try await Task.sleep(nanoseconds:  1_000_000_000)
//            isLoggedIn = true
//            isBusy = false
//            return .success(true)
//        }catch{
//            isBusy = false
//            return .failure(.signInError)
//        }
//    }
//
//    func signOut() async -> Result<Bool, UserStateError>  {
//        isBusy = true
//        do{
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//            isLoggedIn = false
//            isBusy = false
//            return .success(true)
//        }catch{
//            isBusy = false
//            return .failure(.signOutError)
//        }
//    }
}
