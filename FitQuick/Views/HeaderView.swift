//
//  HeaderView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.black)
                .rotationEffect(Angle(degrees:15))
                .offset(y: -110)
            
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
                    .bold()
                
                Text(subtitle)
                    .font(.system(size:20))
                    .foregroundColor(Color.white)
                    
            }
            .padding(.top, 30)
            .offset(y:-170)
            
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.teal)
                .offset(y:370)
                .rotationEffect(Angle(degrees:15))
        }
        .frame(width: UIScreen.main.bounds.width * 3,
               height: 500)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title", subtitle: "Subtitle")
    }
}
