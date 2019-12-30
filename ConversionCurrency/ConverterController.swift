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
    @IBOutlet weak var btnConvert: UIButton!
    @IBOutlet weak var btnHistoric: UIButton!
    
    var keys = Array<String>()
    var values = Array<String>()
    var thePicker = UIPickerView()
    var jsonRes = JSON()
    var valuesConverted = Array<String>()
    var currencyBase = Array<String>()
    var currencyToConvert = Array<String>()
    var valueToConvert = Array<String>()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        requestApi()
        picker()
        toolbar()
        layoutBtns()
    }
    
    func layoutBtns() {
        btnConvert.layer.cornerRadius = 4
        btnHistoric.layer.cornerRadius = 4
    }
    
    func picker() {
        currencyType.inputView = thePicker
        desiredCurrency.inputView = thePicker
        thePicker.delegate = self
    }
    
    func toolbar() {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: #selector(cancelClick))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        currencyType.inputAccessoryView = toolBar
        desiredCurrency.inputAccessoryView = toolBar
        valueOfCurrency.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        currencyType.resignFirstResponder()
        desiredCurrency.resignFirstResponder()
        valueOfCurrency.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        currencyType.resignFirstResponder()
        desiredCurrency.resignFirstResponder()
        valueOfCurrency.resignFirstResponder()
    }
    
    func requestApi() {
        let request = Alamofire.request("https://api.exchangeratesapi.io/latest")
        request.responseJSON { (response) in
            
            switch response.result {
            case .success:
                
                self.removeSpinner()
                
                let jsonString = String(data: response.data!, encoding: .utf8)!
                let jsonData = jsonString.data(using: .utf8)!
                
                do {
                    let res = try JSONDecoder().decode(Root.self, from: jsonData)
                    self.jsonRes = res.rates
                    
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
        }
    }
    
    @IBAction func historic(_ sender: Any) {
        
        if defaults.array(forKey: "valuesConverted") as? Array<String> != nil && defaults.array(forKey: "currencyBase") as? Array<String> != nil && defaults.array(forKey: "currencyToConvert") as? Array<String> != nil && defaults.array(forKey: "valueToConvert") as? Array<String> != nil {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "historicNav") as! UINavigationController
            self.show(controller, sender: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "You haven't conversion history", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func convert(sender: UIButton){
        
        if currencyType.text != "" && desiredCurrency.text != "" && valueOfCurrency.text != "" {
            
            let defaultValue = Double("\(jsonRes[currencyType.text!])")!
            let defaultCurrency = Double("\(valueOfCurrency.text!)")!
            
            let desiredValue = Double("\(jsonRes[desiredCurrency.text!])")!
            let valueConverted = (desiredValue / defaultValue) * defaultCurrency
            
            valuesConverted.append("\(valueConverted)")
            currencyBase.append("\(currencyType.text!)")
            currencyToConvert.append("\(desiredCurrency.text!)")
            valueToConvert.append("\(valueOfCurrency.text!)")
            
            if defaults.array(forKey: "valuesConverted") as? Array<String> != nil && defaults.array(forKey: "currencyBase") as? Array<String> != nil && defaults.array(forKey: "currencyToConvert") as? Array<String> != nil && defaults.array(forKey: "valueToConvert") as? Array<String> != nil {
            
                let arr1 =  defaults.array(forKey: "valuesConverted") as! Array<String>
                let arr2 = defaults.array(forKey: "currencyBase") as! Array<String>
                let arr3 = defaults.array(forKey: "currencyToConvert") as! Array<String>
                let arr4 = defaults.array(forKey: "valueToConvert") as! Array<String>
                
                valuesConverted.append(contentsOf: arr1)
                currencyBase.append(contentsOf: arr2)
                currencyToConvert.append(contentsOf: arr3)
                valueToConvert.append(contentsOf: arr4)
                
            }
            
            //  Local Storage
            defaults.set(currencyBase, forKey: "currencyBase")
            defaults.set(currencyToConvert, forKey: "currencyToConvert")
            defaults.set(valuesConverted, forKey: "valuesConverted")
            defaults.set(valueToConvert, forKey: "valueToConvert")
            
            let alert = UIAlertController(title: "\(currencyType.text!) to \(desiredCurrency.text!)", message: "\(valueOfCurrency.text!) \(currencyType.text!) = \(valueConverted) \(desiredCurrency.text!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Alert", message: "The above fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

var vSpinner : UIView?
extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
