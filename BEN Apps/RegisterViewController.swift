//
//  RegisterViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 3/20/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate {
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

    @IBAction func createAccount(_ sender: UIButton) {
    
        let email = emailTF.text
        let username = usernameTF.text
        let name = nameTF.text
        let phone = phoneTF.text
        let company = companyTF.text
        let department = departmentTF.text
        let title = titleTF.text
        let nopek = nopekTF.text
        let password = passwordTF.text
        let confPassword = confpasswordTF.text
        
    
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        let point = textField.frame.origin
        scrollView.setContentOffset(CGPoint(x:0.0, y:point.y-48.0), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showAlert(string: String) {
        let alertController = UIAlertController(title: "Warning", message: string, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
}
