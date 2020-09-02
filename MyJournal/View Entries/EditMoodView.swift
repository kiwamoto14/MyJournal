//
//  EditMoodView.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 7/2/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation
import UIKit

class EditMoodView: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet var moodButtons: [UIButton]!
    
    var mood: MoodType! //inherited from editVC
    var entryIndex: Int!
    var sectionIndex: Int!
    
    var instanceOfEditVC: EditViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.shadowOpacity = 0.25
        popupView.layer.shadowRadius = 5
        popupView.layer.shadowOffset = (CGSize(width: 0, height: 10))
        
        highlightSelectedMood()
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        MonthSections[sectionIndex].entries[entryIndex].mood = mood
        instanceOfEditVC.setupActivities()
        instanceOfEditVC.setupMood()
        self.performSegue(withIdentifier: "loadEditVC", sender: self)
    }
    
    @IBAction func moodTypeSelected(_ sender: UIButton) {
        moodButtons.forEach {(button) in
            if button == sender {
                sender.tintColor = .orange
                mood = MoodType.allCases[sender.tag]
            }
            else {
                button.tintColor = .systemBlue
            }
        }
    }
    
    func highlightSelectedMood() {
        switch mood! {
        case .terrible:
            moodButtons[0].tintColor = .orange
        case .bad:
            moodButtons[1].tintColor = .orange
        case .okay:
            moodButtons[2].tintColor = .orange
        case .good:
            moodButtons[3].tintColor = .orange
        case .fantastic:
            moodButtons[4].tintColor = .orange
        }
    }
}
