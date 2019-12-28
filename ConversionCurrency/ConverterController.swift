//
//  ConverterController.swift
//  ConversionCurrency
//
//  Created by Melies Kubrick on 27/12/19.
//  Copyright © 2019 Melies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConverterController: UIViewController {
    
    
    var jsonData = Data()
    var keys = Array<String>()
    var values = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = Alamofire.request("https://api.exchangeratesapi.io/latest")
        request.responseJSON { (response) in
            
            let jsonString = String(data: response.data!, encoding: .utf8)!
            self.jsonData = jsonString.data(using: .utf8)!
            
            do {
                let res = try JSONDecoder().decode(Root.self, from: self.jsonData)
                let jsonRes = res.rates
                
                for (key, value) in jsonRes {
                    print("key \(key)")
                    print("value \(value)")
                }
                
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
    }
    
    
}

