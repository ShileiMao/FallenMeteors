//
//  MeteorsView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 01/10/2021.
//

import SwiftUI
import FallenMeteorAPI

struct MeteorsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var meteorDataModel: MeteorDataModel = MeteorDataModel()
    
    @State var selectedSortIndex: Int = 0
    @State var isSortAsending: Bool = true
    
    @State var loadingOffset: Int = 0
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                /* search bar */
                HStack {
                    TextField.init("Enter Your search text", text: $searchText) { _ in
                        toggleSearch(searchText)
                    }
                }
                .padding()
                
                
                
                /* segmented toggle */
                Picker("Select your filt option", selection: $selectedSortIndex) {
                    Text("By Date").tag(0)
                    Text("By Mass").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(height: 40, alignment: .center)
                .onChange(of: selectedSortIndex) { newValue in
                    self.searchMeteors()
                }
                /* meteor list */
                List {
                    // pick up the list to dispaly depending on the search status
                    ForEach(searchText.isEmpty ? $meteorDataModel.meteors : $meteorDataModel.filtedMeteors, id: \.id) { meteor in
                        NavigationLink {
                            MeteorDetailsView(meteor: meteor.wrappedValue)
                                .environment(\.managedObjectContext, viewContext)
                        } label: {
                            MeteorRow(meteor: meteor.wrappedValue)
                        }
                    }
                    
                    // only show the loading more indicate while there is not searching
                    if searchText.isEmpty {
                        LoadingIndicatorView()
                            .onAppear {
                                searchMeteors(true)
                            }
                    }
                }
            }
            .navigationTitle("Meteors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: toggleSortAscending) {
                    Label("Add Favourite", systemImage: isSortAsending ? "arrow.up" : "arrow.down")
                }
                .accentColor(Color.blue)
            }
        }
    }
    
    func toggleSortAscending() {
        isSortAsending.toggle()
        
        searchMeteors()
    }
    
    func searchMeteors(_ append: Bool = false) {
        var sortBy: String = self.selectedSortIndex == 0 ? "year" : "mass"
        
        if !isSortAsending {
            sortBy.append(contentsOf: " DESC")
        }
        
        var searchFilter = MeteorSearchFilter()
        searchFilter.sortBy = sortBy
        
        meteorDataModel.searchMeteors(searchFilter, append: append)
    }
    
    func toggleSearch(_ text: String) {
        meteorDataModel.filtMeteors(text)
    }
}

struct MeteorsView_Previews: PreviewProvider {
    static var previews: some View {
        MeteorsView()
    }
}
