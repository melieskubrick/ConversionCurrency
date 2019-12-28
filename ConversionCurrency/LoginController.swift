//
//  ViewController.swift
//  ConversionCurrency
//
//  Created by Melies Kubrick on 27/12/19.
//  Copyright © 2019 Melies. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
         layoutBtns()
    }
    
    func layoutBtns() {
        btnFacebook.layer.cornerRadius = 4
        btnTwitter.layer.cornerRadius = 4
        btnGoogle.layer.cornerRadius = 4
        btnLogin.layer.cornerRadius = 4
    }


}

