//
//  HomeView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 01/10/2021.
//

import SwiftUI
import FallenMeteorAPI

struct HomeView: View {
    
    var body: some View {
        TabView {
            MeteorsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .tabItem {
                    Label {
                        Text("Meteors")
                    } icon: {
                        Image("Meteor")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                    }

                }
            
            FavouritesView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            
                .tabItem {
                    Label {
                        Text("Favorites")
                    } icon: {
                        Image("Heart")
                            .resizable()
                            .font(Font.system(size: 10))
                            .frame(width: 45, height: 45, alignment: .center)
                    }
                }
        }
        .onAppear {
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
