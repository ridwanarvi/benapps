//
//  File.swift
//  BEN Apps
//
//  Created by Vesperia on 3/20/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField{
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    /// Represents the next field. It can be any responder.
    /// If it is UIButton and enabled then the button will be tapped.
    /// If it is UIButton and disabled then the keyboard will be dismissed.
    /// If it is another implementation, it becomes first responder.
    @IBOutlet open weak var nextResponderField: UIResponder?
    
    /**
     Creates a new view with the passed coder.
     
     :param: aDecoder The a decoder
     
     :returns: the created new view.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    /**
     Creates a new view with the passed frame.
     
     :param: frame The frame
     
     :returns: the created new view.
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    /**
     Sets up the view.
     */
    private func setUp() {
        addTarget(self, action: #selector(actionKeyboardButtonTapped(sender:)), for: .editingDidEndOnExit)
    }
    
    /**
     Action keyboard button tapped.
     
     :param: sender The sender of the action parameter.
     */
    @objc private func actionKeyboardButtonTapped(sender: UITextField) {
        switch nextResponderField {
        case let button as UIButton where button.isEnabled:
            button.sendActions(for: .touchUpInside)
        case .some(let responder):
            responder.becomeFirstResponder()
        default:
            resignFirstResponder()
        }
    }
}
