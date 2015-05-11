//
//  MovieInfoViewController.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/8/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {
    
    var movieJSON = Dictionary<String, AnyObject>()
    
    @IBOutlet weak var networkIndicatorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var synopsisLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.dismiss()
        
        Utility.startNetworkNotifier(self.networkIndicatorLabel)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        let title = movieJSON["title"] as! String
        let posters = movieJSON["posters"] as! Dictionary<String, AnyObject>
        let thumbnailUrl = posters["thumbnail"] as! String
        let thumbnailData = NSData(contentsOfURL: NSURL(string: thumbnailUrl)!)
        // async download hi-res image
        if let thumbnailImage = UIImage(data: thumbnailData!) as UIImage! {
            let hiResUrl: String = Utility.getHiResImageUrl(thumbnailUrl)
            imageView.setImageWithURL(NSURL(string: hiResUrl)!, placeholderImage: thumbnailImage)
        } else {
            NSLog("Unexpected: Unable to download thumbnail image from URL: \(thumbnailUrl)")
        }
        
        let year = movieJSON["year"] as! Int
        let runtime = movieJSON["runtime"] as! Int
        let mpaa_rating = movieJSON["mpaa_rating"] as! String
        
        let ratings = movieJSON["ratings"] as! Dictionary<String, AnyObject>
        let audience_score = ratings["audience_score"] as! Int
        let critics_score = ratings["critics_score"] as! Int
        let synopsis = movieJSON["synopsis"] as! String
        
        titleLabel.text = title
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.numberOfLines = 0
        
        subtitleLabel.text = "Rating: \(mpaa_rating) (\(year), \(runtime) min)\nAudience Score: \(audience_score) Critics Score: \(critics_score)"
        subtitleLabel.textAlignment = NSTextAlignment.Center
        subtitleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        subtitleLabel.numberOfLines = 0
        
        synopsisLabel.frame = CGRectMake(0, 0, imageView.bounds.size.width-50, imageView.bounds.size.height/5)
        synopsisLabel.text = synopsis
        synopsisLabel.textAlignment = NSTextAlignment.Left
        synopsisLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        synopsisLabel.textColor = UIColor.whiteColor()
        synopsisLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        synopsisLabel.numberOfLines = 0
        scrollView.contentSize = synopsisLabel.frame.size
        scrollView.addSubview(synopsisLabel)
        scrollView.reloadInputViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

