//
//  PersonsCollectionViewCell.swift
//  IceAndFire
//
//  Created by Никита Гуляев on 29.12.2021.
//

import UIKit

class PersonsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var personImage: CharacterImage!
    @IBOutlet weak var personName: UILabel!
    
    static let reuseId = "PersonsID"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        personImage.image = nil
        personName.text = nil
    }
}
