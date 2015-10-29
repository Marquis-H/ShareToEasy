//
//  ShareBrain.swift
//  share-to
//
//  Created by Marquis on 15/9/10.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import Foundation
import CoreData
import SAWaveToast

class ShareBrain{
    
    var ShareParames = NSMutableDictionary()
    var delegate:ShareBrainDelegate?
    
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
    
    func shareWeiboBrain(Text: String, Images: String, Url: String, Title: String, Type: String, HSData: HistoryShareData, managedObjectContext: NSManagedObjectContext){
            self.getShareParames(Text, Images: Images, Url: Url, Title: Title, Type: Type)
        ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: ShareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.isSuccess(state, Text: Text, Platfort: "weibo", error: error, HSData: HSData, managedObjectContext: managedObjectContext)
        }
        
    }
    
    func shareWechatTimeline(Text: String, Images: String, Url: String, Title: String, Type: String, HSData: HistoryShareData, managedObjectContext: NSManagedObjectContext){
        self.getShareParames(Text, Images: Images, Url: Url, Title: Title, Type: Type)
        ShareSDK.share(SSDKPlatformType.SubTypeWechatTimeline, parameters: ShareParames)  { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.isSuccess(state, Text: Text, Platfort: "wechatTimeline", error: error, HSData: HSData, managedObjectContext: managedObjectContext)
        }
    }
    
    func shareWechat(Text:String, Images: String, Url: String, Title: String, Type: String, HSData: HistoryShareData, managedObjectContext: NSManagedObjectContext){
        self.getShareParames(Text, Images: Images, Url: Url, Title: Title, Type: Type)
        ShareSDK.share(SSDKPlatformType.TypeWechat, parameters: ShareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            self.isSuccess(state, Text: Text, Platfort: "wechat", error: error, HSData: HSData, managedObjectContext: managedObjectContext)
        }
    }
    
    func allShare(View: UIView!, Text: String, Images: String, Url: String, Title: String, Type: String, HSData: HistoryShareData, managedObjectContext: NSManagedObjectContext){
        ShareSDK.showShareActionSheet(View, items: nil, shareParams: ShareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state {
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
            default:
                break
            }
        }

        
    }
    
    func isSuccess(state: SSDKResponseState, Text: String, Platfort: String, var error: NSError!, HSData: HistoryShareData, managedObjectContext: NSManagedObjectContext){
        switch state {
        case SSDKResponseState.Success: print("分享成功")
        self.delegate!.changeLabel("success")
        //对数据持久化
        HSData.status = "success"
        HSData.platform = Platfort
        HSData.text = Text
        HSData.createdAt = NSDate()
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("不能保存")
            }

        case SSDKResponseState.Fail: print("分享失败,错误描述:\(error)")
        self.delegate!.changeLabel("fail")
            HSData.status = "fail"
            HSData.platform = Platfort
            HSData.text = Text
            HSData.createdAt = NSDate()
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            print("不能保存")
            }
        case SSDKResponseState.Cancel: print("分享取消")
            self.delegate!.changeLabel("cancel")
        default:
            break
        }
    }
    
}
