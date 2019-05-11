//
//  CountryCell.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 06/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nativeNameLabel: UILabel!
    
    func setUpCell(for country : CountryHeader) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
        self.backgroundColor = MyPalette.background
        self.setCellSelectionColour(MyPalette.selectedItem)
        nameLabel.textColor = MyPalette.orangeText
        nativeNameLabel.textColor = MyPalette.orangeText
    }
}
