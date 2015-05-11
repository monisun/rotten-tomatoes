//
//  RTCollectionViewController.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/11/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import UIKit

let reuseIdentifier = "movieCVC"

class RTCollectionViewController: UICollectionViewController {
    let topMoviesStaticUrl = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    
    var url = String()
    
    var movies = [Dictionary<String, AnyObject>]()
    let manager = AFHTTPRequestOperationManager()
    let responseSerializer = AFJSONResponseSerializer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = topMoviesStaticUrl
        
        collectionView?.delegate = self
        collectionView?.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        self.collectionView!.registerClass(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //        Utility.startNetworkNotifier(self.networkIndicatorLabel)
        
        responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
        manager.responseSerializer = responseSerializer
        self.makeTopMoviesGetRequest(url)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
            if segue.identifier == "showMovieInfoFromCV" {
                let movieInfoViewController = segue.destinationViewController as! MovieInfoViewController
                let moviesJSON = movies[indexPath.row] as Dictionary<String, AnyObject>
                movieInfoViewController.movieJSON = moviesJSON
                movieInfoViewController.title = moviesJSON["title"] as? String
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return movies.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let posterImageView = cell.imageView as UIImageView
        posterImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        let info = cell.contentView.viewWithTag(2) as! UILabel
        
        if let movieJSON = movies[indexPath.row] as Dictionary<String, AnyObject>? {
            let posters = movieJSON["posters"] as! Dictionary<String, AnyObject>
            let thumbnailUrl = posters["thumbnail"] as! String
            let thumbnailData = NSData(contentsOfURL: NSURL(string: thumbnailUrl)!)
            // async download hi-res image
            if let thumbnailImage = UIImage(data: thumbnailData!) as UIImage! {
                let hiResUrl: String = Utility.getHiResImageUrl(thumbnailUrl)
                posterImageView.setImageWithURL(NSURL(string: hiResUrl)!, placeholderImage: thumbnailImage)
            } else {
                NSLog("Unexpected: Unable to download thumbnail image from URL: \(thumbnailUrl)")
            }
            
//            let title = movieJSON["title"] as! String
//            let year = movieJSON["year"] as! Int
//            let runtime = movieJSON["runtime"] as! Int
//            let mpaa_rating = movieJSON["mpaa_rating"] as! String
            
//            info.text = title + "\nRating: \(mpaa_rating) (\(year), \(runtime) min)"
//            // styling
//            info.textAlignment = NSTextAlignment.Left
//            info.font = UIFont(name: "HelveticaNeue-Light", size: 16)
//            info.textColor = UIColor.whiteColor()
//            info.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            info.numberOfLines = 0
            //             cell.textLabel!.center.x = CGFloat(self.tableView.center.x)
            
        } else {
            NSLog("Unexpected: Could not load movie JSON for row: \(indexPath.row)")
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!,sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        var size = CGSize(width: 150, height: 150)
        return size
    }
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.showProgress(1, status: "Loading...")
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            performSegueWithIdentifier("showMovieInfoFromCV", sender: cell)
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    // AFNetworking helper functions
    func makeTopMoviesGetRequest(url: String) {
        SVProgressHUD.showProgress(1, status: "Loading...")
        
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                self.loadMoviesJSONArray(responseObj)
                SVProgressHUD.showSuccessWithStatus("Success")
            },
            
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.printError(error)
            }
        )
    }
    
    func loadMoviesJSONArray(responseObj: AnyObject) {
        if let moviesJSONArray = responseObj.objectForKey("movies") as? [Dictionary<String, AnyObject>] {
            movies = moviesJSONArray
            collectionView!.reloadData()
        } else {
            NSLog("Unexpected: responseObj is nil or invalid JSON: \(responseObj)")
        }
    }
    
    func printError(error: NSError) {
        println("Error: \(error.localizedDescription)")
    }
    
    
    
    
    
    
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
