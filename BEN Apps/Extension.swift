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
import SideMenu
import BFRImageViewer

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        self.image = nil
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
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func showValidationAlert(_ message: String, title: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentBFR(urlString: String){
        showProgressDialog()
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest.init(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse!, data: Data!, error: Error!) -> Void in
                if let dataImg = data {
                    if let image = UIImage(data: dataImg as Data){
                        self.closeProgressDialog()
                        let imageVC = BFRImageViewController(imageSource: [image])
                        self.present(imageVC!, animated: true, completion: nil)

                    }
                }
                
            }
        }
    }
       func timeAgoSinceDate(date:Date, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let now = NSDate()
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now as Date, options: [])
        
        if (components.year! >= 1){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else if (components.month! >= 1){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else if (components.weekOfYear! >= 1){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        } else if (components.day! >= 2) {
            return "\(components.day!)" + " days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)" + " hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)" + " minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)" + " seconds ago"
        } else {
            return "Just now"
        }
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
    
    public func initNavigationBar(){
        navigationItem.titleView = UINib(nibName: "NavigationBarCustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white"), style: .plain, target: navigationItem.leftBarButtonItem, action: #selector(UIViewController.showSideMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_notif_white"), style: .plain, target: navigationItem.rightBarButtonItem, action: #selector(UIViewController.showNotif(sender:)))
        

    }
    
    func showSideMenu(sender:AnyObject) {
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    func showNotif(sender:AnyObject) {
        
    }

}

