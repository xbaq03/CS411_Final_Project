//
//  MovieGenApp.swift
//  MovieGen
//
//  Created by Badr Qattan on 4/14/24.
//



import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

func signInWithGoogle() async -> Bool {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found in Firebase configuration")
    }

    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = await windowScene.windows.first,
          let rootViewController = await window.rootViewController else {
        print("There is no root view controller")
        return false
    }

    do {
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuthentication.user
        guard let idToken = user.idToken else {
            print("ID token missing")
            return false
        }
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

        let result = try await Auth.auth().signIn(with: credential)
        let firebaseUser = result.user
        print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
        
        // Call function to store user data
        await storeUserData(firebaseUser)
        return true
    } catch {
        print("Sign in with Google errored: \(error.localizedDescription)")
        return false
    }
}


func storeUserData(_ user: User) async {
    let db = Firestore.firestore()
    let userData = [
        "email": user.email ?? "No email",
        "displayName": user.displayName ?? "No name",
        "lastSignInTime": Timestamp(date: user.metadata.lastSignInDate ?? Date()),
        // You can add more fields here as needed
    ] as [String : Any]

    do {
        try await db.collection("users").document(user.uid).setData(userData)
        print("User data stored successfully")
    } catch let error {
        print("Error storing user data: \(error)")
    }
}


@main
struct MovieGenApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
