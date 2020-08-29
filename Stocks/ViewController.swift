//
//  ViewController.swift
//  Stocks
//
//  Created by Алексей on 28.08.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "Facebook": "FB"
    ]
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companySymbolLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    @IBOutlet weak var companyPickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameLabel.text = "Tinkoff"
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        requestQuoteUpdate()
    }
    
    private func requestQuote(for symbol: String){
        
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else{
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                self?.parseQuote(from: data)
            }
            else {
                print("Network error!")
            }
        }
        
        dataTask.resume()
    }
    
    private func requestImage(for symbol: String){
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=\(token)") else{
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                self?.parseImage(from: data)
            }
            else {
                print("Network error!")
            }
        }
        
        dataTask.resume()
    }
    
    private func parseImage(from data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let url = json["url"] as? String
                else { return print("Invalid JSON")}
            self.displayImage(url: url)
            
            
        } catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    
    private func displayImage(url: String){
        guard let url = URL(string: url) else{
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                
                DispatchQueue.main.async { [weak self] in
                    self?.companyImageView.image = UIImage(data: data)
                }
                
            }
            else {
                print("Image download error!")
            }
        }
        
        dataTask.resume()
    }
    
    private func parseQuote(from data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double else { return print("Invalid JSON")}
            
            
            DispatchQueue.main.async { [weak self] in
                self?.displayStockInfo(companyName, companySymbol, price, priceChange)
            }
            
        } catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func getCompanyList(){
        
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/quote?token=\(token)") else{
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                self?.parseQuote(from: data)
            }
            else {
                print("Network error!")
            }
        }
        
        dataTask.resume()
    }
    
    private func displayStockInfo(_ companyName: String, _ companySymbol: String, _ price: Double, _ priceChange: Double){
        activityIndicator.stopAnimating()
        companyNameLabel.text = companyName
        companySymbolLabel.text = companySymbol
        priceLabel.text = "\(price)"
        priceChangeLabel.text = "\(priceChange)"
        
        if priceChange > 0{
            priceChangeLabel.textColor = .green
        }else if priceChange < 0 {
            priceChangeLabel.textColor = .red
        }
        
    }
    
    private func requestQuoteUpdate(){
        activityIndicator.startAnimating()
        companyNameLabel.text = "-"
        companySymbolLabel.text = "-"
        priceLabel.text = "-"
        priceChangeLabel.text = "-"
        priceChangeLabel.textColor = .black
        companyImageView.image = nil
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(companies.values)[selectedRow]
        
        requestImage(for: selectedSymbol)
        requestQuote(for: selectedSymbol)
        
    }
    
}

extension ViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.keys.count
    }
    
}


extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestQuoteUpdate()
    }
}


