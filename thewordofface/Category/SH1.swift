//
//  SH1.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/11.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
class SH1: NSObject {
    class func SHA1 (preStr:String)->String{
        let data = preStr.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}
