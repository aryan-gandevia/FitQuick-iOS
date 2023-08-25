//
//  FQButton.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import SwiftUI

struct FQButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)

                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

struct FQButton_Previews: PreviewProvider {
    static var previews: some View {
        FQButton(title: "Button", background: Color.pink) {
            //Action
        }
    }
}
