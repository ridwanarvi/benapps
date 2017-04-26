//
//  QuizViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 4/18/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import XLPagerTabStrip

class QuizViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(NewsViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.register(UINib(nibName: "BenTalkCell", bundle: nil), forCellReuseIdentifier: "BenTalkCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        loadData()
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        jsonArr = []
        loadData()
        
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
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/quiz.php", method: .post, parameters:params).response { response in
            self.closeProgressDialog()
            let json = JSON(data:response.data!)
            if(json["status"].string! == "OK"){
                self.jsonArr += json["data"].array!
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }else{
                self.showValidationAlert(json["msg"].string!, title: "Quiz")

                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
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
        let identifier = "BenTalkCell"
        var cell: BenTalkCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BenTalkCell
        if cell == nil {
            tableView.register(UINib(nibName: "BenTalkCell", bundle: nil), forCellReuseIdentifier: "BenTalkCell")
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BenTalkCell
        }
        
        return cell
    }
}

