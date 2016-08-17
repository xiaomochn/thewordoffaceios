//
//  FunCell.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/12.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON
import SDWebImage
class FunCell: MaterialTableViewCell {
    @IBOutlet weak var funImage: UIImageView!
    @IBOutlet weak var funTitle: UILabel!
    
   private var data:JSON?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(data:JSON) {
        self.data = data
        funImage.sd_setImageWithURL(NSURL(string: data["image"].stringValue))
        funTitle.text = data["title"].stringValue
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
