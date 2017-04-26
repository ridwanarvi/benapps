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
    @IBAction func goToHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}
