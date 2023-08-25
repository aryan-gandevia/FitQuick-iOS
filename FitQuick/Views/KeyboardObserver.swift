//
//  KeyboardObserver.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-13.
//
import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var keyboardIsVisible = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .sink { [weak self] height in
                self?.keyboardIsVisible = true
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.keyboardIsVisible = false
            }
            .store(in: &cancellables)
    }
}
