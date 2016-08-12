//
//  FaceTabVC.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/10.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import UzysAnimatedGifLoadMore
import Alamofire
import SwiftyJSON
class FaceTabVC: UIViewController {
    var data:[JSON] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        prepareView()
        getItem(true)
        // Do any additional setup after loading the view.
    }

    private func prepareView(){
       TableViewHelper.prepareTableView(tableView, refreshHandler: {
        self.getItem(true)
        }) { 
            self.getItem(false)
        }
    }
   // 获取数据
    func getItem(isFirst:Bool)  {
        Alamofire.request(.GET, UrlAndRequest.sharedInstance.getMainShowUrl(isFirst ? 0 : data.count, page: FaceMainVC.Titls.indexOf(title!)!), parameters: nil, encoding: .JSON, headers: UrlAndRequest.sharedInstance.getHeaders()).responseData { (response) in
            var json = JSON(data: response.data!)
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
     
    }
    deinit {
        tableView.dg_removePullToRefresh()
    }
}


extension FaceTabVC: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
           navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController((self.storyboard?.instantiateViewControllerWithIdentifier("LeftDrawerVC"))!, animated: true)
    }
}
extension FaceTabVC: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FaceCardCell") as! FaceCardCell
        cell.setData(data[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.width
    }
}
