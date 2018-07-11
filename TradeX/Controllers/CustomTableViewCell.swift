//
//  CustomTableViewCell.swift
//  TradeX
//
//  Created by Kushal Ashok on 7/10/18.
//  Copyright © 2018 tradex. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var quoteAssetLabel: UILabel!
    @IBOutlet weak var baseAssetLabel: UILabel!
    @IBOutlet weak var volumenLabel: UILabel!
    @IBOutlet weak var decimalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
