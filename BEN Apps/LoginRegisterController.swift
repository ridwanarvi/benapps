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
import MBProgressHUD


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
        
        let preferences = UserDefaults.standard
        
        if preferences.object(forKey:"auth_token") == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier:  "HowToViewController")

            let navController = UINavigationController(rootViewController: vc as! HowToViewController)
            navController.navigationBar.barTintColor = UIColor(red: 218/255.0, green: 37/255.0, blue: 28/255.0, alpha: 1.00)
            navController.navigationBar.barStyle = UIBarStyle.black
            DispatchQueue.main.async() {
                [unowned self] in
                self.present(navController, animated: true, completion: nil)
            }
           
        } else {
            print(preferences.string(forKey:"auth_token")!)
            DispatchQueue.main.async() {
                [unowned self] in
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tapOutTextField: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginRegisterController.showForgotPass))
        forgotPassTV.addGestureRecognizer(tapOutTextField)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        let username = usernameTF.text!
        let password = passwordTF.text!
        if(username.isEmpty || password.isEmpty ){
            showValidationAlert("Please complete all fields", title: "Warning")
        }else{
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            showProgressDialog()
            
            let params = ["username": "\(username)","password":"\(password)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/login.php", method: .post, parameters:params).response { response in
                self.closeProgressDialog()
                let json = JSON(data:response.data!)
                if(json["status"].string! == "OK"){
                    
                    if let bundle = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundle)
                    }
                    let preferences = UserDefaults.standard
                    preferences.set(json["data"]["auth_token"].string!, forKey: "auth_token")
                    preferences.set(json["data"]["user_id"].string!, forKey: "user_id")
                    preferences.set(json["data"]["username"].string!, forKey: "username")
                    preferences.set(json["data"]["userimage"].string!, forKey: "userimage")
                    preferences.set(json["data"]["usercover"].string!, forKey: "usercover")
                    preferences.set(json["data"]["name"].string!, forKey: "name")
                    preferences.set(json["data"]["email"].string!, forKey: "email")
                    preferences.set(json["data"]["birthday"].string!, forKey: "birthday")
                    preferences.set(json["data"]["jabatan"].string!, forKey: "jabatan")
                    preferences.set(json["data"]["departemen"].string!, forKey: "departemen")
                    preferences.set(json["data"]["phone"].string!, forKey: "phone")
                    preferences.set(json["data"]["nopek"].string!, forKey: "nopek")
                    preferences.set(json["data"]["gender_type"].string!, forKey: "gender_type")
                    preferences.set(json["data"]["gender_name"].string!, forKey: "gender_name")
                    preferences.set(json["data"]["quote"].string!, forKey: "quote")
                    preferences.set(json["data"]["badge_id"].string!, forKey: "badge_id")
                    preferences.set(json["data"]["total_point"].string!, forKey: "total_point")
                    preferences.set(json["data"]["total_quiz"].string!, forKey: "total_quiz")
                    preferences.set(json["data"]["total_post"].string!, forKey: "total_post")
                    preferences.set(json["data"]["total_comment"].int!, forKey: "total_comment")
                    preferences.synchronize()


                    
                    self.showValidationAlert(json["msg"].string!, title: "Login")
                    DispatchQueue.main.async() {
                        [unowned self] in
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }


                }else{
                    self.showValidationAlert(json["msg"].string!, title: "Login Failed")
                }
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
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            showProgressDialog()
            let params = ["email": "\(textField.text!)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/forgot-password.php", method: .post, parameters:params).response { response in
                let json = JSON(data:response.data!)
                self.closeProgressDialog()
                self.showValidationAlert(json["msg"].string!, title: "Forgot Password")
            }
        }
    }
    
}
