//
//  LoginRegisterController.swift
//  BEN Apps
//
//  Created by Vesperia on 3/20/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class LoginRegisterController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var forgotPassTV: TextViewClickable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.borderColor = UIColor.white.cgColor
        signupBtn.layer.borderWidth = 1.0
        
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterController.showForgotPass))
        forgotPassTV.addGestureRecognizer(tapOutTextField)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        let username = usernameTF.text
        let password = passwordTF.text
        if((username ?? "").isEmpty || (password ?? "").isEmpty ){
            showValidationAlert(message: "Please complete all fields", title: "Warning")
        }else{
            let params = ["username": "\(username)","password":"\(password)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/login.php", method: .post, parameters:params).response { response in
                let json = JSON(data:response.data!)
                self.showValidationAlert(message: json["msg"].string!, title: "Login")
            }
        }
        
    }
   
    func showForgotPass(){
        let alert = UIAlertView()
        alert.delegate=self
        alert.title = "Enter your email adress"
        alert.addButton(withTitle: "Submit")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.addButton(withTitle: "Cancel")
        let textField = alert.textField(at: 0)
        textField!.placeholder = "Enter your email adress"
        alert.show()
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex==0 {
            let textField:UITextField = alertView.textField(at: 0)!
            print(textField.text!)
            let params = ["email": "\(textField.text!)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/forgot-password.php", method: .post, parameters:params).response { response in
                let json = JSON(data:response.data!)
                
                self.showValidationAlert(message: json["msg"].string!, title: "Forgot Password")
            }
        }
    }
    
    func showValidationAlert(message: String, title: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
