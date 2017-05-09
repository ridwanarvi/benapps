//
//  HotTopicFrontTableViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 5/8/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit

class HotTopicFrontTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height =   UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height
        return ((tableView.bounds.size.height - height)/4)
    }
}
