//
//  RequestData.swift
//  Stocks
//
//  Created by Алексей on 11.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

class RequestData{
    
    init() {
        
    }
    
    public func requestQuote() {
        
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?listLimit=50&token=\(token)") else{
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                //self?.parseQuote(from: data)
                
            }
            else {
                DispatchQueue.main.async { [weak self] in
                    //self?.createCustomAlert(title: "Data transmission error", message: "An error or denial of access was received")
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    
}

