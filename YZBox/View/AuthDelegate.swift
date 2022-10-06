//
//  AuthDelegate.swift
//  YZBox
//
//  Created by Apple on 10/6/22.
//

import Foundation
import Parse

class AuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func restoreAuthenticationWithAuthData(authData: [String : String]?) -> Bool {
        return true
    }
}
