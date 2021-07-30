//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //performing the looping operation using CLTypingLabel Module
        titleLabel.text = K.appName
        //Performing the looping operation manually
        //        titleLabel.text = ""
        //        let titleText = "⚡️FlashChat"
        //        var charIndex = 0
        //        for letter in titleText {
        //            print(letter)
        //            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex) , repeats: false) { timer in
        //                self.titleLabel.text?.append(letter)
        //            }
        //            charIndex += 1
        //        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier:K.toLoginSegue, sender: self)
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier:K.toRegisterSegue , sender: self)
    }
}
