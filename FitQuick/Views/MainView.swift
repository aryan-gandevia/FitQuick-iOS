//
//  MainView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
         if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                ProfileView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                
                HomeView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                CompareView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("Compare", systemImage: "flame.fill")
                    }
            }
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
