//
//  BenTalkCell.swift
//  BEN Apps
//
//  Created by Vesperia on 4/4/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit

class BenTalkCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameTV: UITextView!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var dateTV: UITextView!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var locationTV: UITextView!
    @IBOutlet weak var checkinImgView: UIImageView!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
}
