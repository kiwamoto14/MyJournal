//
//  DisplayTableView.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/16/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation
import UIKit
import CoreData //Test

class DisplayTableView: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var entryIndex: Int! // passes index to editVC
    var sectionIndex: Int!
    var cellContent = "" // passes text content to editVC
    var dateString = "" //date version (passed to editVC)
    var imageName = "" //passes mood image to editVC
    
    var fromCalendar: Bool = false //checks if switch came from calendar
    var indexPath: IndexPath! //index path if switch came from calendar
    var selectedDate: Date! //date if switch came from calendar
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationBar.title = "Entries"
        
        tableView.separatorColor = .clear
        
        setupButton()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        
        if fromCalendar == true {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }

        
        //bring addButton to the front
        view.bringSubviewToFront(addButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //reload screen every time
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //add button setup
    func setupButton() {
        addButton.backgroundColor = .lightGray
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.shadowOpacity = 0.25
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    //loading table after dismissing modal screen
    @IBAction func unwindToDisplayTableView(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension DisplayTableView: UITableViewDelegate {
    
    //transfers screens when cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentEntry = MonthSections[indexPath.section].entries[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        entryIndex = indexPath.row
        sectionIndex = indexPath.section
        cellContent = currentEntry.text
        dateString = formatter.string(from: currentEntry.date)
        
        switch currentEntry.mood {
        case .terrible: imageName = "Terrible"
        case .bad: imageName = "Bad"
        case .okay: imageName = "Okay"
        case .good: imageName = "Good"
        case .fantastic: imageName = "Fantastic"
        }
        
        performSegue(withIdentifier: "edit", sender: self)
    }
    
    //sends information to editViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is EditViewController {
            let editVC = segue.destination as! EditViewController
            editVC.entryIndex = self.entryIndex
            editVC.sectionIndex = self.sectionIndex
            editVC.cellText = self.cellContent
            editVC.dateText = self.dateString
            editVC.imageName = self.imageName
        }
    }
    
    //create delete button
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
                
                //alert popup
                let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
                
                //cancel option for alert
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                    actionPerformed(false)
                }))
                
                //delete option
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                    
                    //delete in organized array
                    EntryFunctions.deleteEntry(index: indexPath)
                    
                    //delete from tableview
                    tableView.deleteRows(at: [indexPath], with: .fade) 
                    
                    //delete section if entry count is 0 in that section
                    let indexToDelete = IndexSet.init(integer: indexPath.section)
                    if MonthSections[indexPath.section].entries.count == 0 {
                        EntryFunctions.deleteSection(index: indexPath)
                        tableView.deleteSections(indexToDelete, with: .automatic)
                        print("section deleted")
                    }
                    actionPerformed(true)
                    self.tableView.reloadData()
                }))
                self.present(alert, animated: true)
            }
            
            let swipeActions = UISwipeActionsConfiguration(actions: [delete])
            
            delete.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
            return swipeActions
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension DisplayTableView: UITableViewDataSource {
    
    //specify number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = MonthSections[section]

        return section.entries.count
    }
    
    //specify what is shown on each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EntriesTableViewCell
        
        let entry = MonthSections[indexPath.section].entries[indexPath.row]
        
//        cell.textLabel?.text = entry.text
//        cell.detailTextLabel?.text = formatter.string(from: entry.date)
        
        cell.setup(entry: entry)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if MonthSections.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Entries"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
        }
        else {
            self.tableView.backgroundView = .none
        }
        return MonthSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = MonthSections[section]
        let date = section.month
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
}
