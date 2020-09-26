//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self;
        currencyPicker.delegate = self;
        coinManager.delegate = self;
    }
}



//MARK: - UIPickerViewDataSource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{

    //number of column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count;
    }
    
    //delegate method for renderin currencies in array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row];
    }
    
    //method checks if any row selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row];
        coinManager.getCoinPrice(currency: selectedCurrency);
    }
}


//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    
    func didUpdatePrice(price: String, currency: String) {
            
        //Remember that we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        //try to do this from a background thread (URLSession works in the background).
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error);
    }
}

