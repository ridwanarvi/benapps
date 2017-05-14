//
//  DoorprizeViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 5/14/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import BFRImageViewer

class DoorprizeViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(DoorprizeViewController.refresh), for: UIControlEvents.valueChanged)
        initNavigationBar()
        loadData()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

    }
    
    func refresh(sender:AnyObject) {

        jsonArr = []
        //Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
        
        loadData()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    
    var jsonArr :[JSON] = []
    
    func loadData(){
        
        if(NetworkReachabilityManager()!.isReachable == false){
            self.showValidationAlert("No Internet Connection", title: "Failed")
            return
        }
        showProgressDialog()
        
        let preferences = UserDefaults.standard
        let auth_token = preferences.string(forKey: "auth_token")!
        let params = ["auth_token": "\(auth_token)"]
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/doorprize.php", method: .post, parameters:params).response { response in
            self.closeProgressDialog()
            let json = JSON(data:response.data!)
            if(json["status"].string! == "OK"){
                self.jsonArr = json["data"].array!
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }else{
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(jsonArr.count==0){
            let messageLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            messageLabel.text = "No data"
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.font = UIFont.systemFont(ofSize: 20)
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }else{
            self.tableView.backgroundView = nil
        }
        return jsonArr.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Dorrprize"
        var cell: DoorprizeCell! = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DoorprizeCell
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DoorprizeCell
        }
        
        if(jsonArr[indexPath.row]["image"].string! != "" )
        {
            cell.imgView.imageFromUrl(urlString: jsonArr[indexPath.row]["image"].string!)
        }
        
        
        
        cell.nameTV.text = jsonArr[indexPath.row]["title"].string!
        
        cell.pointTV.text = jsonArr[indexPath.row]["content"].string!
        
        if(jsonArr[indexPath.row]["is_status"].string! == "true"){
           cell.redeemButton.isEnabled=false
            cell.redeemButton.setTitle("JOINED", for: UIControlState.disabled)

        }else{
            cell.redeemButton.isEnabled=true
            cell.redeemButton.setTitle("JOIN", for: UIControlState.normal)
            
        }
        cell.redeemButton.tag = indexPath.row
        cell.redeemButton.addTarget(self, action: #selector(DoorprizeViewController.reedem), for: UIControlEvents.touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.imgView.isUserInteractionEnabled = true
        cell.imgView.addGestureRecognizer(tapGestureRecognizer)

        
        return cell
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if(tappedImage.image != nil){
            let imageVC = BFRImageViewController(imageSource: [tappedImage.image!])
            self.present(imageVC!, animated: true, completion: nil)
        }
        // Your action
    }

    
    func reedem(sender:AnyObject) {
        
        // Code to refresh table view
        let refreshAlert = UIAlertController(title: "Information", message: "Anda akan redeem point untuk mengikuti \(jsonArr[sender.tag!]["title"].string!), apakah anda yakin?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            self.showProgressDialog()
            let preferences = UserDefaults.standard
            let auth_token = preferences.string(forKey: "auth_token")!
            let params = ["auth_token": "\(auth_token)","doorprize_id":"\(self.jsonArr[sender.tag!]["doorprize_id"].string!)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/doorprize.php", method: .post, parameters:params).response { response in
                self.closeProgressDialog()
                let json = JSON(data:response.data!)
                if(json["status"].string! == "OK"){
                    
                    self.showValidationAlert(json["msg"].string!, title: "Redeem Successful")
                }else{
                    self.showValidationAlert(json["msg"].string!, title: "Redeem Failed")
                    
                    
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
        
        
        
    }
}
