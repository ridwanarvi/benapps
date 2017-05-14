//
//  NewsViewController.swift
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

class NewsViewController: UITableViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "News", image:#imageLiteral(resourceName: "ic_news_gray"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(NewsViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        
        loadData()
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        page = 1
        reachedEndOfItems = false
        jsonArr = []
        header = nil
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
    var header : JSON?
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==0){
            return 200.0
        }else{
        return UITableViewAutomaticDimension
        }
    }
    
    func loadData(){
        
        if(NetworkReachabilityManager()!.isReachable == false){
            self.showValidationAlert("No Internet Connection", title: "Failed")
            return
        }
        showProgressDialog()
        
        let preferences = UserDefaults.standard
        let auth_token = preferences.string(forKey: "auth_token")!
        let params = ["auth_token": "\(auth_token)","rpp":"\(rpp)","page":"\(page)"]
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/news.php", method: .post, parameters:params).response { response in
            self.closeProgressDialog()
            let json = JSON(data:response.data!)
            if(json["status"].string! == "OK"){
                self.jsonArr += json["data"].array!
                if (self.header == nil) {
                    self.header = json["header"]
                }
                
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
    
    
    
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(jsonArr.count==0 && header == nil){
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
        
        if(section == 0){
            return header == nil ? 0 : 1
        }else{
            return jsonArr.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NewsCell"
        let identifier2 = "NewsHeaderCell"

        if(indexPath.section == 0){
            var cell: NewsHeaderCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsHeaderCell
            if cell == nil {
                tableView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
                cell = tableView.dequeueReusableCell(withIdentifier: identifier2) as? NewsHeaderCell
            }
            
            
            
            cell.imgView.imageFromUrl(urlString: header!["image"].string!)
            cell.titleTV.text = header!["title"].string!
            
            return cell
        }else{
            var cell: NewsCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsCell
            if cell == nil {
                tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
                cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsCell
            }
            
            cell.imgView.imageFromUrl(urlString: jsonArr[indexPath.row]["image"].string!)
            cell.titleTV.text = jsonArr[indexPath.row]["title"].string!
            
            cell.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.00)
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
            let date = dateFormatter.date(from: jsonArr[indexPath.row]["date_created"].string!)
            
            cell.dateTV.text = timeAgoSinceDate(date:date!, numericDates: false)
            
            cell.dateTV.sizeToFit()
            
            
            cell.titleHeight.constant = 30
            let size = cell.titleTV.sizeThatFits(CGSize(width: cell.titleTV.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if size.height != cell.titleHeight.constant && size.height > cell.titleTV.frame.size.height{
                cell.titleHeight.constant = size.height
            }
            
            
            return cell
        }
        
    }
}
