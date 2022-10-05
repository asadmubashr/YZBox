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
    
    @State private var isHomeView: Bool = false
    
    var body: some View {
        if isHomeView {
            TabsView()
        }
        else {
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
                                                
                                                PFUser.register(AuthDelegate(), forAuthType: "apple")
                                            
                                            
                                                PFUser.logInWithAuthType(inBackground: "apple", authData: ["token":tokenString, "id": user]).continueWith { task -> Any? in
                                                
                                                    if task.result != nil {
                                                        let userId = authCredential.user
                                                    
                                                        let email = authCredential.email
                                                        let firstName = authCredential.fullName?.givenName
                                                        let lastName = authCredential.fullName?.familyName
                                                    
                                                        addUser(user: User(userId: userId, email: email, firstName: firstName, lastName: lastName))
                                                    
                                                        isHomeView = true
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
                    testParseConnection()
                })
            }
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
    
    private func addUser(user: User) {
        var isUserExist: Bool = false
        
        for yzbox_user in yzbox_users {
            if yzbox_user.userId == user.userId {
                isUserExist = true
                UserDefaults.standard.set(yzbox_user.userId, forKey: "user-id")
                UserDefaults.standard.set(yzbox_user.firstName, forKey: "first_name")
                UserDefaults.standard.set(yzbox_user.lastName, forKey: "last_name")
            }
        }
        
        if !isUserExist {
            // YZBox User
            let yzbox_user = YZBox_User(context: self.viewContext)
            
            print(user.userId)
            yzbox_user.active = true
            yzbox_user.userId = user.userId
            
            if let email = user.email {
                yzbox_user.email = user.email
                UserDefaults.standard.set(yzbox_user.userId, forKey: "user-id")
                print(email)
            }
            
            if let firstName = user.firstName {
                yzbox_user.firstName = user.firstName
                UserDefaults.standard.set(yzbox_user.firstName, forKey: "first_name")
                print(firstName)
            }
            
            if let lastName = user.lastName {
                yzbox_user.lastName = user.lastName
                UserDefaults.standard.set(yzbox_user.lastName, forKey: "last_name")
                print(lastName)
            }
                
            do {
                try self.viewContext.save()
                
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
}
    
    


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


class AuthDelegate:NSObject, PFUserAuthenticationDelegate {
    func restoreAuthentication(withAuthData authData: [String : String]?) -> Bool {
        return true
    }
    
    func restoreAuthenticationWithAuthData(authData: [String : String]?) -> Bool {
        return true
    }
}
