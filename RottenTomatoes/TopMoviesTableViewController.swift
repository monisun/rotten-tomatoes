//
//  TopMoviesTableViewController.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/10/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import UIKit

class TopMoviesTableViewController: UITableViewController {
    
    var url = String()
    
    @IBOutlet weak var networkIndicatorLabel: UILabel!
    
    var movies = [Dictionary<String, AnyObject>]()
    let manager = AFHTTPRequestOperationManager()
    let responseSerializer = AFJSONResponseSerializer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Utility.startNetworkNotifier(self.networkIndicatorLabel)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as Set<NSObject>
        manager.responseSerializer = responseSerializer
        self.makeTopMoviesGetRequest(url)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl!, atIndex: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.height/5 // show 5 movies per screen
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieTVC", forIndexPath: indexPath) as! UITableViewCell
        let posterImageView = cell.contentView.viewWithTag(1) as! UIImageView
        posterImageView.contentMode = UIViewContentMode.ScaleAspectFit
        let info = cell.contentView.viewWithTag(2) as! UILabel

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
            
            let title = movieJSON["title"] as! String
            let year = movieJSON["year"] as! Int
            let runtime = movieJSON["runtime"] as! Int
            let mpaa_rating = movieJSON["mpaa_rating"] as! String
            
            info.text = title + "\nRating: \(mpaa_rating) (\(year), \(runtime) min)"
            // styling
            info.textAlignment = NSTextAlignment.Left
            info.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            info.textColor = UIColor.whiteColor()
            info.lineBreakMode = NSLineBreakMode.ByWordWrapping
            info.numberOfLines = 0
            //             cell.textLabel!.center.x = CGFloat(self.tableView.center.x)
            
        } else {
            NSLog("Unexpected: Could not load movie JSON for row: \(indexPath.row)")
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.showProgress(1, status: "Loading...")
        performSegueWithIdentifier("showMovieInfo", sender: tableView)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieInfo" {
            let movieInfoViewController = segue.destinationViewController as! MovieInfoViewController
            if let sender = sender as! UITableView? {
                if let selectedRowIndexPath = sender.indexPathForSelectedRow() as NSIndexPath? {
                    let moviesJSON = movies[selectedRowIndexPath.row] as Dictionary<String, AnyObject>
                    movieInfoViewController.movieJSON = moviesJSON
                    movieInfoViewController.title = moviesJSON["title"] as? String
                }
            }
        }
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
            tableView.reloadData()
        } else {
            NSLog("Unexpected: responseObj is nil or invalid JSON: \(responseObj)")
        }
    }
    
    func printError(error: NSError) {
        println("Error: \(error.localizedDescription)")
    }

    func onRefresh() {
        // query API for updated data and reload table
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObj: AnyObject!) in
                self.loadMoviesJSONArray(responseObj)
                self.refreshControl!.endRefreshing()
            },
            
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                NSLog("Error in onRefresh: \(error)")
            }
        )
    }
}
