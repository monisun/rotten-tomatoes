//
//  RottenTomatoesUITabBarController.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/10/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import UIKit

class RottenTomatoesUITabBarController: UITabBarController {
    
    let topMoviesStaticUrl = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    let topRentalsStaticUrl = "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json"
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var lastSelectedTabIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.selectedSegmentIndex = 0     // default to List View
        lastSelectedTabIndex = 0
        
        if let tabs = self.tabBar.items as! [UITabBarItem]? {
            tabs[0].image = UIImage(named: "movies")
            tabs[0].title = "Box Office"
            tabs[1].image = UIImage(named: "dvd")
            tabs[1].title = "DVD Rental"
        } else {
            NSLog("Error: tabs is nil!")
        }
        
        if let vcs = self.viewControllers as! [UITableViewController]? {
            var moviesVC:TopMoviesTableViewController = vcs[0] as! TopMoviesTableViewController
            moviesVC.url = topMoviesStaticUrl
            var rentalsVC:TopMoviesTableViewController = vcs[1] as! TopMoviesTableViewController
            rentalsVC.url = topRentalsStaticUrl
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let viewController = viewController as! TopMoviesTableViewController
        switch(tabBarController.selectedIndex) {
        case 0:
            viewController.url = topMoviesStaticUrl
        case 1:
            viewController.url = topRentalsStaticUrl
        default:
            NSLog("Unexpected tabBar selectedIndex: \(tabBarController.selectedIndex)!")
        }
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectItem: UITabBarItem) {
        lastSelectedTabIndex = tabBarController.selectedIndex
    }
    
    
    @IBAction func segmentControlValueChanged(sender: AnyObject) {
        let sender = sender as! UISegmentedControl
        let vcs = self.viewControllers as! [UIViewController]
        switch(sender.selectedSegmentIndex) {
        case 0: // TableView
            if lastSelectedTabIndex == 0 {
                performSegueWithIdentifier("tvSegue", sender: self)
            } else {
                performSegueWithIdentifier("tvSegue", sender: self)
            }
            
        case 1: // CollectionView
            if lastSelectedTabIndex == 0 {
                performSegueWithIdentifier("cvSegue", sender: self)
            } else {
                performSegueWithIdentifier("cvSegue", sender: self)
            }
        default:
            NSLog("Unexpected: segmentControl.selectedSegmentIndex: \(segmentControl.selectedSegmentIndex)")
        }
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cvSegue" {
            let rtCollectionViewController = segue.destinationViewController as! RTCollectionViewController
            if segmentControl.selectedSegmentIndex == 0 {
                rtCollectionViewController.url = topMoviesStaticUrl
            } else {
                rtCollectionViewController.url = topRentalsStaticUrl
            }
        }
        
        if segue.identifier == "tvSegue" {
            let tvController = segue.destinationViewController as! TopMoviesTableViewController
            if segmentControl.selectedSegmentIndex == 0 {
                tvController.url = topMoviesStaticUrl
            } else {
                tvController.url = topRentalsStaticUrl
            }
        }
    }

}
