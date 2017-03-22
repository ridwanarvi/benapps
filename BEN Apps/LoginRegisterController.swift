//
//  LoginRegisterController.swift
//  BEN Apps
//
//  Created by Vesperia on 3/20/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit

class LoginRegisterController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.borderColor = UIColor.white.cgColor
        signupBtn.layer.borderWidth = 1.0
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
