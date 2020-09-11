
//  ViewController.swift
//  Stocks

import UIKit

class ViewController: UIViewController {
    
    private lazy var companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "Facebook": "FB"
    ]
    
    @IBOutlet weak var titleNavigationBar: UINavigationItem!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companySymbolLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    @IBOutlet weak var companyPickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameLabel.text = "-"
        
        titleNavigationBar.title = "Chosen stocks"
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        requestQuoteUpdate()
    }
    
    private func requestQuote(for symbol: String){
        
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else{
            DispatchQueue.main.async { [weak self] in
                self?.createCustomAlert(title: "Connection alert", message: "No connection available")
            }
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                self?.parseQuote(from: data)
            }
            else {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.createCustomAlert(title: "Data transmission error", message: "An error or denial of access was received")
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func requestImage(for symbol: String){
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=\(token)") else{
            DispatchQueue.main.async { [weak self] in
                self?.createCustomAlert(title: "ImageConnection alert", message: "No connection to image server")
            }
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url){ [weak self] (data, response, error) in
            if let data = data,
                (response as? HTTPURLResponse)?.statusCode == 200,
                error == nil {
                self?.parseImage(from: data)
            }
            else {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.createCustomAlert(title: "Image data transmission error", message: "An error or denial of access was received")
                }
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
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.createCustomAlert(title: "JSON parsing error", message: error.localizedDescription)
            }
        }
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
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.createCustomAlert(title: "JSON parsing error", message: error.localizedDescription)
            }
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
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.createCustomAlert(title: "Image download error", message: "An error or denial of access was received")
                }
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
            priceChangeLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
        activityIndicator.startAnimating()
        requestQuote(for: selectedSymbol)
        
    }
    
    private func createCustomAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Close", comment: "Close action"), style: .cancel, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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


