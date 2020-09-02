//
//  Headlines.swift
//  MyJournal
//
//  Created by Kazushi Iwamoto on 6/21/20.
//  Copyright © 2020 Kazushi Iwamoto. All rights reserved.
//

import Foundation

struct Entry: Comparable {
    //represents each entry
    var id: UUID
    var date: Date
    var text: String
    var mood: MoodType
    var activities: [Activities]
    
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.date > rhs.date
    }
}

struct MonthSection: Comparable {
    //organized headlines by month
    var month: Date
    var entries: [Entry]
    
    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month > rhs.month
    }
    
    static func == (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month == rhs.month
    }
}
