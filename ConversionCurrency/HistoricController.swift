//
//  HistoricController.swift
//  ConversionCurrency
//
//  Created by Melies Kubrick on 29/12/19.
//  Copyright © 2019 Melies. All rights reserved.
//

import UIKit

class HistoricController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewHistoric: UITableView!
    let defaults = UserDefaults.standard
    var valuesConverted = Array<String>()
    var currencyBase = Array<String>()
    var currencyToConvert = Array<String>()
    var valueToConvert = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        valuesConverted =  defaults.array(forKey: "valuesConverted") as! Array<String>
        currencyBase = defaults.array(forKey: "currencyBase") as! Array<String>
        currencyToConvert = defaults.array(forKey: "currencyToConvert") as! Array<String>
        valueToConvert = defaults.array(forKey: "valueToConvert") as! Array<String>
        
        let newBtn = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn
    }
    
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valuesConverted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoricCell
        
        cell.title.text = "\(currencyBase[indexPath.row]) to \(currencyToConvert[indexPath.row])"
        cell.subtitle.text = "\(valueToConvert[indexPath.row]) \(currencyBase[indexPath.row]) = \(valuesConverted[indexPath.row]) \(currencyToConvert[indexPath.row])"
        
        return cell
    }
    
}
