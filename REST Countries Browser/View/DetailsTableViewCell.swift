//
//  DetailsTableViewCell.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 08/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpCell(_ detail : (String, String)) {
        detailLabel.text = detail.0
        detailValue.text = detail.1
        self.backgroundColor = MyPalette.background
        self.setCellSelectionColour(MyPalette.selectedItem)
        detailLabel.textColor = MyPalette.baseText
        detailValue.textColor = MyPalette.baseText
    }
    
}
