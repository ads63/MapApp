//
//  LoginView.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 03.11.2022.
//

import SwiftUI

struct LoginView: View {
    let realmService = RealmService()
    @Binding var showMapView: Bool
    @State private var login = ""
    @State private var password = ""
    @State private var showPasswordAlert = false
    var body: some View {
        VStack {
            Spacer()
            TextField("Login", text: $login)
                .padding()
            TextField("Password", text: $password)
                .padding()
            Button("Login", action: { loginUser() })
                .foregroundColor(.blue)
                .font(.title)
                .padding()
            Button("Register", action: { registerUser() })
                .foregroundColor(.blue)
                .font(.title)
            Spacer()
        }.onAppear {
            login = ""
            password = ""
            showMapView = false
        }.alert(isPresented: $showPasswordAlert) {
            Alert(title: Text("Warning"),
                  message: Text("Invalid user"),
                  dismissButton: .default(Text("Ok")))
        }
    }

    private func loginUser() {
        guard let user = realmService.selectUser(login: login)?.first,
              user.password == password
        else {
            showPasswordAlert.toggle()
            return
        }
        showMapView = true
    }

    private func registerUser() {
        realmService.insertUser(user: User(login: login, password: password))
        showMapView = true
    }
}
