//
//  HeroesViewController.swift
//  TheBreakingBad
//
//  Created by Никита Гуляев on 02.01.2022.
//

import UIKit

class HeroesViewController: UIViewController {
    
    @IBOutlet weak var heroImage: CharacterImage!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroNickName: UILabel!
    @IBOutlet weak var heroBirthday: UILabel!
    @IBOutlet weak var heroOccupation: UILabel!
    @IBOutlet weak var heroStatus: UILabel!
        
    var urlImage = ""
    var name = ""
    var nickName = ""
    var birthday = ""
    var occupation = ""
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroImage.fetchImage(from: urlImage)
        heroName.text = name
        heroNickName.text = nickName
        heroBirthday.text = birthday
        heroOccupation.text = occupation
        heroStatus.text = status

    }

}
