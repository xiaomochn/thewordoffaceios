//
//  LikeStarTableCell.swift
//  thewordofface
//
//  Created by xiaomo on 8/17/16.
//  Copyright © 2016 xiaomo. All rights reserved.
//

import UIKit
import SwiftyJSON
class LikeStarTableCell: UITableViewCell {
    @IBOutlet weak var funImage: UIImageView!
    @IBOutlet weak var funTitle: UILabel!
    
    private var data:JSON?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(data:JSON) {
    self.data = data
      
        let firstLike = FaceResultVC.getPicUrlandName(data["tag"].stringValue)
        
        funImage.sd_setImageWithURL(NSURL(string: firstLike.url))
        funTitle.text = firstLike.name + "相似度: " + data["similarity"].stringValue
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
