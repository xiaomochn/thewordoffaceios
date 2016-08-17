//
//  FunVC.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/12.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class FunVC: UIViewController {
    var data:[JSON] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        prepareView()
        getItem(true)
        // Do any additional setup after loading the view.
    }

    func prepareView()  {
        TableViewHelper.prepareTableView(tableView, refreshHandler: {
            self.getItem(true)
        }) {
            self.getItem(false)
        }
    }
    func getItem(isFirst:Bool) {
        Alamofire.request(.GET, UrlAndRequest.sharedInstance.getFunMainUrl(isFirst ? 0 : data.count), parameters: nil, encoding: .JSON, headers: UrlAndRequest.sharedInstance.getHeaders()).responseData { (response) in
            let json = JSON(data: response.data!)
            if isFirst{
                self.data.removeAll()
            }
            self.data.appendContentsOf(json.arrayValue)
            self.tableView.dg_stopLoading()
            self.tableView.stopLoadMoreAnimation()
            self.tableView.reloadData()
        }
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

extension FunVC:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FunCell") as! FunCell
        cell.setData(data[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.width
    }
}
extension FunVC:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("MyWebViewVC") as! MyWebViewVC
        vc.url = data[indexPath.row]["url"].stringValue
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
