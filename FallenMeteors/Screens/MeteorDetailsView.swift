//
//  MeteorDetailsView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 03/10/2021.
//

import SwiftUI
import FallenMeteorAPI
import MapKit
import CoreData

struct MeteorDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var isFavourite: Bool = false
    
    @ObservedObject var meteorDataModel: MeteorDataModel
    var meteor: Meteor
    
    init(meteor: Meteor) {
        self.meteor = meteor
        self.meteorDataModel = MeteorDataModel([meteor])
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let meteor = meteorDataModel.meteors.first {
                    MapView(showInLocation: nil, markLocations: getAnnotation(meter: meteor))
                        .onAppear {
                            searchMeteorDetails(meteor)
                        }
                }
            }
            .navigationTitle(meteor.name ?? "Meteor Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    toggleRefresh()
                } label: {
                    Label("Refresh details", systemImage: "arrow.clockwise.circle.fill")
                }
                
                Button(action: toggleFavourite) {
                    Label("Add Favourite", systemImage: "heart.fill")
                }
                .accentColor(isFavourite ? Color.blue : .gray)
            }
        }
        .onAppear {
            guard let meteorId = meteor.id else {
                print("This meteor has no id: \(meteor)")
                return
            }
            
            let fetchRequest = FavouriteMeteor.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@ and favourite = true", meteorId)
            
            do {
                let result = try viewContext.fetch(fetchRequest)
                isFavourite = !result.isEmpty
            } catch let error {
                print("Error happend when fatching favourite meteor: \(error)")
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
    func getLocation(meter: Meteor) -> CLLocationCoordinate2D? {
        if let geoLocation = meter.geolocation, let latitude = geoLocation.getLatitudeDouble(), let longitude = geoLocation.getLongitudeDouble() {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            return location
        }
        
        return nil
    }
    
    func getAnnotation(meter: Meteor) -> [Annotation]? {
        if let location = self.getLocation(meter: meter) {
            return [Annotation(coordicate: location, title: meter.name, message: meter.mass)]
        }
        return nil
    }
    
    
    /// check if the meteor exists in the database, then toggle favourite flag
    func toggleFavourite() {
        withAnimation {
            guard let meteorId = meteor.id else {
                print("This meteor has no id: \(meteor)")
                return
            }
            
            let fetchRequest = FavouriteMeteor.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id = %@ and favourite = true", meteorId)
            
            do {
                // toggle the value on the state, this will change the button color on the tool bar
                isFavourite.toggle()
                
                let result = try viewContext.fetch(fetchRequest)
                let favouriteMeteor = !result.isEmpty ? result.first! : FavouriteMeteor(context: viewContext)
                
                favouriteMeteor.name = meteor.name
                favouriteMeteor.id = meteor.id
                favouriteMeteor.nametype = meteor.nametype
                favouriteMeteor.recclass = meteor.recclass
                favouriteMeteor.mass = meteor.mass
                favouriteMeteor.fall = meteor.fall
                if let yearString = meteor.year {
                    favouriteMeteor.year = Date.fromString(yearString, format: AppConfigs.METEOR_DATE_FORMAT)
                }
                
                favouriteMeteor.reclat = meteor.reclat
                favouriteMeteor.reclong = meteor.reclong
                
                // change flag in the database
                favouriteMeteor.favourite = isFavourite
                
                try viewContext.save()
                
            } catch let error {
                print("Error happend when fatching favourite meteor: \(error)")
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func toggleRefresh() {
        searchMeteorDetails(meteor)
    }

    func searchMeteorDetails(_ meteor: Meteor) {
        var searchFilter = MeteorSearchFilter()
        searchFilter.meteorID = meteor.id
        
        meteorDataModel.searchMeteors(searchFilter, append: false)
    }
}

//struct MeteorDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeteorDetailsView()
//    }
//}
