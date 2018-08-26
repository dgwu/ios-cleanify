//
//  Session.swift
//  Cleanify
//
//  Created by Firmansyah Putra on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

func getUserToken() -> String {
    return UserDefaults.standard.string(forKey: USER_TOKEN)!
}

func setUserToken(userToken: String) {
    return UserDefaults.standard.set(userToken, forKey: USER_TOKEN)
}

func setUserSession(user: [String : Any]) {
    UserDefaults.standard.set(user, forKey: USER_SESSION)
}

func getUserSession() -> [String : Any] {
    return UserDefaults.standard.dictionary(forKey: USER_SESSION)!
}
