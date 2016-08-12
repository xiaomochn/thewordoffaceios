//
//  APICloudeHelper.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/11.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit

class APICloudeHelper: NSObject {

    static let ID = "A6970328512280"
    static var appKey = "A411EB7A-E27D-E60F-EB23-F893EF978E06";
    class func getkey()->String{
        
        // var appKey =
        // sha1("A6968565094002"+"UZ"+"62FB16B2-0ED6-B460-1F60-EB61954C823B"+"UZ"+now)+"."+now
//        Date date = new Date();
//        @SuppressWarnings("deprecation")
//        String key = null;
//        try {
//            key = SH1.SHA1(ID + "UZ" + appKey + "UZ" + date.getTime()) + "."
//                + date.getTime();
//        } catch (NoSuchAlgorithmException e) {
//            e.printStackTrace();
//        } catch (UnsupportedEncodingException e) {
//            e.printStackTrace();
//        }
        let date = NSDate()
        let timeintravel = (Int)(date.timeIntervalSince1970*1000)
        var key = SH1.SHA1("\(ID)UZ\(appKey)UZ\(timeintravel)")
        key = "\(key).\(timeintravel)"
        return key
    }
   
}
