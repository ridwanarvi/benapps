//
//  MyPagerTabStripName.swift
//  BEN Apps
//
//  Created by Vesperia on 4/3/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import SideMenu


class HomeTabController: ButtonBarPagerTabStripViewController {

    override open func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [BenTalkViewController(), NewsViewController(),TellUsViewController()]
    }
    
    
    
    let redColor = UIColor(red: 218/255.0, green: 37/255.0, blue: 28/255.0, alpha: 1.0)
    let grayTextColor = UIColor(red: 88/255.0, green: 89/255.0, blue: 91/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        // change selected bar color
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = redColor
        settings.style.buttonBarItemTitleColor = grayTextColor
        settings.style.buttonBarItemFont =  UIFont.systemFont(ofSize: 14.0)
        settings.style.selectedBarHeight = 4.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        setupSideMenu()

        super.viewDidLoad()
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuPresentMode = .viewSlideOut
        
        // Set up a cool background image for demo purposes
        
        //SideMenuManager.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    

}
