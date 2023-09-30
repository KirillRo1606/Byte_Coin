//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Kirill Romanov on 2.10.22.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCourse(course: String, currency: String)
    func didFailWithAction(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=738B5988-C6A0-4011-B293-AC6AA41AC093"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithAction(error: error!)
                    return
                }
                if let safeData = data {
                    if let course = self.parseJSON(coinData: safeData) {
                        let courseString = String(format: "%.2f", course)
                        self.delegate?.didUpdateCourse(course: courseString, currency: currency)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSON(coinData: Data) -> Float? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let course = (decodedData.rate)
            return course
        } catch {
            self.delegate?.didFailWithAction(error: error)
            return nil
        }

    }
    
    
    
}
