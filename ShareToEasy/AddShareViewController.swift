//
//  AddShareViewController.swift
//  share-to
//
//  Created by Marquis on 15/9/10.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import UIKit
import CoreData
import SAWaveToast

class AddShareViewController: UIViewController {
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }else {
            return nil
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ShareTextView.layer.borderWidth = 2
        self.ShareTextView.layer.cornerRadius = 16
        self.ShareTextView.layer.borderColor = self.view.tintColor.CGColor

        // Do any additional setup after loading the view, typically from a nib.
        
        setupDelegate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shareBrain = ShareBrain()

    @IBOutlet weak var ShareTextView: UITextView!
    //点击输入框外区域，取消键盘
    @IBAction func viewClick(sender: AnyObject) {
        ShareTextView.resignFirstResponder()
    }
    
    //分享到新浪微博
    @IBAction func shareWeibo() {
        if ShareTextView.text != "" {
            shareBrain.shareWeiboBrain(ShareTextView.text, Images: "shareImg.png", Url: "http://www.baidu.com", Title: "test", Type: "text", HSData: self.createHSData(), managedObjectContext: self.managedObjectContext!)
        }else{
            self.error_msg("error")
        }
    }
    //分享到微信朋友圈
    @IBAction func shareWechatTimeline() {
        if ShareTextView.text != "" {
           shareBrain.shareWechatTimeline(ShareTextView.text, Images: "shareImg.png", Url: "http://www.baidu.com", Title: "test", Type: "text", HSData: self.createHSData(), managedObjectContext: self.managedObjectContext!)
        }else{
            self.error_msg("error")
        }
    }
    //分享到微信
    @IBAction func shareWechat() {
        if ShareTextView.text != "" {
           shareBrain.shareWechat(ShareTextView.text, Images: "shareImg.png", Url: "http://www.baidu.com", Title: "test", Type: "text", HSData: self.createHSData(), managedObjectContext: self.managedObjectContext!)
        }else{
            self.error_msg("error")
        }
    }
    
    
    @IBAction func allShare() {
        if ShareTextView.text != "" {
            shareBrain.allShare(self.view, Text: ShareTextView.text, Images: "shareImg.png", Url: "http://www.baidu.com", Title: "test", Type: "text", HSData: self.createHSData(), managedObjectContext: self.managedObjectContext!)
        }else{
            self.error_msg("error")
        }
    }
    
    func error_msg(status: String){
        let alertController:UIAlertController
        if status == "success" {
            alertController = UIAlertController(title: "分享成功", message: "分享成功", preferredStyle: .Alert)
        }else if status == "fail" {
            alertController = UIAlertController(title: "分享失败", message: "分享失败", preferredStyle: .Alert)
        }else if status == "error" {
            alertController = UIAlertController(title: "分享失败", message: "分享内容不能为空", preferredStyle: .Alert)
        }else{
            alertController = UIAlertController(title: "分享取消", message: "分享取消", preferredStyle: .Alert)
        }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true) { }
    }
    
    func showWaveToast(status:String) {
        var message:String?
        switch(status){
            case "success":
                message = "                                 分享成功                ################################################";
            case "fail":
                message = "                                 分享失败                ################################################";
                case "cancel":
                message = "                                 分享取消                ################################################";
            default:
                break
        }
        let waveToast = SAWaveToast(text: message!, font: .systemFontOfSize(16), fontColor: .darkGrayColor())
        presentViewController(waveToast, animated: false, completion: nil)
    }
    
    
    func createHSData() -> HistoryShareData{
        //创建HistoryShare对象
        let historyShare = NSEntityDescription.insertNewObjectForEntityForName("HistoryShareData", inManagedObjectContext: self.managedObjectContext!) as! HistoryShareData
        return historyShare
    }
}

//MARK: - shared xx
extension AddShareViewController: ShareBrainDelegate {
    func setupDelegate() {
        shareBrain.delegate = self
    }
    
    func changeLabel(newString:String){
            showWaveToast(newString)
    }
}
