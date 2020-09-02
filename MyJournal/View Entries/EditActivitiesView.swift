//
//  EditActivitiesView.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 7/3/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation
import UIKit

class EditActivitiesView: UIViewController {
    
    @IBOutlet var activityButtons: [UIButton]!
    @IBOutlet weak var popupView: UIView!
    
    var activities: [Activities]! //inherited from editVC
    var entryIndex: Int! //inherited from editVC
    var sectionIndex: Int! //inherited from editVC
    
    var selectedCounter = 0
    
    var instanceOfEditVC: EditViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.shadowOpacity = 0.25
        popupView.layer.shadowRadius = 5
        popupView.layer.shadowOffset = (CGSize(width: 0, height: 10))
        
        selectedCounter = activities.count
        
        highlightSelectedActivities()
        
        
        
    }
    
    @IBAction func save(_ sender: Any) {
        //add selected buttons to activity array
        activities.removeAll()
        for button in activityButtons {
            if button.isSelected == true {
                activities.append(Activities.allCases[button.tag])
            }
        }
        //save new activity array to MonthSection struct
        MonthSections[sectionIndex].entries[entryIndex].activities = activities
        instanceOfEditVC.setupActivities()
        instanceOfEditVC.setupMood()
        self.performSegue(withIdentifier: "loadEditVC", sender: self)
    }
    
    @IBAction func activitiesSelected(_ sender: UIButton) {
        //change button state and color (max selection is 8)
        if (sender.isSelected == false) && (selectedCounter < 8) {
            sender.tintColor = .orange
            sender.isSelected = true
            selectedCounter += 1
        }
        else if (sender.isSelected == true) {
            sender.tintColor = .systemBlue
            sender.isSelected = false
            selectedCounter -= 1
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func highlightSelectedActivities() {
        for x in 0..<activities.count {
            switch activities[x] {
            case .eating:
                activityButtons[0].tintColor = .orange
                activityButtons[0].isSelected = true
            case .vacation:
                activityButtons[1].tintColor = .orange
                activityButtons[1].isSelected = true
            case .driving:
                activityButtons[2].tintColor = .orange
                activityButtons[2].isSelected = true
            case .sports:
                activityButtons[3].tintColor = .orange
                activityButtons[3].isSelected = true
            case .work:
                activityButtons[4].tintColor = .orange
                activityButtons[4].isSelected = true
            case .school:
                activityButtons[5].tintColor = .orange
                activityButtons[5].isSelected = true
            case .friends:
                activityButtons[6].tintColor = .orange
                activityButtons[6].isSelected = true
            case .family:
                activityButtons[7].tintColor = .orange
                activityButtons[7].isSelected = true
            case .relationship:
                activityButtons[8].tintColor = .orange
                activityButtons[8].isSelected = true
            case .hobbies:
                activityButtons[9].tintColor = .orange
                activityButtons[9].isSelected = true
            case .swimming:
                activityButtons[10].tintColor = .orange
                activityButtons[10].isSelected = true
            case .exercise:
                activityButtons[11].tintColor = .orange
                activityButtons[11].isSelected = true
            case .shopping:
                activityButtons[12].tintColor = .orange
                activityButtons[12].isSelected = true
            case .relaxing:
                activityButtons[13].tintColor = .orange
                activityButtons[13].isSelected = true
            case .doctor:
                activityButtons[14].tintColor = .orange
                activityButtons[14].isSelected = true
            }
        }
    }
}
