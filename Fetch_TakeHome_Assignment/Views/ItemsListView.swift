//
//  ItemsListView.swift
//  Fetch_TakeHome_Assignment
//
//  Created by Rohit Manivel on 3/7/24.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject var viewModel = ItemsViewModel()
    
    var displayTitle: String {
        viewModel.activeListId.map { "Items in List \($0)" } ?? "All Items"
    }
    
    var body: some View {
        NavigationView {
            
            if(viewModel.isFetched == false){
                VStack(spacing : 24){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    
                    Text("Fetching Items...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            else{
                
                List {
                    ForEach(viewModel.filteredItemsByListId.keys.sorted(), id: \.self) { listId in
                        if let items = viewModel.filteredItemsByListId[listId] {
                            Section(header: Text("List \(listId)")) {
                                ForEach(items) { item in
                                    Text(item.name ?? "Unnamed Item")
                                }
                            }
                        }
                    }
                }
                .navigationTitle(displayTitle)
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Text("Filter")
                            Picker("Filter", selection: $viewModel.activeListId) {
                                Text("All").tag(Int?.none)
                                ForEach(viewModel.itemsByListId.keys.sorted(), id: \.self) { listId in
                                    Text("\(listId)").tag(Int?.some(listId))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                }
                .onAppear {
                    if viewModel.activeListId == nil {
                        viewModel.activeListId = .none
                    }
                    viewModel.fetchItems()
                }
            }
        }
    }
}

