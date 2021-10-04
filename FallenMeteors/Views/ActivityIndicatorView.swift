//
//  ActivityIndicatorView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 04/10/2021.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    
    var style: UIActivityIndicatorView.Style = .medium
    
    @Binding var isAnimating: Bool
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
        uiView.tintColor = .blue
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
    
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        return activityIndicator
    }
}
