//
//  DataManager.swift
//  AlphavantageIos
//
//  Created by Kevin Kho on 25/10/20.
//

import Foundation

struct DataManager {
    let dataURL = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=demo"
    
    func fetchIntraday(cityName: String){
        let urlString = "\(dataURL)"
    }
}
