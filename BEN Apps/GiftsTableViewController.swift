//
//  GiftsTableViewController.swift
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

class GiftsTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(GiftsTableViewController.refresh), for: UIControlEvents.valueChanged)
        initNavigationBar()
        loadData()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        

    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        page = 1
        reachedEndOfItems = false
        jsonArr = []
        //Alamofire.Manager.sharedInstance.session.invalidateAndCancel()
        
        loadData()
        
    }
    
    
    // number of items to be fetched each time (i.e., database LIMIT)
    let rpp = 10
    
    // Where to start fetching items (database OFFSET)
    var page = 1
    
    // a flag for when all database items have already been loaded
    var reachedEndOfItems = false
    
    
    var jsonArr :[JSON] = []
    
    func loadData(){
        
        if(NetworkReachabilityManager()!.isReachable == false){
            self.showValidationAlert("No Internet Connection", title: "Failed")
            return
        }
        showProgressDialog()
        
        let preferences = UserDefaults.standard
        let auth_token = preferences.string(forKey: "auth_token")!
        let params = ["auth_token": "\(auth_token)","rpp":"\(rpp)","page":"\(page)"]
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/gift.php", method: .post, parameters:params).response { response in
            self.closeProgressDialog()
            let json = JSON(data:response.data!)
            if(json["status"].string! == "OK"){
                self.jsonArr += json["data"].array!
                self.page += 1
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }else{
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.reachedEndOfItems = true
            }
        }
        
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            if(!(self.refreshControl?.isRefreshing)! && !reachedEndOfItems) {
                self.loadData()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        let identifier = "GiftCell"
        var cell: GiftCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? GiftCell
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? GiftCell
        }
        
        if(jsonArr[indexPath.row]["image"].string! != "" )
        {
            cell.imgView.imageFromUrl(urlString: jsonArr[indexPath.row]["image"].string!)
        }
        
        
        
        cell.nameTV.text = jsonArr[indexPath.row]["title"].string!
        
        cell.pointTV.text = jsonArr[indexPath.row]["point"].string! + " Point"
        
        if(jsonArr[indexPath.row]["is_booked"].string! == "true"){
            cell.pointTV.text = "booked"
            cell.pointTV.isHidden=false
            cell.redeemButton.isEnabled=false
            
        }else if(jsonArr[indexPath.row]["is_booked"].string! == "false"){
            if(jsonArr[indexPath.row]["is_redeemed"].string! == "true"){
                cell.bookTV.text = "redeemed"
                cell.bookTV.isHidden=false
                cell.redeemButton.isEnabled=true


                
            }else if (jsonArr[indexPath.row]["is_redeemed"].string! == "false"){
                cell.bookTV.isHidden=true
                cell.redeemButton.isEnabled=true

            }
        }else{
            cell.bookTV.isHidden = true
            cell.redeemButton.isEnabled=true

        }
        cell.redeemButton.tag = indexPath.row
        cell.redeemButton.addTarget(self, action: #selector(GiftsTableViewController.reedem), for: UIControlEvents.touchUpInside)
        
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
        let refreshAlert = UIAlertController(title: "Information", message: "Anda akan redeem point senilai \(jsonArr[sender.tag!]["point"].string!) point untuk \(jsonArr[sender.tag!]["title"].string!), apakah anda yakin?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if(NetworkReachabilityManager()!.isReachable == false){
                self.showValidationAlert("No Internet Connection", title: "Failed")
                return
            }
            self.showProgressDialog()
            let preferences = UserDefaults.standard
            let auth_token = preferences.string(forKey: "auth_token")!
            let params = ["auth_token": "\(auth_token)","gift_id":"\(self.jsonArr[sender.tag!]["gift_id"].string!)"]
            Alamofire.request("http://cms.pertamina.benapps.id/graph/user/gift.php", method: .post, parameters:params).response { response in
                self.closeProgressDialog()
                let json = JSON(data:response.data!)
                if(json["status"].string! == "OK"){
                   
                self.showValidationAlert("Anda telah redeem point senilai \(self.jsonArr[sender.tag!]["point"].string!) point untuk \(self.jsonArr[sender.tag!]["title"].string!), silahkan tunggu konfirmasi dari admin", title: "Redeem Successful")
                }else{
                self.showValidationAlert(json["msg"].string!, title: "Redeem Failed")

                    
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        

       
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
}
