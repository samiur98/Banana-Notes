//
//  UserRegistrator.swift
//  Banana Notes
//
//  Created by Shah Samiur Rahman on 3/26/20.
//  Copyright © 2020 Shah Samiur Rahman. All rights reserved.
//

import Foundation

protocol UserRegistrator{
    //Protocol to be implented by classes that provide functionality for registering new users.
    func registerUser(email: String, password: String) -> Bool;
}
