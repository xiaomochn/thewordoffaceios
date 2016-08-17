//
//  FaceItemDetial.swift
//  thewordofface
//
//  Created by xiaomo on 8/17/16.
//  Copyright © 2016 xiaomo. All rights reserved.
//

import UIKit
import SwiftyJSON
class FaceItemDetial: UIViewController {

    var data:JSON!
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        // Do any additional setup after loading the view.
    }
    func prepareView()  {
        navigationItem.title = "详情"
        faceImage.sd_setImageWithURL(NSURL(string: data["imgurl"].stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!))
      
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
