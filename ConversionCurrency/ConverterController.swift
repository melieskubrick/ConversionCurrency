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

class ConverterController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var currencyType: UITextField!
    @IBOutlet weak var valueOfCurrency: UITextField!
    @IBOutlet weak var desiredCurrency: UITextField!
    @IBOutlet weak var valueConverted: UILabel!
    
    var keys = Array<String>()
    var values = Array<String>()
    let thePicker = UIPickerView()
    var positionRate = Int()
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    let alertLoading = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    var base = String()
    var jsonRes = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading(status: "Present")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestApi()
        picker()
    }
    
    func picker() {
        currencyType.inputView = thePicker
        desiredCurrency.inputView = thePicker
        thePicker.delegate = self
    }
    
    func loading(status: String) {
        

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alertLoading.view.addSubview(loadingIndicator)
        present(alertLoading, animated: true, completion: nil)
    }
    
    func requestApi() {
        let request = Alamofire.request("https://api.exchangeratesapi.io/latest\(base)")
        request.responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                self.alertLoading.dismiss(animated: true, completion: nil)
                
                let jsonString = String(data: response.data!, encoding: .utf8)!
                let jsonData = jsonString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode(Root.self, from: jsonData)
                    self.jsonRes = res.rates
                    self.base = res.base
                    
                    for (key, value) in self.jsonRes {
                        self.keys.append(key)
                        self.values.append("\(value)")
                    }
                    
                    self.keys = self.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                    
                } catch {
                    print("Unexpected error: \(error).")
                }
                
            case .failure:
                print("Request failed")
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keys.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keys[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.currencyType.isEditing == true {
            currencyType.text = keys[row]
        } else if self.desiredCurrency.isEditing == true {
            desiredCurrency.text = keys[row]
            positionRate = row
        }
        
        
        print(keys[row])
    }
    
    @IBAction func convert(sender: UIButton){
        
        let defaultValue = Double("\(jsonRes[currencyType.text!])")!
        let valueCurrency = Double("\(valueOfCurrency.text!)")!
        
        let desiredValue = Double("\(jsonRes[desiredCurrency.text!])")!
        let valueConverted = (desiredValue / defaultValue) * valueCurrency
        
        let alert = UIAlertController(title: "Converted", message: "\(valueConverted)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

