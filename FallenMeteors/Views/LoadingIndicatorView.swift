//
//  LoadingIndicatorView.swift
//  FallenMeteors
//
//  Created by Shilei Mao on 04/10/2021.
//

import SwiftUI

/// A custom data loading indicator view, currently only a static text on the screen, we can custmise this view content to make it more user friendly
struct LoadingIndicatorView: View {
    var text: String = "Loading data ..."
    var body: some View {
        Text(text)
    }
}

struct LoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicatorView()
    }
}
