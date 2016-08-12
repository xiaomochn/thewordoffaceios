//
//  UrlAndRequest.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/10.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import Alamofire
class UrlAndRequest: NSObject {
    static let sharedInstance = UrlAndRequest()
    private override init() {
    }
    // 我的
    func getMyFaceUrl(begain:Int)->String{
        return "http://www.apicloud.com/mcm/api/item?filter={\"where\":{\"userid\":\""+ThisUser.sharedInstance.id+"\",\"states\":{\"ne\":1}},\"order\":\"createdAt%20DESC\",\"skip\":\(begain),\"limit\":20,\"include\":\"item_comment_item\"}";
    }
    // 我赞过的的
    func getComment_itemUrl(begain:Int)->String{
        return "http://www.apicloud.com/mcm/api/item?filter={\"where\":{},\"skip\":0,\"limit\":20,\"include\":\"item_comment_item\",\"includefilter\":{\"item_comment_item\":{\"user_id\":\"059D4FAAA1775AB7CBAA265EB265A7E1\"}}}";
    }
    
    func MainShowUrlWhere() -> Array<String> {
        return ["",
                ",\"createdAt\":{\"gte\":\"\(get7daybefor())\"},\"face_gender\":\"女\",\"commentnum\":{\"gt\":1}",
                ",\"createdAt\":{\"gte\":\"\(get7daybefor())\"},\"face_gender\":\"男\",\"commentnum\":{\"gt\":1}",
                ",\"createdAt\":{\"gte\":\"\(get7daybefor())\"}"]
    }
    let  MainShowUrlrder = ["\"createdAt DESC\"","\"commentnum DESC\"","\"commentnum DESC\"","\"like_candidate_simler DESC\""];
    // 主页的几个链接
    // 获取时间  1个月前  随时改
    var daybeforTemp:String?
    func get7daybefor()->String{
        if daybeforTemp == nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            daybeforTemp = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970-14*24*3600));
        }
        return daybeforTemp!
    }
    func getMainShowUrl(begain:Int,  page:Int)->String{
 
        return "http://www.apicloud.com/mcm/api/item?filter={\"where\":{\"states\":{\"ne\":1}\(MainShowUrlWhere()[page])},\"order\":\(MainShowUrlrder[page]),\"skip\":\(begain),\"limit\":10,\"include\":\"item_comment_item\"}".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!;
        
    }
    func getFunMainUrl(begain:Int, page:Int)->String{
        return "http://www.apicloud.com/mcm/api/fun?filter={\"where\":{\"states\":{\"ne\":1}},\"order\":\"gravity%20DESC\",\"skip\":\(begain),\"limit\":10} ";
    }
    // 单条
    func getMyFacedUrl(itemid:String )->String{
        return "http://www.apicloud.com/mcm/api/item/"+itemid;
    }
    
    // 获取item对应的用户 同时判断存在与否
    func getCustomeruserbycId( customer_id:String)->String{
        return "http://www.apicloud.com/mcm/api/customeruser?filter={\"where\":{\"customer_id\":\""+customer_id+"\"},\"skip\":0,\"limit\":3}";
    }
    
    // 获取这个用户是否存在
    func getCreateCustomeruser()->String{
        return "http://www.apicloud.com/mcm/api/customeruser";
    }
    // 获取这个用户是否存在
    func getComment_itemUrlbyId(itemid:String)->String{
        return "http://www.apicloud.com/mcm/api/comment_item/\(itemid)";
    }
    func upLoadDetialItem(position_y:Int,position_x:Int, message:String, itemid:String,islift:Int,commentype:Int,completionHandler: Response<NSData, NSError> -> Void){
        let dic:[String:String] = ["position_y": "\(position_y)",
                   "position_x":"\(position_x)",
                   "message":message,
                   "islift": "\(islift)",
                   "commentype":"\(commentype)",
                   "item(uz*R*id)": itemid,
                   "user_id": ThisUser.sharedInstance.id
        ]
        createClassItem(dic,url: "http://www.apicloud.com/mcm/api/comment_item",completionHandler: completionHandler);
    }
    
    func createClassItem( map:[String:String], url:String
       ,completionHandler: Response<NSData, NSError> -> Void){
        Alamofire.request(.POST, url, parameters: map, encoding: .JSON, headers: getHeaders()).responseData(completionHandler: completionHandler)
    }
    func  getHeaders()->[String:String]{
        return   ["Accept":"application/json","Content-Type":"application/json","X-APICloud-AppId": APICloudeHelper.ID,"X-APICloud-AppKey": APICloudeHelper.getkey()]
    }
    
}
