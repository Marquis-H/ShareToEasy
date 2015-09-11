//
//  AddShareViewController.swift
//  share-to
//
//  Created by Marquis on 15/9/10.
//  Copyright (c) 2015年 Marquis. All rights reserved.
//

import UIKit

class AddShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ShareTextView.layer.borderWidth = 2
        self.ShareTextView.layer.cornerRadius = 16
        self.ShareTextView.layer.borderColor = self.view.tintColor.CGColor
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var shareBrain = ShareBrain()
    
    @IBOutlet weak var ShareTextView: UITextView!
    @IBAction func shareWeibo() {
        if ShareTextView.text != "" {
            shareBrain.getShareParames(ShareTextView.text, Images: "shareImg.png", Url: "http://www.baidu.com", Title: "test", Type: "text")
            shareBrain.shareWeiboBrain()
        }else{
            let alert = UIAlertView(title: "分享失败", message: "分享内容不能为空", delegate: self, cancelButtonTitle: "取消")
            alert.show()
        }
    }
    @IBAction func shareWeixin() {
    }
}
