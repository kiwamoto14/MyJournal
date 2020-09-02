//
//  CalendarViewController.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/13/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectedDate: Date!
    var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        
        navigationBar.title = "Calendar"

        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .blue
        calendar.appearance.eventDefaultColor = .green
        //calendar.appearance.todayColor = .
        
        //make selection color clear
        calendar.appearance.selectionColor = .clear
        calendar.appearance.titleSelectionColor = calendar.appearance.titleDefaultColor
        calendar.appearance.subtitleSelectionColor = calendar.appearance.subtitleDefaultColor
        
        
        view.bringSubviewToFront(addButton)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        indexPath = EntryFunctions.retrieveEntry(date: date)
        if indexPath == nil {
            //instantiate alert
            let alert = UIAlertController(title: "No Entry", message: "You have not added an entry for this date", preferredStyle: .alert)
            
            //present alert
            self.present(alert, animated: true)
            
            // delays execution of code to dismiss
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
              alert.dismiss(animated: true, completion: nil)
            })
        }
        else {
            performSegue(withIdentifier: "ViewEntries", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DisplayTableView {
            let vc = segue.destination as! DisplayTableView

            vc.indexPath = self.indexPath
            vc.fromCalendar = true
        }
    }
    
    func setupButton() {
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        for x in 0..<MonthSections.count {
            for y in 0..<MonthSections[x].entries.count {
                if MonthSections[x].entries[y].date == date {
                    return 1
                }
            }
        }
        return 0
    }
    
    
}
