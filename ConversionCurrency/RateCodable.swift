//
//  RateController.swift
//  ConversionCurrency
//
//  Created by Melies Kubrick on 28/12/19.
//  Copyright © 2019 Melies. All rights reserved.
//

import SwiftyJSON

struct Root : Codable {
    let rates : JSON
    let base : String
}
