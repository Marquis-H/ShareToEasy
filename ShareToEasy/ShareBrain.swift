//
//  ShareBrain.swift
//  share-to
//
//  Created by Marquis on 15/9/10.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import Foundation
import CoreData

class ShareBrain{
    var ShareParames = NSMutableDictionary()
    
//    //获取需要持久化的数据
//    let app = UIApplication.sharedApplication().delegate as! AppDelegate
//    let context = app.managedObjectContext!
//    
//    //创建HistoryShare对象
//    var historyShare = NSEntityDescription.insertNewObjectForEntityForName("HistoryShareData", inManagedObjectContext: context) as! HistoryShare
    
    func getShareParames(Text: String, Images: String, Url: String, Title: String, Type: String){
        var types: (SSDKContentType) = SSDKContentType.Text
        switch Type {
        case "text": types = SSDKContentType.Text
        case "auto": types = SSDKContentType.Auto
        case "image": types = SSDKContentType.Image
        default:
            break
        }
        ShareParames.SSDKSetupShareParamsByText(Text,
            images : UIImage(named: Images),
            url : NSURL(string:Url),
            title : Title,
            type : types)
        
    }
    
    func shareWeiboBrain(Text: String, Images: String, Url: String, Title: String, Type: String){
            self.getShareParames(Text, Images: Images, Url: Url, Title: Title, Type: Type)
        ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: ShareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.isSuccess(state, Text: Text, Platfort: "weibo", error: error)
        }
        
    }
    
    func shareWechatTimeline(Text: String, Images: String, Url: String, Title: String, Type: String){
        self.getShareParames(Text, Images: Images, Url: Url, Title: Title, Type: Type)
        ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: ShareParames)  { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.isSuccess(state, Text: Text, Platfort: "wechat", error: error)
        }
    }
    
    func isSuccess(state: SSDKResponseState, Text: String, Platfort: String, error: NSError!){
        switch state {
        case SSDKResponseState.Success: println("分享成功")
        let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "取消")
        alert.show()
        case SSDKResponseState.Fail: println("分享失败,错误描述:\(error)")
            
        case SSDKResponseState.Cancel: println("分享取消")
        default:
            break
        }
    }
}
