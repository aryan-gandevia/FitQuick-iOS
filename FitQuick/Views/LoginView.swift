//
//  LoginView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(title: "FitQuick",
                           subtitle: "Get Fit Quick!")
                
                
                // Login Form
                Form {
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())

                    FQButton(title: "Log in",
                             background: .blue) {
                        viewModel.login()
                    }
                    .padding()
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                }
                .scrollContentBackground(.hidden)
                .padding(.bottom, -250)
                .offset(y: keyboardObserver.keyboardIsVisible ? -245 : -70)
                
                // Create Account
                VStack {
                    Text("First time user?")
                        .offset(y:-10)
                    
                    NavigationLink("Create An Account", destination: RegistrationView())
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
