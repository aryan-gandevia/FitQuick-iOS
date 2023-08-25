//
//  NewLiftItemView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-14.
//

import SwiftUI

struct NewLiftItemView: View {
    @StateObject var viewModel = HomeViewViewModel()
    let item: Lift
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.liftName)
                    .bold()
                    .font(.system(size: 20))
                
                HStack {
                    Text("Reps:" )
                        .bold()
                    Text(String(item.numReps))
                    
                    Text("Weight:")
                        .bold()
                        .offset(x: 10)
                    
                    Text(String(item.weight))
                        .offset(x:10)
                }
            }
            Spacer()
            
            Button {
                viewModel.showingNewLiftView = true
            } label: {
                Text("Edit")
                    .foregroundColor(Color.blue)
            }
        }
        .sheet(isPresented: $viewModel.showingNewLiftView) {
            NewLiftView(newLiftPresented: $viewModel.showingNewLiftView,
                        edit: true,
                        liftName: item.liftName,
                        numReps: String(item.numReps),
                        weight: String(item.weight))
        }
    }
}

struct NewLiftItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewLiftItemView(item: .init(id: "lift",
                                    liftName: "lift",
                                    numReps: 1,
                                    weight: 135))
    }
}
