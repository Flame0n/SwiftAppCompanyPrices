//
//  TableViewController.swift
//  Stocks
//
//  Created by Алексей on 29.08.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

struct CellData{
    var companyName : String?
    var companySymbol : String?
    var companyStockPrice : Double?
    var companyStockPriceChange : Double?
}

class TableViewController: UITableViewController {

    @IBOutlet weak var tableNavItem: UINavigationItem!
    
    var data = [CellData]()
    
    var indexCounter = 0
    
    override func viewDidLoad() {
        
        requestQuote()
        
        super.viewDidLoad()
        
        self.tableView.register(StocksCell.self, forCellReuseIdentifier: "custom")
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.separatorStyle = .none
        
        tableNavItem.title = "List of most active companies"
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! StocksCell
        cell.name = data[indexPath.row].companyName
        cell.symbol = data[indexPath.row].companySymbol
        cell.price = data[indexPath.row].companyStockPrice
        cell.priceChange = data[indexPath.row].companyStockPriceChange
        
        if indexCounter % 2 != 0{
            cell.backgroundColor = #colorLiteral(red: 0.6296653072, green: 0.8128914948, blue: 0.9851326346, alpha: 1)
            indexCounter += 1
        } else{
            indexCounter += 1
        }
        
        if let change = cell.priceChange{
            if change > 0.0{
                cell.priceChangeView.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            } else if change < 0.0{
                cell.priceChangeView.textColor = .red
            }
        }
        
        return cell
    }
    
    private func requestQuote(){
        
        let token = "pk_fe9073a60e1e4b95aef88171909d8290"
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=\(token)") else{
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
    
    private func parseQuote(from data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [Any]
                
                /*let priceChange = json["change"] as? Double*/ else { return print("Invalid JSON")}
                
            for element in json{
                
                if let el = element as? [String: Any]{
                    
                    if let companyName = el["companyName"] as? String,
                        let companySymbol = el["symbol"] as? String,
                        let price = el["latestPrice"] as? Double,
                        let priceChange = el["change"] as? Double{
                        self.data.append(CellData.init(companyName: companyName,
                        companySymbol: companySymbol,
                        companyStockPrice: price,
                        companyStockPriceChange: priceChange))
                        DispatchQueue.main.async { [weak self] in
                            self?.refreshTable()
                        }
                    }else{
                        print("incrorrect JSON")
                    }
                }
            }
            
            print(self.data)
            
            
        } catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func refreshTable(){
        self.indexCounter = 0
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

}
