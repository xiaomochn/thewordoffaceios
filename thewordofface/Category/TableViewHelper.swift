//
//  TableViewHelper.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/11.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import UzysAnimatedGifLoadMore
class TableViewHelper: NSObject {

    static func  prepareTableView(tableView:UITableView,refreshHandler: () -> Void,loadMoreHandler:()->Void){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({  () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
         
            refreshHandler()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        // loadMore
        tableView.addLoadMoreActionHandler({ () ->Void in
            loadMoreHandler()
            }, progressImagesGifName: "slackLoader@2x.gif", loadingImagesGifName: "nevertoolate@2x.gif", progressScrollThreshold: 60, loadingImageFrameRate: 30)
        
    }
}
