//
//  ThisUser.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/11.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit

class ThisUser: NSObject {
    static let sharedInstance = ThisUser()
    private override init() {
        
    }
    
    var created_at:String!
    var user_type:String!
    var username:String!
    var num_score:String!
    var updated_at:String!
    var id:String!
    var num_comments:String!
    var mobile:String!
    var nickname:String!
    var photo:String!
    var customer_id:String!
    
    
}
