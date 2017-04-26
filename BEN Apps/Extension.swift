//
//  Extension.swift
//  BEN Apps
//
//  Created by Vesperia on 4/4/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest.init(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse!, data: Data!, error: Error!) -> Void in
                if let dataImg = data {
                    if let image = UIImage(data: dataImg as Data){
                        self.image = image
                    }
                }
                
            }
        }
    }
    
}

extension UIViewController{
    public func showValidationAlert(_ message: String, title: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showProgressDialog(){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    public func showProgressDialog(completion: () -> Void){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        completion()
    }
    
    public func closeProgressDialog(){
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
}

