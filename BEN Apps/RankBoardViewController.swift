//
//  RankBoardViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 4/26/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class RankBoardViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(RankBoardViewController.refresh), for: UIControlEvents.valueChanged)
        
        loadData()
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
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/rankboard.php", method: .post, parameters:params).response { response in
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
            if(!reachedEndOfItems) {
                self.loadData()
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(jsonArr.count==0){
            var messageLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
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
        let identifier = "RankBoardCell"
        var cell: RankBoardCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RankBoardCell
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RankBoardCell
        }
        cell.nameTV.text = jsonArr[indexPath.row]["namalengkap"].string!
        cell.pointTV.text = jsonArr[indexPath.row]["total_point"].string! + " Point"
        cell.rankTV.text = jsonArr[indexPath.row]["rank"].string!
        
        if(jsonArr[indexPath.row]["userimage"].string! != "" )
        {
            cell.profpicIV.imageFromUrl(urlString: jsonArr[indexPath.row]["userimage"].string!)
            
        }else {
            cell.profpicIV.image = #imageLiteral(resourceName: "ic_default_pp")
        }
        
        
        cell.profpicIV.layer.cornerRadius = 25.0
        cell.profpicIV.layer.masksToBounds = true
        
        if(jsonArr[indexPath.row]["badge_id"].string! == "" ){
            cell.badgeIV.image = #imageLiteral(resourceName: "ic_newbie")
        }else if(jsonArr[indexPath.row]["badge_id"].string! == "0"){
            cell.badgeIV.image = #imageLiteral(resourceName: "ic_newbie")
        }else if(jsonArr[indexPath.row]["badge_id"].string! == "1"){
            cell.badgeIV.image = #imageLiteral(resourceName: "ic_raiser")
        }else if(jsonArr[indexPath.row]["badge_id"].string! == "2"){
            cell.badgeIV.image = #imageLiteral(resourceName: "ic_energizer")
        }else if(jsonArr[indexPath.row]["badge_id"].string! == "3"){
            cell.badgeIV.image = #imageLiteral(resourceName: "ic_patriot")
        }
        return cell
    }
}
