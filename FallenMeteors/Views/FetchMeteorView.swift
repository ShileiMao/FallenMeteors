//
//  FetchMeteorView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 03/10/2021.
//

import SwiftUI
import CoreData

/// Custom View object that access to the Coredata to fetch the Data, and display on the screen with the Content generator block
struct FetchMeteorView<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var fetchedResult: FetchedResults<T> { fetchRequest.wrappedValue }
    
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { item in
            self.content(item)
        }
    }
    
    /// Create the custom view that access to the Coredata to fetch and display objects
    /// - Parameters:
    ///   - fetchRequest: the custom fetch request to define specific set of the data that you are interested
    ///   - content: The Item View of the fetched object, you can customise this view by providing your own Conent block
    init(fetchRequest: FetchRequest<T>, @ViewBuilder content: @escaping (T) -> Content) {
        self.fetchRequest = fetchRequest
        self.content = content
    }
}
