//
//  BenTalkViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 4/3/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import XLPagerTabStrip

class BenTalkViewController: UITableViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Ben's Talk", image:#imageLiteral(resourceName: "ic_socmed_gray"))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(BenTalkViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.register(UINib(nibName: "BenTalkCell", bundle: nil), forCellReuseIdentifier: "BenTalkCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/talk.php", method: .post, parameters:params).response { response in
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "BenTalkCell"
        var cell: BenTalkCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BenTalkCell
        if cell == nil {
            tableView.register(UINib(nibName: "BenTalkCell", bundle: nil), forCellReuseIdentifier: "BenTalkCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BenTalkCell
        }
        
    
        if(jsonArr[indexPath.row]["socinfo_images"].string! != "" )
        {
            cell.imgView.imageFromUrl(urlString: jsonArr[indexPath.row]["socinfo_images"].string!)
            cell.imageHeight.constant = 200
            
        }else{
            cell.imageHeight.constant = 0

        }
        
        if(jsonArr[indexPath.row]["userimage"].string! != "" )
        {
            cell.userImgView.imageFromUrl(urlString: jsonArr[indexPath.row]["userimage"].string!)
            
        }else {
            cell.userImgView.image = #imageLiteral(resourceName: "ic_default_pp")
        }
        
        
        cell.userImgView.layer.cornerRadius = 20.0
        cell.userImgView.layer.masksToBounds = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
        let date = dateFormatter.date(from: jsonArr[indexPath.row]["date_created"].string!)
        
        cell.dateTV.text = timeAgoSinceDate(date:date!, numericDates: false)
        
        cell.dateTV.sizeToFit()

        cell.locationTV.text = ""
        if(jsonArr[indexPath.row]["place_name"].string! != "" )
        {
            if(jsonArr[indexPath.row]["place_verified"].string! == "true"){
                cell.checkinImgView.image = #imageLiteral(resourceName: "ic_checkin_validate")
            }else{
                cell.checkinImgView.image = #imageLiteral(resourceName: "ic_checkin_unvalidate")
            }
            
            cell.locationTV.text = "at " + jsonArr[indexPath.row]["place_name"].string!
            cell.locationTV.sizeToFit()

        }else{
            cell.checkinImgView.image = nil

        }
        cell.nameTV.text = jsonArr[indexPath.row]["name"].string!
        cell.nameTV.sizeToFit()

        cell.commentBtn.titleLabel?.text = jsonArr[indexPath.row]["num_comment"].string! + " Comments"
        cell.descriptionTV.text = jsonArr[indexPath.row]["socinfo_description"].string!
        
        
        
        cell.descriptionHeight.constant = 30
        let size = cell.descriptionTV.sizeThatFits(CGSize(width: cell.descriptionTV.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != cell.descriptionHeight.constant && size.height > cell.descriptionTV.frame.size.height{
            cell.descriptionHeight.constant = size.height
        }
        
        
        return cell
    }
    
        
}

