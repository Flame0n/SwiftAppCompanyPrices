//
//  CustomCell.swift
//  Stocks
//
//  Created by Алексей on 29.08.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell{
    
    var name : String?
    var symbol : String?
    var price : Double?
    var priceChange : Double?
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var symbolView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var priceView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var priceChangeView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameView)
        self.addSubview(symbolView)
        self.addSubview(priceView)
        self.addSubview(priceChangeView)
        
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
