//
//  Item.swift
//  Fetch_TakeHome_Assignment
//
//  Created by Rohit Manivel on 3/7/24.
//

import Foundation

struct Item: Identifiable, Decodable{
    let id : Int
    let listId : Int
    let name : String?
    
    var identifiableId: Int{
        return id
    }
}
