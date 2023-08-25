//
//  PersonInformationView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import SwiftUI

struct PersonInformationView: View {
    let options = ["None", "Male", "Female", "Other"]
    
    @StateObject var viewModel = PersonaInformationViewViewModel()
    
    @State var buttonClicked = false
    
    @Binding var showData: Bool
    
    var userId: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Personal Information")
                    .bold()
                    .font(.system(size: 30))
                    .offset(y:10)
                
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    Picker("Gender:", selection: $viewModel.gender) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    HStack {
                        Text("Age:   ")
                            .bold()
                        TextField("Age", text: $viewModel.age)
                            .keyboardType(.numberPad)
                            .offset(x:-10)
                    }
                    HStack {
                        Text("Weight (lbs):   ")
                            .bold()
                        TextField("Weight", text: $viewModel.weight)
                            .keyboardType(.numberPad)
                            .offset(x:-10)
                    }
                    HStack {
                        Text("Height (inches):   ")
                            .bold()
                        TextField("Height", text: $viewModel.height)
                            .keyboardType(.numberPad)
                            .offset(x:-10)
                    }
                    FQButton(title: "Save Information",
                             background: .blue) {
                        buttonClicked = true
                        viewModel.save()
                        if viewModel.validate() {
                            showData = false
                        }
                    }
                    .padding()
                }
                .offset(y:-10)
                .scrollContentBackground(.hidden)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct PersonInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PersonInformationView(showData:Binding(get: {
            return true
        }, set: { _ in
    
        }), userId: "example")
    }
}
