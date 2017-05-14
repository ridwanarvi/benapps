//
//  NewsCell.swift
//  BEN Apps
//
//  Created by Vesperia on 5/14/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit
class NewsCell: UITableViewCell {
    @IBOutlet weak var dateTV: UITextView!
    @IBOutlet weak var titleTV: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
}
class NewsHeaderCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleTV: UITextView!
    
}
