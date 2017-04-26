//
//  TellUsViewController.swift
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

class TellUsViewController: UITableViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Tell Us", image:  #imageLiteral(resourceName: "ic_report_gray"))
    }
}
