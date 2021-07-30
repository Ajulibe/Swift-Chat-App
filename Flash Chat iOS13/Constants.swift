//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Akachukwu Ajulibe on 24/07/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation

struct K {
    //--> static changes properties from an instance property to a type property
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let toLoginSegue = "goToLogin"
    static let toRegisterSegue = "goToRegister"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
