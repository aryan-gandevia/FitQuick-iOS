//
//  CompareView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import Firebase
import FirebaseFirestore
import SwiftUI

struct CompareView: View {
    @StateObject var viewModel = CompareViewViewModel()
    
    private let userId: String
    @State var otherUserId = ""
    
    // true: find a user screen
    // false: compare to general population
    @State var screenState = true
    
    // variables for comparing to general population
    @State var showingLiftComparison = false
    
    @State var validity = ""
    
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Search Users") {
                    screenState = true
                }
                .offset(x: UIScreen.main.bounds.width * 0.1)
                Spacer()
                Button("General Population") {
                    screenState = false
                }
                .offset(x: UIScreen.main.bounds.width * -0.1)
            }
            if screenState {
                findAUser()
            } else {
                generalPopulation()
            }
        }
    }
    
    // find a user screen
    @ViewBuilder
    private func findAUser() -> some View {
        NavigationView {
            VStack {
                Text("Find a User!")
                    .font(.system(size: 37))
                    .bold()
                    .offset(y: 10)
                
                TextField("Search Username", text: $viewModel.search)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack {
                    List(viewModel.searchResults, id: \.self) { result in
                        
                        Button {
                            otherUserId = result.id
                            viewModel.showingFaceOff = true
                        } label: {
                            Text(result.userName)
                                .bold()
                                .padding()
                        }
                    }
                }
                .frame(height:UIScreen.main.bounds.height * 0.6)
                
            }
            .onChange(of: viewModel.search) { _ in
                viewModel.updatedSearch()
            }
            .sheet(isPresented: $viewModel.showingFaceOff) {
                FaceOffView(showingFaceOff: $viewModel.showingFaceOff,
                            userId: userId,
                otherUserId: otherUserId)
            }
            .onAppear {
                viewModel.currentUserId = userId
                viewModel.updatedSearch()
            }
        }
    }
    
    // General population screen
    @ViewBuilder
    private func generalPopulation() -> some View {
        NavigationView {
            VStack {
                // title
                Text("You vs the World!")
                    .font(.system(size: 34))
                    .bold()
                    .offset(y: 10)
                
                // header
                Text("Select a lift to compare")
                    .font(.system(size: 20))
                    .offset(y: 10)
                if viewModel.liftResults.count == 0 {
                    Spacer()
                    Text("Please save some lifts first to start comparing!")
                        .foregroundColor(Color.red)
                        .frame(width:UIScreen.main.bounds.width * 0.9)
                    Spacer()
                } else {
                    Form {
                        // lift selector
                        Picker("Lift:", selection: $viewModel.liftSelected) {
                            ForEach(viewModel.liftResults, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        
                        // button
                        FQButton(title: "Compare",
                                 background: .blue) {
                            showingLiftComparison = true
                        }
                                 .padding()
                    }
                }
                
            }
            .onAppear {
                viewModel.currentUserId = userId
                viewModel.fetchAvailableLifts()
            }
            .sheet(isPresented: $showingLiftComparison) {
                VersusTheWorldView(screenState: $showingLiftComparison, userId: userId, selectedLift: viewModel.liftSelected)
            }
        }
    }
    
}

struct CompareView_Previews: PreviewProvider {
    static var previews: some View {
        CompareView(userId: "KCvdYfAWe9YVxbkPOFFCOZMSCre2")
    }
}
