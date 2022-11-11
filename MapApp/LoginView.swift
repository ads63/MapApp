//
//  LoginView.swift
//  MapApp
//
//  Created by Алексей Шинкарев on 03.11.2022.
//

import RxCocoa
import RxSwift
import SwiftUI

struct LoginView: View {
    let realmService = RealmService()
    let disposeBag = DisposeBag()
    @Binding var showMapView: Bool
    @State var loginSubject = PublishSubject<String>()
    @State var passwordSubject = PublishSubject<String>()
    @State private var login = ""
    @State private var password = ""
    @State private var showUserAlert = false
    @State private var isUserValid = false
    @State private var userBinding: Disposable?
    var body: some View {
        VStack {
            Spacer()
            TextField("Login", text: $login)
                .onChange(of: login, perform: {
                    loginSubject.onNext(String($0))
                })
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding()
            SecureField("Password", text: $password)
                .onChange(of: password, perform: {
                    passwordSubject.onNext(String($0))
                })
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding()
            Button("Login", action: { loginUser() })
                .disabled(!isUserValid)
                .foregroundColor(isUserValid ? .blue : .gray)
                .font(.title)
                .padding()
            Button("Register", action: { registerUser() })
                .disabled(!isUserValid)
                .foregroundColor(isUserValid ? .blue : .gray)
                .font(.title)
            Spacer()
        }
        .onDisappear {
            unsubsribeUserChanges()
        }
        .onAppear {
            login = ""
            password = ""
            showMapView = false
            isUserValid = false
            subsribeUserChanges()
        }.alert(isPresented: $showUserAlert) {
            Alert(title: Text("Warning"),
                  message: Text("Invalid user"),
                  dismissButton: .default(Text("Ok")))
        }
    }

    private func subsribeUserChanges() {
        userBinding = Observable
            .combineLatest(loginSubject.asObservable(),
                           passwordSubject.asObservable()).map { loginValue, passwordValue in
                !loginValue.isEmpty && passwordValue.count > 5
            }.bind(onNext: { userState in
                self.isUserValid = userState
            })
    }

    private func unsubsribeUserChanges() {
        userBinding?.disposed(by: disposeBag)
    }

    private func loginUser() {
        guard let user = realmService.selectUser(login: login)?.first,
              user.password == password
        else {
            showUserAlert.toggle()
            return
        }
        showMapView = true
    }

    private func registerUser() {
        if login.isEmpty || password.isEmpty {
            showUserAlert.toggle()
            return
        }
        realmService.insertUser(user: User(login: login, password: password))
        showMapView = true
    }
}
