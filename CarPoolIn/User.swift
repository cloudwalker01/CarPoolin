//
//  User.swift
//  CarPoolIn
//
//  Created by Arnav Agarwal on 21/11/23.
//

import Foundation

class User
{
    let firstName: String
    let lastName: String
    let email: String
    let sex: String
    let phoneNumber: String
    let age: Int64
    
    init(firstName: String, lastName: String, email: String, sex: String, phoneNumber: String, age: Int64) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.sex = sex
        self.phoneNumber = phoneNumber
        self.age = age
    }
}
