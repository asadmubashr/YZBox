//
//  User.swift
//  YZBox
//
//  Created by Apple on 10/5/22.
//

import Foundation


class User {
    var userId: String
    var email: String?
    var firstName: String?
    var lastName: String?
    
    init(userId: String, email: String?, firstName: String?, lastName: String?) {
        self.userId = userId
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
}
