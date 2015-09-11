//
//  LoginViewController.swift
//  SimpleLogin
//
//  Created by VENKATA KURUVADA on 9/9/15.
//  Copyright © 2015 VENKATA KURUVADA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    weak var myView: LoginView? { return self.view as? LoginView };
    let loginSubViewsAnimator = InitViewAnimator();
    
    override func loadView() {
        let loginView = LoginView(title: "Login To App", signInAction: { () -> Void in
            print("Logged In");
        });
        
        loginView.delegate = loginSubViewsAnimator;
        self.view = loginView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        myView?.delegate?.prepareForAnimation(myView!)
        myView?.delegate?.beginAnimating(myView!);
    }

}
