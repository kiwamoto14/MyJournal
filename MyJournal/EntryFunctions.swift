//
//  DataFunctions.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/20/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation

func getMonth(date: Date) -> Date {
     let calendar = Calendar.current
     let components = calendar.dateComponents([.year, .month], from: date)
     return calendar.date(from: components)!
 }

var MonthSections = [MonthSection]() //array of each section separated by months

class EntryFunctions {
    
    static func retrieveEntry(date: Date) -> IndexPath? {
        let month = getMonth(date: date)
        var indexPath: IndexPath!
        for x in 0..<MonthSections.count {
            if (MonthSections[x].month == month) {
                for i in 0..<MonthSections[x].entries.count {
                    if (MonthSections[x].entries[i].date == date) {
                        indexPath = IndexPath(row: i, section: x)
                    }
                }
            }
        }
        return indexPath
    }
    
    static func deleteSection(index: IndexPath) {
        if MonthSections[index.section].entries.count == 0 {
            MonthSections.remove(at: index.section)
        }
        else {
            print("Failed to delete: remaining entries found")
        }
    }
    static func deleteEntry(index: IndexPath) {
        MonthSections[index.section].entries.remove(at: index.row)
    }
    
    static func addEntry(entry: Entry) {
        let month = getMonth(date: entry.date)
        var foundMonth: Bool = false
        if MonthSections.count == 0 {
            MonthSections.append(MonthSection.init(month: month, entries: [entry]))
        }
        else {
            for x in 0..<MonthSections.count {
                if (MonthSections[x].month == month) {
                    MonthSections[x].entries.append(entry)
                    foundMonth = true
                    MonthSections[x].entries.sort()
                }
            }
            if (foundMonth == false) {
                MonthSections.append(MonthSection.init(month: month, entries: [entry]))
            }
        }
    }
    
}

