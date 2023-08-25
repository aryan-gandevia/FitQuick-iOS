//
//  RegistrationView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-12.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject private var keyboardObserver = KeyboardObserver()
    @StateObject var viewModel = RegisterViewViewModel()
    
    
    
    var body: some View {
        VStack {
            //Header
            HeaderView(title: "Create Account", subtitle: "Start your fitness journey today!")
            
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                }
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Username (shorter than 15 characters)", text: $viewModel.userName)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                SecureField("Password (longer than 6 characters)", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                FQButton(title: "Register",
                         background: .green) {
                    viewModel.register()
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .padding(.bottom, -405)
            .offset(y: keyboardObserver.keyboardIsVisible ? -400 : -350)
        }
        .offset(y:-20)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
