//
//  FaceCardCell.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/10.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON
import SDWebImage
class FaceCardCell: MaterialTableViewCell {
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeImageCon: UIView!
    @IBOutlet weak var startInfolb: UILabel!
    
    
    var tagViews:[UIView] = []
    private var data:JSON?
    func setData(data:JSON)  {
        self.data = data
        faceImage.sd_setImageWithURL(NSURL(string: data["imgurl"].stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!))
        if data["like_candidate_url"].stringValue != ""{
            likeImageCon.hidden = false
            likeImage.sd_setImageWithURL(NSURL(string: data["like_candidate_url"].stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! ))
            startInfolb.text = "\(data["like_candidate_username"].stringValue) \(data["like_candidate_simler"].stringValue)"
        }else{
            likeImageCon.hidden = true
        }
        prepareTagView()
    }
    func prepareTagView() {
        for item in tagViews {
            item.removeFromSuperview()
        }
        
        for item in data!["item_comment_item"].arrayValue {
            let tagView = LBTagView(frame: CGRect(x: item["position_x"].intValue * Int(self.frame.width)/100, y: item["position_y"].intValue * Int(self.frame.width)/100, width: 10, height: 20))
            tagView.text = item["message"].stringValue
            tagView.canMove = false
            tagView.direction = item["islift"].intValue == 1 ?  .Right:.Left
            tagViews.append(tagView)
            addSubview(tagView)
        }
        // 颜值标签
        let  tagViewx =  data!["face_eye_right_x"].intValue// 超过90  就是90
        var tagView = LBTagView(frame: CGRect(x: (tagViewx > 70 ? 70 : tagViewx) * Int(self.frame.width)/100, y: data!["face_eye_right_y"].intValue * Int(self.frame.width)/100, width: 10, height: 20))
        tagView.text = "颜值:\(data!["score"].stringValue)"
        tagView.canMove = false
        tagViews.append(tagView)
        addSubview(tagView)
        // message标签
         tagView = LBTagView(frame: CGRect(x: 5 * Int(self.frame.width)/100, y: 90 * Int(self.frame.width)/100, width: 10, height: 20))
        tagView.text = data!["imamessage"].stringValue
        tagView.canMove = false
        tagViews.append(tagView)
        addSubview(tagView)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
