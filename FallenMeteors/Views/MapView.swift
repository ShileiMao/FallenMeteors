//
//  MapView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 03/10/2021.
//

import SwiftUI
import MapKit

struct Annotation {
    var coordicate: CLLocationCoordinate2D
    var title: String?
    var message: String?
}

/// A wrapper object for the MKMapView fromo UIKit
struct MapView: UIViewRepresentable {
    
    var showInLocation: CLLocationCoordinate2D?
    
    var markLocations: [Annotation]?
    
    var mapView: MKMapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        if let showInLocation = showInLocation {
            mapView.centerCoordinate = showInLocation
        }

        
        return mapView
    }
    
    /// Refresh the Map view when the binded data changed
    /// - Parameters:
    ///   - uiView: the MKMap view that needs to update
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // form the custom annotations based on the geoLocation provided
        if let annotations = markLocations?.map({ item -> MKPointAnnotation in
            let ann = MKPointAnnotation()
            ann.title = item.title
            ann.coordinate = item.coordicate
            
            return ann
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("adding notations ..")
                
                let previousAnnotations = uiView.annotations
                uiView.removeAnnotations(previousAnnotations)
                
                uiView.addAnnotations(annotations)
                
                let center = annotations.first!.coordinate
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                uiView.setRegion(region, animated: true)
            }
        }
    }
}
