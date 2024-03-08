//
//  ItemsViewModel.swift
//  Fetch_TakeHome_Assignment
//
//  Created by Rohit Manivel on 3/7/24.
//

import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var itemsByListId: [Int: [Item]] = [:]
    @Published var filteredItemsByListId: [Int: [Item]] = [:]
        @Published var activeListId: Int? = nil {
            didSet { filterItems() }
        }
    @Published var isFetched = false
    private var networkFetch = NetworkFetch()
    
    init(){
        fetchItems()
    }
    
    func fetchItems() {
        networkFetch.fetchItems { [weak self] result in
            DispatchQueue.main.async {
                self?.isFetched = true
                switch result {
                case .success(let items):
                    let filteredItems = items.filter { item in
                        guard let itemName = item.name else { return false }
                        return !itemName.isEmpty
                    }
                    
                    let sortedItems = filteredItems.sorted { firstItem, secondItem in
                        if firstItem.listId != secondItem.listId {
                            return firstItem.listId < secondItem.listId
                        }
                        else{
                            let firstNumber = firstItem.name?.extractNumber() ?? 0
                            let SecondNumber = secondItem.name?.extractNumber() ?? 0
                            return firstNumber < SecondNumber
                        }
                    }
                    
                    self?.itemsByListId = Dictionary(grouping: sortedItems, by: { $0.listId })
                    self?.filterItems()
                    
                case .failure(let error):
                    print("Error fetching items: \(error)")
                }
            }
        }
    }
    
    func filterItems() {
            if let activeListId = activeListId {
                filteredItemsByListId = [activeListId: itemsByListId[activeListId, default: []]]
            } else {
                filteredItemsByListId = itemsByListId 
            }
    }
}
extension String {
    func extractNumber() -> Int {
        let numbers = self.compactMap { $0.wholeNumberValue }
        return numbers.reduce(0) { $0 * 10 + $1 }
    }
}

