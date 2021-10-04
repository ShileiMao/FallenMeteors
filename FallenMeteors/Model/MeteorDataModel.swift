//
//  MeteorDataModel.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 04/10/2021.
//

import Foundation
import SwiftUI
import FallenMeteorAPI

/// The Model object to search and filt the Meteors on the screen
class MeteorDataModel: ObservableObject {
    
    /// This is all the available Meteors that searched from NASA website
    @Published var meteors: [Meteor] = []
    
    /// This array stores all the filtered Meteors when user did search
    @Published var filtedMeteors: [Meteor] = []
    
    
    /// A boolean indicator to tell if the app is working background to load more data
    @Published var isLoading: Bool = false
    
    @Published var isErrorLoading: Bool = false
    
    init() {
        
    }
    
    init(_ meteors: [Meteor]) {
        self.meteors = meteors
    }
    
    /// Search meteors by Keyword, this supports to search by Meteor name, year and mass
    /// - Parameter byText: The search text that user entered
    func filtMeteors(_ byText: String) {
        if byText.isEmpty {
            return
        }
        
        // modify this logic if you want to apply different search rules
        filtedMeteors = meteors.filter { meteor in
            if meteor.name?.uppercased().contains(byText.uppercased()) == true ||
                meteor.year?.contains(byText) == true ||
                meteor.mass?.contains(byText) == true {
                return true
            }
            return false
        }
        
        print("filter changed")
    }
    
    /// Search the Meteors information from NASA website
    /// - Parameters:
    ///   - searchFilter: The filt conditions to search the specific meteors
    ///   - append: if true, then all the search result will be append to the `meters` array, this can use to paging Meteors. Or if you provide false, it will remove all the previous records
    func searchMeteors(_ searchFilter: MeteorSearchFilter, append: Bool = false) {
        if isLoading {
            return
        }
        
        var newFilter = searchFilter
        
        if append {
            // we need provide the offset of the Meteors, otherwise we will keep loading the old meteors
            newFilter.setOffset(meteors.count)
        }
        
        let loader = NetMeteorLoader(apiPath: AppConfigs.API_PATH, appToken: AppConfigs.API_TOKEN)
        
        let listener: HttpRequestListener<[Meteor]> = HttpRequestListener<[Meteor]> { request in
            print("Started")
            self.isLoading = true
            self.isErrorLoading = false
        } finished: { request, data in
            if append {
                self.meteors.append(contentsOf: data ?? [])
            } else {
                self.meteors = data ?? []
            }
        } error: { request, error in
            print("error: \(error)")
            self.isLoading = false
            self.isErrorLoading = true
        } canceled: { request in
            print("Canceled")
            self.isLoading = false
        }
        
        loader.loadMeteors(searchFilter: newFilter, listener: listener)
    }
}
