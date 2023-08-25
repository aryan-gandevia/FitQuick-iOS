//
//  NewLiftView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-14.
//

import SwiftUI

struct NewLiftView: View {
    
    let options = ["Barbell Bench Press",
                   "Barbell Inclined Bench Press",
                   "Barbell Deadlift",
                   "Barbell Squat"]
    
    @StateObject var viewModel = NewLiftViewViewModel()
    @Binding var newLiftPresented: Bool
    
    // Properties in case we are editing instead of adding something new
    var edit: Bool
    var liftName: String
    var numReps: String
    var weight: String
    
    
    var body: some View {
        VStack {
            Text("New Lift")
                .font(.system(size: 32))
                .bold()
                .offset(y: 10)
            
            Text("Please use pounds!")
                .offset(y:10)
            
            Form {
                // Lift
                Picker("Lift:", selection: $viewModel.liftName) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                // Number of reps
                HStack {
                    Text("Reps:")
                        .bold()
                    TextField("Number of reps (<= 12)", text: $viewModel.numReps)
                        .keyboardType(.numberPad)
                }
                
                // Weight
                HStack {
                    Text("Weight (lbs):")
                        .bold()
                    TextField("Weight (lbs)", text: $viewModel.weight)
                        .keyboardType(.numberPad)
                }
                
                // Button
                FQButton(title: "Save",
                         background: .green) {
                    if viewModel.canSave {
                        viewModel.save()
                        newLiftPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage))
            }
        }
        .onAppear {
            // If editing as opposed to making new, set the values from before
            if edit {
                viewModel.liftName = liftName
                viewModel.numReps = numReps
                viewModel.weight = weight
            }
        }
    }
}

struct NewLiftView_Previews: PreviewProvider {
    static var previews: some View {
        NewLiftView(newLiftPresented: Binding(get: {
            return true
        }, set: { _ in
    
        }),
                    edit: false,
                    liftName: "Barbell Bench Press",
                    numReps: "1",
                    weight: "135")
    }
}
