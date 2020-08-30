//
//  StocksCell.swift
//  Stocks
//
//  Created by Алексей on 29.08.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit
import Foundation

class StocksCell: UITableViewCell {

    var name : String?
    var symbol : String?
    var price : Double?
    var priceChange : Double?
    
    var nameView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var symbolView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceChangeView : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameView)
        self.addSubview(symbolView)
        self.addSubview(priceView)
        self.addSubview(priceChangeView)
        
        nameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        nameView.textAlignment = .center
        
        
        symbolView.leftAnchor.constraint(equalTo: self.nameView.rightAnchor).isActive = true
        symbolView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        symbolView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        symbolView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        symbolView.textAlignment = .center
        
        priceView.leftAnchor.constraint(equalTo: self.symbolView.rightAnchor).isActive = true
        priceView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        priceView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        priceView.textAlignment = .center
        
        priceChangeView.leftAnchor.constraint(equalTo: self.priceView.rightAnchor).isActive = true
        priceChangeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceChangeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        priceChangeView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        priceChangeView.textAlignment = .center
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let name = name {
            nameView.text = name
        }
        
        if let symbol = symbol {
            symbolView.text = symbol
        }
        
        if let price = price {
            priceView.text = "\(price)"
        }
        
        if let priceChange = priceChange{
            priceChangeView.text = "\(priceChange)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
