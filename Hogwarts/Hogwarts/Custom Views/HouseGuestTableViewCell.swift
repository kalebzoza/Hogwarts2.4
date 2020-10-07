//
//  HouseGuestTableViewCell.swift
//  Hogwarts
//
//  Created by Kaleb  Carrizoza on 9/17/20.
//  Copyright © 2020 Kaleb  Carrizoza. All rights reserved.
//

import UIKit

//MARK: - protocols
protocol HouseGuestTableViewCellDelegate: AnyObject {
    func houseButtonTapped(cell: HouseGuestTableViewCell)
}

class HouseGuestTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var personGuestLabel: UILabel!
    @IBOutlet weak var houseImageButton: UIButton!
    
    
    //MARK: - Properties
    var guess: HouseGuest? {
      //observes the property it is on
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: HouseGuestTableViewCellDelegate?
    
    
    //MARK: - Actions
    @IBAction func houseButtonTapped(_ sender: Any) {
        delegate?.houseButtonTapped(cell: self)
    }
    
    //MARK: - Hepler Methods
    func  updateViews() {
        guard let guess = guess else {return}
        
        personGuestLabel.text = guess.guestName
        updateButtonFor(guest: guess)
    }
    
    func updateButtonFor(guest: HouseGuest) {
        if guest.isVisible {
            if let house = guest.house{
                houseImageButton.setImage(UIImage(named: house), for: .normal)
            }
        }else {
            houseImageButton.setImage(#imageLiteral(resourceName: "hogwarts"), for: .normal)
            //image literals for image above
        }
    }

    
    
}//end of class
