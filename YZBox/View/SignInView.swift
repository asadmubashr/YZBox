//
//  SignInView.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI
import CoreData
import Parse
import AuthenticationServices

struct SignInView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Users from local db
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \YZBox_User.userId, ascending: true)],
        animation: .default)
    private var yzbox_users: FetchedResults<YZBox_User>
    
    @EnvironmentObject var vm: UserStateViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    // top
                    VStack {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                            Text("YZBOX")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.50)
                    //.border(Color.green)
                    
                    // center
                    VStack {
                        VStack {
                            SignInWithAppleButton(.continue) { request in
                                request.requestedScopes = [.email, .fullName]
                            } onCompletion: { result in
                                switch(result) {
                                    case .success(let auth):
                                        switch(auth.credential) {
                                            case let authCredential as ASAuthorizationAppleIDCredential:
                                        
                                            let token = authCredential.identityToken!
                                            let tokenString = String(data: token, encoding: .utf8)!
                                            let user = authCredential.user
                                        
                                            print("TOKEN: \(tokenString)")
                                            print("USER: \(user)")
                                            
                                            if !vm.isSessionWorking {
                                                PFUser.register(AuthDelegate(), forAuthType: "apple")
                                            }
                                            
                                        
                                        
                                            PFUser.logInWithAuthType(inBackground: "apple", authData: ["token":tokenString, "id": user]).continueWith { task -> Any? in
                                            
                                                if task.result != nil {
                                                    let userId = authCredential.user
                                                    UserDefaults.standard.set(userId, forKey: "user_id")
                                                    let email = authCredential.email
                                                    let firstName = authCredential.fullName?.givenName
                                                    
                                                    let lastName = authCredential.fullName?.familyName
                                                    
                                                    checkUserAlreadyExist() { response in
                                                        print(response)
                                                        if !response {
                                                            addParseUser(user: User(userId: userId, email: email, firstName: firstName, lastName: lastName))
                                                        }
                                                        else {
                                                            activateAccount()
                                                        }
                                                    }
                                                    
//                                                        addUser(user: User(userId: userId, email: email, firstName: firstName, lastName: lastName))
                                                
                                                    vm.isLoggedIn = true
                                                    print("LOGGED IN PARSE")
                                                } else {
                                                // Failed to log in.
                                                    print("ERROR LOGGING IN IN PARSE: \(task.error?.localizedDescription)")
                                                }
                                                return nil
                                            }
                                            break
                                        default:
                                            break
                                    }
                                    case .failure(let error):
                                        print(error)
                                        break
                                }
                            }
                            .frame(maxWidth: geo.size.width * 0.75)
                            .frame(height: 40)
                            .cornerRadius(10)
                            
//                                Text("Sign In with Apple")
//                                    .frame(maxWidth: geo.size.width * 0.75)
//                                    .frame(height: 60)
//                                    .background(Color.pink)
//                                    .foregroundColor(Color.white)
//                                    .cornerRadius(10)
//                                    .onTapGesture(perform: {
//                                        isHomeView = true
//                                    })
                                
                            Spacer()
                            Text("By clicking Continue with Apple you acknowledge that you have read understood and agreed to YZBOX's Terms and Conditions and Privacy Policy")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.40)
                    //.border(Color.blue)
                    
                    
                    // bottom
                    
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                //testParseConnection()
            })
        }
        
        
        }
    
    func testParseConnection(){
        let myObj = PFObject(className:"FirstClass")
        myObj["message"] = "Hey ! First message from Swift. Parse is now connected"
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }else{
                print("An error has occurred!")
            }
        }
    }
    
    func checkUserAlreadyExist(completion: @escaping(_ response: Bool) -> Void){
        let myObj = PFQuery(className:"Users")
        print("kjhbj: " + (UserDefaults.standard.string(forKey: "user_id") ?? "c"))
        myObj.whereKey("userId", equalTo: UserDefaults.standard.string(forKey: "user_id") ?? "profile")
        myObj.findObjectsInBackground { (users: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else if let users = users {
                print("here \(users.count)")
                if users.count >= 1 {
                    completion(true)
                }
                else {
                    completion(false)
                }
                
            }
        }
    }
    
    
    
    func addParseUser(user: User){
        let myObj = PFObject(className:"Users")
        myObj["userId"] = user.userId
        if user.email != nil {
            myObj["userId"] = user.email
        }
        if user.firstName != nil {
            myObj["firstName"] = user.firstName
            UserDefaults.standard.set(user.firstName, forKey: "first_name")
        }
        if user.lastName != nil {
            myObj["userId"] = user.lastName
            UserDefaults.standard.set(user.lastName, forKey: "last_name")
        }
        myObj["active"] = true
        
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }else{
                print("An error has occurred!")
            }
        }
    }
    
    private func activateAccount() {
        let myObj = PFQuery(className:"Users")
        myObj.whereKey("userId", equalTo: UserDefaults.standard.string(forKey: "user_id") ?? "profile")
        myObj.getFirstObjectInBackground { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                user["active"] = true
                user.saveInBackground()
            }
        }
    }
}
    
    


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}



