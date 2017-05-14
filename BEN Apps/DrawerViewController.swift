//
//  DrawerViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 4/17/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import Alamofire
import SwiftyJSON


class DrawerViewController: UITableViewController{
    @IBOutlet weak var nameTV: UITextView!
    @IBOutlet weak var profImgView: UIImageView!
    @IBOutlet weak var emailTV: UITextView!

    
    override func viewDidLoad() {
        let preferences = UserDefaults.standard
        let userimage = preferences.string(forKey: "userimage")!

        if(userimage != "" )
        {
            profImgView.imageFromUrl(urlString: userimage)
            
            
        }else {
            profImgView.image = #imageLiteral(resourceName: "ic_default_pp")
        }
        
        profImgView.layer.cornerRadius = 25.0
        profImgView.layer.masksToBounds = true

        nameTV.text = preferences.string(forKey: "name")!
        emailTV.text = preferences.string(forKey: "email")!

    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "howtouse"){
            let vc = segue.destination
            (vc as! HowToViewController).fromDrawer = true
        }
    }
    @IBAction func logOut(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            self.showProgressDialog()
            let preferences = UserDefaults.standard
            let auth_token = preferences.string(forKey: "auth_token")!
            let params = ["auth_token": "\(auth_token)","gcm_id":""]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/logout.php", method: .post, parameters:params).response { response in
                self.closeProgressDialog()
                let json = JSON(data:response.data!)
                if(json["status"].string! == "OK"){
                    self.dismiss(animated: false, completion: nil)
                    if let bundle = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundle)
                    }
                    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    
                }else{
                    self.dismiss(animated: false, completion: nil)
                    if let bundle = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundle)
                    }
                    self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        }
    

}
