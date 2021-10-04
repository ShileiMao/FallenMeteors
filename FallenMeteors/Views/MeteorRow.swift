//
//  MeteorRow.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 03/10/2021.
//

import SwiftUI
import FallenMeteorAPI

struct MeteorRow: View {
    var meteor: Meteor
    
    var body: some View {
        VStack(alignment: .leading) {
            // Meteor name
            meteor.name.map(Text.init)
                .font(.title3)
            
            // Meteor fallen year + mass
            if let dateStr = formateDate(meteor: meteor), let mass = getMass(meteor: meteor) {
                Text("\(dateStr) (\(mass) kg)")
                    .foregroundColor(.gray)
                    .font(.body)
                
            }
            
        }
    }
    
    func formateDate(meteor: Meteor) -> String? {
        guard let year = meteor.year, let date = Date.fromString(year, format: AppConfigs.METEOR_DATE_FORMAT) else {
            return nil
        }
        
        return date.toString("MMM yyy")
    }
    
    func getMass(meteor: Meteor) -> String? {
        return meteor.mass
    }
}

struct MeteorRow_Previews: PreviewProvider {
    static var previews: some View {
        let meteor = Meteor(name: "Test Meteor", id: "123456", year: "2021-10-01T00:00:00.000", mass: "1.03")
        MeteorRow(meteor: meteor)
    }
}
