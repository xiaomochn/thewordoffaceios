//
//  FaceResultVC.swift
//  thewordofface
//
//  Created by xiaomo on 16/8/15.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit
import TYAttributedLabel
import SwiftyJSON
import FaceppSDK
import Alamofire

enum Step {
    case 解析第一步
    case 相似度获取
    case 相似明星获取
    case 啥也没有
}

class FaceResultVC: UIViewController {
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var faceLoadMsg: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    var imageSrc:UIImage!
    var faceJson:JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        loadData()
    }
    
    var step = Step.啥也没有
    func redetech() {// 出现失败是点击重试
        switch step {
        case .啥也没有: break
        case .相似度获取:
            相似度计算及处理()
        case .相似明星获取:
            查找相似明星()
        case .解析第一步:
            loadData()
        }
        step = .啥也没有
    }
    func loadData()  {
        appendMsg("正在分析图片...")
        FacePPHelper.sharedDataHelper().detectWithImage(imageSrc) { [weak self](result)  in
            if self == nil{
                return
            }
            self!.appendMsg("图片分析完成")
            if  (result == nil){
                self!.appendMsg("图片分析失败,你可以点击这里重试或者换一张照片试试")
                self!.step = .解析第一步
                return
            }
            self!.step = .啥也没有
            self!.faceJson = JSON(arrayLiteral: result)[0]
            if result["face"]?.count < 1{
                self!.appendMsg("没找到人脸,请换一张照片试试")
                return
            }
            self!.appendMsg("查找到\(self!.faceJson["face"].count)张脸,以下是脸A的数据")
            var str = "性别:\(self!.faceJson["face"][0]["attribute"]["gender"]["value"].stringValue)  "
            str = "\(str)年龄:\(self!.faceJson["face"][0]["attribute"]["age"]["value"].stringValue)  "
            str = "\(str)微笑度:\(self!.faceJson["face"][0]["attribute"]["smiling"]["value"].stringValue)"
            self!.appendMsg(str)
            self!.appendMsg("颜值:\(self!.getScores())")
            self!.appendMsg("")
            // 相似度计算及显示
            if result["face"]?.count > 1{
                self!.相似度计算及处理()
            }else{
                self!.查找相似明星()
            }
        }
    }
    
    func 相似度计算及处理() {
        appendMsg("正在计算脸A与脸B的相似度...")
        NSOperationQueue().addOperationWithBlock({[weak self ] in
            let result = FaceppAPI.recognition().compareWithFaceId1(self!.faceJson["face"][0]["face_id"].stringValue, andId2: self!.faceJson["face"][1]["face_id"].stringValue, async: false)
            NSOperationQueue.mainQueue().addOperationWithBlock({[weak self] in
                if self == nil{
                    return
                }
                if (result.success) {
                    let json = JSON(arrayLiteral: result.content)[0]
                    self!.appendMsg("脸A与脸B的整体相似度相似度:\(json["similarity"].stringValue)")
                    self!.appendMsg("眼睛相似度:\(json["component_similarity"]["eye"].stringValue)")
                    self!.appendMsg("眉毛相似度:\(json["component_similarity"]["eyebrow"].stringValue)")
                    self!.appendMsg("鼻子相似度:\(json["component_similarity"]["nose"].stringValue)")
                    self!.appendMsg("嘴相似度:\(json["component_similarity"]["mouth"].stringValue)")
                    self!.查找相似明星()
                }else{
                    self!.appendMsg("相似度计算失败点击这里重试")
                    self!.step = .相似度获取
                    self!.查找相似明星()
                }
                self!.appendMsg("")
                })
            })
    }
    func 查找相似明星(){
        appendMsg("正在查找与脸A相似的明星")
        获取id()
    }
    let demoHeader = ["Host":"apicn.faceplusplus.com",
                      "Content-Type":"multipart/form-data; boundary=----WebKitFormBoundaryUPkUm83ZOvVxCO22\"",
                      "Origin":"http://www.faceplusplus.com.cn",
                      "Accept-Encoding":"Accept-Encoding",
                      "Connection":"keep-alive",
                      "User-Agent":"",
                      "Accept":"*/*",
                      "Referer":"http://www.faceplusplus.com.cn/demo-search/",
                      "Accept-Language":"zh-cn"]
    func 获取id(){
        
        
        Alamofire.upload(.POST, "http://apicn.faceplusplus.com/v2/detection/detect?api_key=DEMO_KEY&api_secret=DEMO_SECRET&mode=commercial", headers: demoHeader, multipartFormData: {[weak self] (data) in
            if self == nil{
                return}
            let imageData = UIImageJPEGRepresentation((self!.imageSrc)!, 0.5)
            data.appendBodyPart(data: imageData!, name: "img")
            data.appendBodyPart(data: imageData!, name: "img", fileName: "img", mimeType: "image/*")
        }, encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold) {[weak self] (result) in
            if self == nil{
            return}
            print("数据准备完成；")
            switch result {
            case .Success(let upload, _, _):
                //                    case .Success(request: Request, streamingFromDisk: Bool, streamFileURL: NSURL?):
                upload.responseString(completionHandler: { (respone) in
                    respone.data
                    let json = JSON(data: respone.data!)
                    let face_id = json["face"][0]["face_id"]
                    if (face_id.error != nil){
                        self!.appendMsg("查找相明星失败,点击重试")
                        self!.step = .相似明星获取
                        return
                    }
                    self!.getLikeStar(face_id.stringValue)
                })
            case .Failure(let err):
                print(err)
                break
            }
        }
        
        
    }
    var LikeStarJson:JSON!
    func getLikeStar(face_id:String){// 根据faceid获取
        Alamofire.request(.GET, "http://apicn.faceplusplus.com/v2/recognition/search?api_key=DEMO_KEY&api_secret=DEMO_SECRET&key_face_id=\(face_id)&faceset_name=starlib3&count=8&mode=commercial", parameters: nil, encoding: ParameterEncoding.URLEncodedInURL, headers: demoHeader).responseData { [weak self](respone) in
            if self == nil{
                return
            }
             self!.LikeStarJson = JSON(data: respone.data!)
            self!.appendMsg("从我们的明星库中找到8张和你相似的照片")
            let firstLike = FaceResultVC.getPicUrlandName(self!.LikeStarJson["candidate"][0]["tag"].stringValue)
            self!.appendMsg("首张 姓名: \(firstLike.name)  相似度: \(self!.LikeStarJson["candidate"][0]["similarity"].stringValue) ")
          
            self!.simler = self!.LikeStarJson["candidate"][0]["similarity"].doubleValue
            self!.appendMsg("明星相似度加成后的颜值:\(self!.getScores())")
              self!.appendMsg("点击相似明星可以查看其他相似明星")
            self!.appendMsg("计算完成")
            self!.likeImageView.sd_setImageWithURL(NSURL(string: firstLike.url), completed: {[weak self] (_, _, _, _) in
                self!.likeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FaceResultVC.showStarList)))
                
                self!.appendMsg(" ")
                self!.appendMsg(" ")
                self!.appendMsg(" ")
                self!.appendMsg(" ")
                self!.appendMsg(" ")
                self!.appendMsg(" ")
                  self!.appendMsg(" ")
                  self!.appendMsg(" ")
                })
            
        }
    }
    
    func showStarList() {
        let vc =  self.storyboard?.instantiateViewControllerWithIdentifier("LikeStarTableVC") as? LikeStarTableVC
        vc?.data = LikeStarJson["candidate"]
        navigationController?.pushViewController(vc!, animated: true)
    }
  class  func   getPicUrlandName(tag:String)->(url:String,name:String) {
        var picUrl:String
        var temp =  tag.componentsSeparatedByString("|")
        if (temp.count>1){
            picUrl = "http://www.faceplusplus.com.cn/assets/demo-img2/"+temp[1]+"/"+temp[0]
            picUrl = picUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            return (picUrl,temp[1]);
        }else {
            picUrl = "http://www.faceplusplus.com.cn/assets/demo-img2/";
            return ("","");
        }
    }
    
    func prepareView()  {
        navigationItem.title = "颜值"
        faceImage.image = imageSrc
        faceLoadMsg.text = ""
        faceLoadMsg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FaceResultVC.redetech)))
        //        faceLoadMsg.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func appendMsg(string:String)  {
        var msgText = faceLoadMsg.text! as String
        msgText = "\(msgText)\n\(string)"
        UIView.animateWithDuration(30) {[weak self] in
            self!.faceLoadMsg.text = msgText
        }
        //        testMsg.text = msgText
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //  颜值计算
    
    var scores = 0.0
    
    var  eye:Double!
    var  mouth:Double!
    var  nose:Double!
    var  otherpoint:Double!
    var  otherpoint2:Double!
    var  simler=0.0
    
    
    func  getScores() ->Int{
        
        //        self!.faceJson["face"][0]["attribute"]
        //        faceJson.doubleValue
        initeyemouthnose()
        let temp = faceJson["face"][0]["attribute"]["age"]["value"].intValue
        let agePoint = ( Double(temp) / 23.0) * 200
        
        let smilingPoint = (faceJson["face"][0]["attribute"]["smiling"]["value"].doubleValue / 4.0) * 10;
        otherpoint = (smilingPoint + agePoint) / 45;
        otherpoint2 = smilingPoint / 200 + getsc(Double(temp), y: 24) / 2;
        
        scores = eye * 2000 + mouth * 2000
        scores = scores + nose * 2000 + otherpoint * 100
        
        scores = scores + (simler * simler * simler / 300.0) + 1000.0
        scores = Double(Int(scores) % 10000)
        return Int(scores);
    }
    
    func initeyemouthnose(){
        //        simler = faceJson["face"][0]["attribute"]["smiling"]["value"].doubleValue
        eye =  getlingLong(faceJson["face"][0]["position"]["eye_left"]["x"].doubleValue);
        mouth = getlingLong(faceJson["face"][0]["position"]["mouth_left"]["x"].doubleValue);
        eye = getsc(eye,y: 98.0)*3;
        mouth = getsc(mouth,y: 2.0)*5;
        nose = getsc( faceJson["face"][0]["position"]["height"].doubleValue/faceJson["face"][0]["position"]["width"].doubleValue,y: 1.618)*1.5;
        
    }
    func getlingLong( x:Double) ->Double{
        let line = abs(faceJson["face"][0]["position"]["center"]["x"].doubleValue - x)*100
        return line / faceJson["face"][0]["position"]["width"].doubleValue
    }
    func getsc(x:Double, y:Double) ->Double{
        let a = x / y;
        return a < 1 ? a : 1 / a;
    }
    
    
    
}
