//
//  TableViewController.swift
//  Stocks
//
//  Created by Алексей on 29.08.2020.

import UIKit


class TableViewController: UITableViewController {

    @IBOutlet weak var tableNavItem: UINavigationItem!
    
    var data = [CellData]()
    
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
        
        
        cell.cellData = data[indexPath.row]
        
        guard let bufData = cell.cellData else  {
            return cell
        }
        
        if indexPath.row % 2 == 1{
            cell.backgroundColor = #colorLiteral(red: 0.6296653072, green: 0.8128914948, blue: 0.9851326346, alpha: 1)
        } else{
            cell.backgroundColor = .white
        }
        
        if let change = bufData.priceChange{
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
        
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?listLimit=50&token=\(token)") else{
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
                    self?.createCustomAlert(title: "Data transmission error", message: "An error or denial of access was received")
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func parseQuote(from data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [Any] else {
                    return DispatchQueue.main.async { [weak self] in
                        self?.createCustomAlert(title: "JSON parsing error", message: "Wrong collection type")
                    }
            }
                
            for element in json{
                
                if let el = element as? [String: Any]{
                    
                    if let companyName = el["companyName"] as? String,
                        let companySymbol = el["symbol"] as? String,
                        let price = el["latestPrice"] as? Double,
                        let priceChange = el["change"] as? Double{
                        
                        self.data.append(CellData.init(name: companyName,
                            symbol: companySymbol,
                            price: price,
                            priceChange: priceChange))
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.refreshTable()
                        }
                    }else{
                        DispatchQueue.main.async { [weak self] in
                            self?.createCustomAlert(title: "JSON parsing error", message: "Wrong type of some elemet/elements")
                        }
                    }
                }else{
                    DispatchQueue.main.async { [weak self] in
                        self?.createCustomAlert(title: "JSON parsing error", message: "Wrong collection type")
                    }
                }
            }
        } catch{
            DispatchQueue.main.async { [weak self] in
                self?.createCustomAlert(title: "JSON parsing error", message: error.localizedDescription)
            }
        }
    }
    
    private func refreshTable(){
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
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
