//
//  ProfileView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    if let user = viewModel.user {
                        profile(user: user)
                    } else {
                        Text("Loading Profile...")
                    }
                }
                .navigationTitle("Profile")
            }
        }
        .sheet(isPresented: $viewModel.showData) {
            if viewModel.user?.weight == 0 {
                PersonInformationView(showData: $viewModel.showData, userId: userId)
                    .interactiveDismissDisabled(true)
            } else {
                PersonInformationView(showData: $viewModel.showData, userId: userId)
                    .interactiveDismissDisabled(false)
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        let firstLetter = user.name.first?.lowercased() ?? ""
        let avatarLetter = firstLetter + ".circle.fill"
        // Avatar
        
        HStack {
            Image(systemName: avatarLetter)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.blue)
                .frame(width: 125, height: 125)
                .offset(x: UIScreen.main.bounds.width * -0.05)
            
            
                Text(user.userName)
                .font(.system(size: 25))
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .multilineTextAlignment(.center)
        }
        //Information
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "character.bubble.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray)
                    .frame(width: 30, height: 30)

                Text(user.name)
                    .offset(x: UIScreen.main.bounds.width * 0.05)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .multilineTextAlignment(.leading)
            }
            HStack {
                Image(systemName: "mail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray)
                    .frame(width: 30, height: 30)
                
                Text(user.email)
                    .offset(x: UIScreen.main.bounds.width * 0.05)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .multilineTextAlignment(.leading)
            }
            HStack {
                Image(systemName: "cable.connector")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.gray)
                    .frame(width: 30, height: 30)
                    //.offset(x: UIScreen.main.bounds.width * -0.1)
                
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                    .offset(x: UIScreen.main.bounds.width * 0.05)
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .multilineTextAlignment(.leading)
                
            }
        }
        .padding()
        .offset(y: UIScreen.main.bounds.height * 0.05)
        
        Button("Edit Personal Information") {
            viewModel.showData = true
        }
        .offset(y: UIScreen.main.bounds.height * 0.1)
            
        
        // Sign out
        Button("Log Out") {
            viewModel.logOut()
        }
        .tint(.red)
        .offset(y: UIScreen.main.bounds.height * 0.1)
        .padding()
        
        Spacer()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userId: "KCvdYfAWe9YVxbkPOFFCOZMSCre2")
    }
}
