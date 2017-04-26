//
//  RegisterViewController.swift
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

class RegisterViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var emailTF: TextField!
    @IBOutlet weak var usernameTF: TextField!
    @IBOutlet weak var nameTF: TextField!
    @IBOutlet weak var phoneTF: TextField!
    @IBOutlet weak var birthdayTF: TextField!
    @IBOutlet weak var genderTF: TextField!
    @IBOutlet weak var companyTF: TextField!
    @IBOutlet weak var departmentTF: TextField!
    @IBOutlet weak var titleTF: TextField!
    @IBOutlet weak var nopekTF: TextField!
    @IBOutlet weak var passwordTF: TextField!
    @IBOutlet weak var confpasswordTF: TextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var hud: MBProgressHUD = MBProgressHUD()

    @IBOutlet weak var closeButton: UIButton!
    @IBAction func createAccount(_ sender: UIButton) {
    
        let email = emailTF.text!
        let username = usernameTF.text!
        let name = nameTF.text!
        let phone = phoneTF.text!
        let company = companyTF.text!
        let department = departmentTF.text!
        let title = titleTF.text!
        let nopek = nopekTF.text!
        let password = passwordTF.text!
        let confPassword = confpasswordTF.text!
        let birthday = birthdayTF.text!
        if(email.isEmpty
            || username.isEmpty
            || name.isEmpty
            || phone.isEmpty
            || company.isEmpty
            || department.isEmpty
            || title.isEmpty
            || nopek.isEmpty
            || password.isEmpty
            || confPassword.isEmpty
            || birthday.isEmpty
            ){
            showValidationAlert("Please complete all fields", title: "Warning")
        }else if(password != confPassword){
            showValidationAlert("Your password and your confimation password is different", title: "Warning")

        }else{
            //success
            let params = ["username": "\(username)",
                "name":"\(name)",
                "perusahaan":"\(company)",
                "jabatan":"\(title)",
                "departemen":"\(department)",
                "birthday":"\(birthday)",
                "phone":"\(phone)",
                "nopek":"\(nopek)",
                "gender":"\(gender)",
                "password":"\(password)",
                "email":"\(email+"@pertamina.com")"
            ]
            print(params["phone"]!)
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            showProgressDialog()
            //name, username, password, email, perusahaan, departemen, jabatan, birthday, phone, nopek, gender, gcm_id
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/register.php", method: .post, parameters:params).response { response in
                self.closeProgressDialog()
                let json = JSON(data:response.data!)
                if(json["status"]=="KO"){
                    self.showValidationAlert(json["msg"].string!, title: "Register Failed")
                }else{
                    let alert = UIAlertController(title: "Thanks for registering on Ben Apps", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alerta) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            
            }

            
            
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var pickOption = ["Male", "Female"]
    var gender = "0"
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = pickOption[row]
        gender = String(row+1)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.borderWidth = 1.0
        
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        birthdayTF.inputView=datePickerView
        datePickerView.addTarget(self, action: #selector(RegisterViewController.handleDatePicker), for: UIControlEvents.valueChanged)

        let genderPickerView : UIPickerView = UIPickerView()
        genderPickerView.delegate = self
        genderTF.inputView = genderPickerView
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        birthdayTF.text = dateFormatter.string(from: sender.date)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
