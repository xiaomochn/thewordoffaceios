//
//  MyWebViewVC.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/12.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit

class MyWebViewVC: UIViewController {
    var url:String?
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let request = NSURLRequest(URL: NSURL(string: url!)!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
