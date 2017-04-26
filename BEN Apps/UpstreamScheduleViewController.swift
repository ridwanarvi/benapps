//
//  UpstreamScheduleViewController.swift
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
import PDFReader

class UpstreamScheduleViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(NewsViewController.refresh), for: UIControlEvents.valueChanged)
        
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
        Alamofire.request("http://cms.pertamina.benapps.id/graph/content/download-file.php", method: .post, parameters:params).response { response in
            self.closeProgressDialog()
            let json = JSON(data:response.data!)
            if(json["status"].string! == "OK"){
                self.jsonArr += json["data"].array!
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }else{
                self.showValidationAlert(json["msg"].string!, title: "Upstream Schedule")
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func downloadAndDisplayPDF(url: String, title: String ) {
        let remotePDFDocumentURL = URL(string: url)!

        let data = NSData.init(contentsOf: remotePDFDocumentURL)!
        
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        do {
            let documentsFolder = cachesDirectory.appendingPathComponent("documents")
            try FileManager.default.createDirectory(at: documentsFolder, withIntermediateDirectories: true, attributes: nil)
            
            let tempFileURL = documentsFolder.appendingPathComponent("example").appendingPathExtension("pdf")
            try data.write(to: tempFileURL, options: .atomicWrite)
            let document = PDFDocument(url: tempFileURL)
            if ( document != nil){
                let readerController = PDFViewController.createNew(with: document!, title: title)
                readerController.scrollDirection = .vertical
                self.closeProgressDialog()
                self.navigationController?.pushViewController(readerController, animated: true)

                
            }else{
                self.closeProgressDialog()
                self.showValidationAlert("Load PDF Failed", title: "Upstream Schedule")
            }
            
            
        } catch {
            self.closeProgressDialog()
            self.showValidationAlert("Load PDF Failed", title: "Upstream Schedule")
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showProgressDialog()
        
        DispatchQueue.main.async() {
            self.downloadAndDisplayPDF(url: self.jsonArr[indexPath.row]["file_url"].string!, title: self.jsonArr[indexPath.row]["title"].string!)
        }
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
        let identifier = "upstreamScheduleCell"
        var cell: UpstreamScheduleCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? UpstreamScheduleCell
        if cell == nil {
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? UpstreamScheduleCell
        }
        cell.titleTV.text = jsonArr[indexPath.row]["title"].string!

        
        return cell
    }
}
