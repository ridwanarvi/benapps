//
//  HowToViewController.swift
//  BEN Apps
//
//  Created by Vesperia on 5/10/17.
//  Copyright © 2017 Vesperia. All rights reserved.
//

import Foundation
import UIKit

class HowToViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var container: UIView!
    var pages = [UIViewController]()
    var fromDrawer = false
    @IBOutlet weak var redBtn: UIButton!
    var pageController: UIPageViewController!

    @IBOutlet weak var pageIndicator: UIPageControl!
    var index : Int = 0
    private var pendingIndex: Int?

    @IBAction func redBtnClicked(_ sender: Any) {
        if(index==pages.count-1 && !fromDrawer){
            navigationController?.dismiss(animated: true, completion: nil)
        }else if (index != pages.count-1 ){
            pageController.setViewControllers( [pages[abs((index + 1) % pages.count)]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            index += 1
            updateButtonandIndicator()
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func updateButtonandIndicator(){
        self.pageIndicator.currentPage = index
        pageIndicator.updateCurrentPageDisplay()
        
        
        if(index == pages.count-1){
            redBtn.setTitle("LET'S START", for: UIControlState.normal)
            redBtn.titleLabel?.sizeToFit()
        }else{
            redBtn.setTitle("NEXT", for: UIControlState.normal)
            redBtn.titleLabel?.sizeToFit()
            
        }

    }

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed){
            index = pendingIndex!
            updateButtonandIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(fromDrawer) {
            initNavigationBar()
        }
       
        pageIndicator.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)

        
        pages = [UIViewController]()
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page1")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page2")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page3")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page4")
        let page5: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page5")
        let page6: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page6")
        let page7: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "page7")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        pages.append(page6)
        pages.append(page7)

        for cvc in self.childViewControllers {
            if( cvc.isKind(of: UIPageViewController.classForCoder())){
                pageController = cvc as! UIPageViewController
            }
        }
        self.pageController.delegate = self
        self.pageController.dataSource = self
        self.pageIndicator.currentPage = index
        pageIndicator.updateCurrentPageDisplay()

        self.pageController.setViewControllers([page1] , direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

        
        }
    
    
    func pageChanged() {
        let pageNumber = pageIndicator.currentPage
        self.pageController.setViewControllers([pages[pageNumber-1]] , direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

       
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.destination.isKind(of: UIPageViewController.classForCoder()){
            self.pageController = segue.destination as! UIPageViewController
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex + 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (index == 0) {
            return nil;
        }
        
        index -= 1;
        
        return pages[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
