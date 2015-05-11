//
//  Utility.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/10/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import Foundation

public class Utility {
    // common utility/helper functions used by View Controllers
    
    public class func getHiResImageUrl(originalUrl: String) -> String {
        var url = String()  // i.e. originalUrl: "http://resizing.flixster.com/q7N6i-lodgiFIv2pn2fKcITzDFw=/o/dkpu1ddg7pbsk.cloudfront.net/movie/11/19/07/11190713_ori.jpg"
        if let range = originalUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch) {
            url = originalUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        return url
    }
    
    public class func startNetworkNotifier(networkIndicatorLabel: UILabel) -> Void {
        let reachability = Reachability.reachabilityForInternetConnection()
        reachability.whenUnreachable = { reachability in
            // display network error
            networkIndicatorLabel.hidden = false
            networkIndicatorLabel.text = "Network error!"
            networkIndicatorLabel.textAlignment = NSTextAlignment.Center
            networkIndicatorLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            networkIndicatorLabel.textColor = UIColor.yellowColor()
            networkIndicatorLabel.numberOfLines = 1
        }
        reachability.startNotifier()
    }
    
}