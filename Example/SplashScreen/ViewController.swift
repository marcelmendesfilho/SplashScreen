//
//  ViewController.swift
//  SplashScreen
//
//  Created by marcel.mendes@gmail.com on 09/05/2019.
//  Copyright (c) 2019 marcel.mendes@gmail.com. All rights reserved.
//

import UIKit
import SplashScreen

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LaunchSplash.showSplashScreen(caller: self,
                                      app: "marcelmendes.splashscreen",
                                      version: "1.0",
                                      key: "splash",
                                      localization: "EN",
                                      hostName: "www.shopcolecao.com/",
                                      splashEndpoint: "retrieveSplash.php",
                                      httpHeader: "https://",
                                      imageHostName: "www.shopcolecao.com/",
                                      imagePath: "Images/")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

