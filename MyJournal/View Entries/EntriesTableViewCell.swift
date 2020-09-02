//
//  EntriesTableViewCell.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/22/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit

class EntriesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var CellView: UIView!
    @IBOutlet weak var TextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CellView.layer.shadowOpacity = 1
        CellView.layer.shadowOffset = CGSize.zero
        CellView.layer.shadowColor = UIColor.lightGray.cgColor
        CellView.layer.cornerRadius = 10
    }
    
    func setup(entry: Entry) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        TextLabel.text = entry.text
        dateLabel.text = formatter.string(from: entry.date)
        formatter.dateFormat = "E"
        weekDayLabel.text = formatter.string(from: entry.date)
        
        switch entry.mood {
        case .terrible:
            moodImage.image = UIImage(imageLiteralResourceName: "Terrible")
        case .bad:
            moodImage.image = UIImage(imageLiteralResourceName: "Bad")
        case .okay:
            moodImage.image = UIImage(imageLiteralResourceName: "Okay")
        case .good:
            moodImage.image = UIImage(imageLiteralResourceName: "Good")
        case .fantastic:
            moodImage.image = UIImage(imageLiteralResourceName: "Fantastic")
        }
    }

}
