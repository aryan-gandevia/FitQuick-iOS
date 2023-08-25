//
//  HomeView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//

import FirebaseFirestoreSwift
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewViewModel()
    @FirestoreQuery var lifts: [Lift]
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        self._lifts = FirestoreQuery(
            collectionPath: "users/\(userId)/lifts")
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(lifts) { lift in
                    NewLiftItemView(item: lift)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.delete(id: lift.id,
                                                 userId: userId)
                            }
                            .tint(.red)
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Track Your Lifts!")
            .toolbar {
                Button {
                    viewModel.showingNewLiftView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewLiftView) {
                NewLiftView(newLiftPresented: $viewModel.showingNewLiftView,
                            edit: false,
                            liftName: "",
                            numReps: "",
                            weight: "")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: "KCvdYfAWe9YVxbkPOFFCOZMSCre2")
    }
}
