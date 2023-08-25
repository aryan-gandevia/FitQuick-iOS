//
//  VersusTheWorldView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-20.
//

import SwiftUI
import Charts

struct VersusTheWorldView: View {
    @StateObject var viewModel = VersusTheWorldViewViewModel()
    
    @Binding var screenState: Bool
    
    let userId: String
    let selectedLift: String
    
    // animation
    @State private var showCircle1 = false
    @State private var showCircle2 = false
    @State private var showCircle3 = false
    @State private var showRest = false
    
    @State private var textBox = false
    
    @State private var inChart = true
    
    var body: some View {
        ScrollView {
            VStack {
                Text(selectedLift)
                    .font(.system(size: 25))
                    .bold()
                    .padding()
                
                HStack {
                    Text("Reps: ")
                        .bold()
                        .font(.system(size: 30))
                    Text(String(viewModel.lift?.numReps ?? 0))
                        .font(.system(size: 30))
                    Spacer()
                }
                .offset(x: 10)
                
                HStack {
                    Text("Weight: ")
                        .bold()
                        .font(.system(size: 30))
                    Text(String(viewModel.lift?.weight ?? 0))
                        .font(.system(size: 30))
                    Spacer()
                }
                .offset(x: 10)
                
                if showCircle1 {
                   Circle()
                       .frame(width: 20, height: 20)
                       .foregroundColor(.yellow)
                       .animation(Animation.easeInOut.delay(0.5))
                           }
                if showCircle2 {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.orange)
                        .animation(Animation.easeInOut.delay(1.25))
                }
                if showCircle3 {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                        .animation(Animation.easeInOut.delay(2))
                }
                
                if showRest {
                    
                    HStack {
                        // calculated 1RM
                        Text("Your projected 1 rep max is: ")
                            .bold()
                            .font(.system(size: 27))
                        
                        Button {
                            textBox = true
                        } label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:20, height: 20)
                        }
                        .foregroundColor(Color.gray)
                    }
    
                    // value of 1RM
                    Text(String(viewModel.calculatedOneRM))
                        .font(.system(size: 80))
                        .offset(y:-20)
                    
                    
                    Text(selectedLift)
                        .bold()
                        .font(.system(size:25))
                    Text("Global Strength Standards at " + String(viewModel.user?.weight ?? 0) + "lbs BW")
                        .font(.system(size:20))
                        .frame(width:UIScreen.main.bounds.width * 0.9)
                    // chart to display where you are relative to general population
                    Chart {
                        ForEach(Array(zip(viewModel.levels, viewModel.levelsWeightList)), id: \.0) { level, liftWeight in
                            
                            if level == "You" {
                                BarMark(
                                    x: .value("Level", level),
                                    y: .value("weight", liftWeight)
                                    )
                                .foregroundStyle(.red)
                            } else {
                                BarMark(
                                    x: .value("Level", level),
                                    y: .value("weight", liftWeight)
                                )
                            }
                        }
                    }
                    .chartXAxisLabel {
                        Text("Lifter Level")
                            .foregroundColor(Color.teal)
                    }
                    .chartYAxisLabel {
                        Text("Weight (lbs)")
                            .foregroundColor(Color.teal)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                    Text(viewModel.message)
                        .multilineTextAlignment(.center)
                    
                    Button("Back") {
                        screenState = false
                    }
                    .font(.system(size:20))
                    .padding()

                }
                
            }
            .alert(isPresented: $textBox) {
                Alert(title: Text("Additional Information"),
                      message: Text("This is calculated using Matt Brzycki's Brzycki formula to calculate a 1RM: weight / ( 1.0278 – 0.0278 × reps )"))
            }
        }
        .onAppear {
            viewModel.fetchUser(userId: userId)
            viewModel.fetchLift(userId: userId,
                                liftName: selectedLift)
            viewModel.setData()
            
            // animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showCircle1 = true
                }
            }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                withAnimation {
                    showCircle2 = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showCircle3 = true
                }
            }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                withAnimation {
                    showRest = true
                    viewModel.setOneRepMax(liftName: selectedLift)
                }
            }
        }
    }
}

struct VersusTheWorldView_Previews: PreviewProvider {
    static var previews: some View {
        VersusTheWorldView(screenState: Binding(get: {
            return true
        }, set: { _ in
    
        }),
        userId: "exmaple",
        selectedLift: "lift one")
    }
}
