//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    var coinManager = CoinManager()
    
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
//        currencyLabel.text = coinManager.currencyArray[0]
//        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
        coinManager.delegate = self
    }
}

//MARK: CoinManagerDelegate
extension CoinViewController: CoinManagerDelegate {
    func didUpdateCourse(course: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = course
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithAction(error: Error) {
        print(error)
    }
}

//MARK: UIPickerViewDataSource
extension CoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
}

//MARK: UIPickerViewDelegate
extension CoinViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
