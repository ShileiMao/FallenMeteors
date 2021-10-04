//
//  FavouritesView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 01/10/2021.
//

import SwiftUI
import CoreData
import FallenMeteorAPI

struct FavouritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var acending: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                let fetchRequest = FetchRequest<FavouriteMeteor>(sortDescriptors: [NSSortDescriptor(keyPath: \FavouriteMeteor.year, ascending: true)], predicate: NSPredicate(format: "favourite = true"), animation: .default)
                
                FetchMeteorView(fetchRequest: fetchRequest) { (item: FavouriteMeteor) in
                    NavigationLink {
                        MeteorDetailsView(meteor: toMeteor(item))
                            .environment(\.managedObjectContext, viewContext)
                    } label: {
                        MeteorRow(meteor: self.toMeteor(item))
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.yellow)
            .environment(\.managedObjectContext, viewContext)
        }
    }
    
    func toMeteor(_ favoriteMeteor: FavouriteMeteor) -> Meteor {
        Meteor(name: favoriteMeteor.name ?? "", id: favoriteMeteor.id ?? "", year: favoriteMeteor.year?.toString(AppConfigs.METEOR_DATE_FORMAT) ?? "", mass: favoriteMeteor.mass ?? "0")
    }
    
    
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
