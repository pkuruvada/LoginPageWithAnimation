//
//  LoginView.swift
//  SimpleLogin
//
//  Created by VENKATA KURUVADA on 9/9/15.
//  Copyright © 2015 VENKATA KURUVADA. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


protocol InitialView {
    
    var title:UILabel? { get };
    var email:UITextField! { get }
    var password:UITextField! { get }
    var btn:UIButton! { get }
    
}

protocol InitViewDelegate  {
    
    func prepareForAnimation(view : InitialView);
    func beginAnimating(view : InitialView)
}


class InitViewAnimator: InitViewDelegate {
    
    func prepareForAnimation( view: InitialView) {
        view.title?.center.x -= UIScreen.mainScreen().bounds.width;
        view.email?.center.x -= UIScreen.mainScreen().bounds.width;
        view.password?.center.x -= UIScreen.mainScreen().bounds.width;
        view.btn?.center.x -= UIScreen.mainScreen().bounds.width;
    }
    
    func beginAnimating(view : InitialView) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            view.title?.center.x += UIScreen.mainScreen().bounds.width;
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                view.email?.center.x += UIScreen.mainScreen().bounds.width;
            }, completion: nil);
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                view.password?.center.x += UIScreen.mainScreen().bounds.width;
            }, completion: nil);
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                view.btn?.center.x += UIScreen.mainScreen().bounds.width;
            }, completion: nil);
        
    }
    
}


class LoginView: UIView, InitialView {


    var title:UILabel?;
    var email:UITextField!;
    var password:UITextField!;
    var btn:UIButton!;
    
    var player:AVPlayer?;
    
    var delegate: InitViewDelegate?;
    
    // private variables
    
    private var signInAction:(() -> Void)?
    private var titleString:String?;
    private let buttonLabel:String = "Sign In";
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
     convenience init(title:String , signInAction : () -> Void) {
        
        self.init(frame: CGRectZero);
        
        self.signInAction = signInAction;
        self.titleString = title;
        
        initializeView();

    }
    

    func initializeView() {
        
        //self.backgroundColor = UIColor.whiteColor();
        setBackgroundVideo();
        
        title = UILabel();
        title?.text = self.titleString;
        title?.textAlignment = NSTextAlignment.Center;
        title?.translatesAutoresizingMaskIntoConstraints = false;
        title?.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0);
        self.addSubview(title!);
        
        let emailpadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 40.0))
        
        email = UITextField();
        email.leftView = emailpadding;
        email.leftViewMode = UITextFieldViewMode.Always;
        email.translatesAutoresizingMaskIntoConstraints = false;
        email.backgroundColor = UIColor.lightGrayColor();
        self.addSubview(email);
        
        let passwordpadding = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15.0, height: 40.0))
        
        password = UITextField();
        password.leftView = passwordpadding;
        password.leftViewMode = UITextFieldViewMode.Always;
        password.secureTextEntry = true;
        password.backgroundColor = UIColor.lightGrayColor();
        password.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(password);
        
        btn = UIButton();
        btn.setTitle(self.buttonLabel, forState: UIControlState.Normal);
        btn.titleLabel?.font = UIFont(name: "Ariel", size: 16.0)
        print(self.buttonLabel)
        btn.addTarget(self, action: "signInClicked:", forControlEvents: UIControlEvents.TouchDown);
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.1, alpha: 0.8)
        self.addSubview(btn);
        
        layoutItems();
        
    }
    
    func setBackgroundVideo() {
        let url = NSURL(string:"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4");
        
        
        self.player = AVPlayer(URL: url!)
        let playerController = AVPlayerViewController()
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerController.player = self.player;
        playerController.showsPlaybackControls = false;
        playerController.view.frame = self.bounds;
        playerController.player?.play();
        self.addSubview(playerController.view);
        
        print(AVPlayerItemDidPlayToEndTimeNotification)

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: self.player!.currentItem)
        
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player!.seekToTime(kCMTimeZero)
        self.player!.play()
    }
    
    func signInClicked(sender : UIButton) {
        
        guard let signInCallback = signInAction  else {
            return;
        }
        
        signInCallback();
    }
    
    func layoutItems() {
        
        
        let views:[String: AnyObject] = [
            "title" : self.title!,
            "email" : self.email,
            "password" : self.password,
            "btn" : self.btn
        ];
        
        let metrics = [
            "padding10" : 10,
            "padding20":20,
            "padding50":50,
            "padding100":100
        ];
        

        let vFormatString = "V:|-padding100-[title]-padding50-[email(40)]-padding20-[password(40)]-padding50-[btn]"
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(vFormatString,
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metrics, views: views);
        
        self.addConstraints(vConstraints);
        
        let titleH =  Constraints.setHorizontalStretch(views, metrics: metrics, padding: "padding10", view: "title");
        let emailH = Constraints.setHorizontalStretch(views, metrics: metrics, padding: "padding20", view: "email");
        let passwordH = Constraints.setHorizontalStretch(views, metrics: metrics, padding: "padding20", view: "password");
        let btnH = Constraints.setHorizontalStretch(views, metrics: metrics, padding: "padding20", view: "btn");
        
        self.addConstraints(titleH);
        self.addConstraints(emailH);
        self.addConstraints(passwordH);
        self.addConstraints(btnH);
        
    }
    
}
