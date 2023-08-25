//
//  BackgroundView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-15.
//

import SwiftUI

struct BackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(colorScheme == .light ? Color.black : Color.white)
                .rotationEffect(Angle(degrees:15))
                .offset(y: UIScreen.main.bounds.height * -0.8)
                .frame(width: UIScreen.main.bounds.width * 2)
            
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees:-15))
                .offset(y: UIScreen.main.bounds.height * -0.75)
            
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
