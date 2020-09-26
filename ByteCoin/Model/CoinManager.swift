//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    //Create the method stubs wihtout implementation in the protocol.
    //It's usually a good idea to also pass along a reference to the current class.
    //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    //Check the Clima module for more info on this.
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "60059FDD-7072-4F62-BD9D-0DC82EFC6668"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(currency: String) {
            
            let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

            if let url = URL(string: urlString) {
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!);
                        return
                    }
                    
                    if let safeData = data {
                        let bitcoinPrice = self.parseJSON(safeData)
                        
                        let priceString = String(format: "%.2f", bitcoinPrice as! CVarArg)
                        
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                    
                }
                task.resume()
            }
        }
        
        func parseJSON(_ data: Data) -> Double? {
            
            //Create a JSONDecoder
            let decoder = JSONDecoder()
            do {
                
                //try to decode the data using the CoinData structure
                let decodedData = try decoder.decode(CoinData.self, from: data)
                
                //Get the last property from the decoded data.
                let lastPrice = decodedData.rate;
                return lastPrice;
                
            } catch {
                
                //Catch and print any errors.
                self.delegate?.didFailWithError(error: error);
                return nil
            }
        }
}
