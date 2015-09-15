//
//  AddSharePlatform.swift
//  ShareToEasy
//
//  Created by Marquis on 15/9/11.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import Foundation

class AddSharePlatform {
    
    func registerApp(){
        ShareSDK.registerApp("a4ff49cbf0d8",
            activePlatforms: [SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeTencentWeibo.rawValue,
                SSDKPlatformType.TypeFacebook.rawValue,
                SSDKPlatformType.TypeWechat.rawValue], onImport: {(platform : SSDKPlatformType) -> Void in
                    switch platform{
                    case SSDKPlatformType.TypeWechat:
                        ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                        
                    case SSDKPlatformType.TypeQQ:
                        ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(),
                            tencentOAuthClass: TencentOAuth.classForCoder())
                    default:
                        break
                    }
            }, onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                self.addPlatform(platform, appInfo: appInfo)
        })
    }
    
    func addPlatform(platform: SSDKPlatformType, appInfo: NSMutableDictionary!){
        switch platform {
        case SSDKPlatformType.TypeSinaWeibo:
            //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
            appInfo.SSDKSetupSinaWeiboByAppKey("533435176",
                appSecret : "b196d9f82feb61b3d5e73749726f82d9",
                redirectUri : "http://www.zhbitwiki.com",
                authType : SSDKAuthTypeBoth)
            
        case SSDKPlatformType.TypeWechat:
            //设置微信应用信息
            appInfo.SSDKSetupWeChatByAppId("wx72eea6dc0e36b4a5",
                appSecret: "6b63fe5177ad8cb9812e5f1bf24094bf")
            
        case SSDKPlatformType.TypeTencentWeibo:
            //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
            appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
                appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                redirectUri : "http://www.zhbitwiki.com")
            
        case SSDKPlatformType.TypeFacebook:
            //设置Facebook应用信息，其中authType设置为只用SSO形式授权
            appInfo.SSDKSetupFacebookByAppKey("107704292745179",
                appSecret : "38053202e1a5fe26c80c753071f0b573",
                authType : SSDKAuthTypeBoth)
            
        default:
            break
        }
    }
}
