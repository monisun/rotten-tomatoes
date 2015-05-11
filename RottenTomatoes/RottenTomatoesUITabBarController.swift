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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
//        tabBar.selectedItem..in
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
