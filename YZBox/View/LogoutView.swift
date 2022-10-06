//
//  LogoutView.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI
import CoreData
import Parse

struct LogoutView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var profileImage: Image
    @Binding var name: String
    
    @EnvironmentObject var vm: UserStateViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    // top
                    VStack {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .onTapGesture(perform: {
                                    presentationMode.wrappedValue.dismiss()
                                })
                            
                            Spacer()
                        }
                        .padding([.leading])
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.05)
                    //.border(Color.green)
                    
                    VStack {
                        VStack {
                            profileImage
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                            Text(name)
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.35)
                    //.border(Color.green)
                    
                    // center
                    VStack {
                        VStack {
                            Text("Upgrade Pro")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 40)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.purple, .gray]), startPoint: .leading, endPoint: .trailing)
                                )
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                
                            Spacer()
                            Text("Log Out")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 40)
                                .background(Color.gray)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .onTapGesture(perform: {
                                    PFUser.logOut()
                                    vm.isSessionWorking = true
                                    vm.isLoggedIn = false
                                })
                            
                            Text("Delete Account")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.8))
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .onTapGesture(perform: {
                                    deleteAccount()
                                    vm.isSessionWorking = true
                                    vm.isLoggedIn = false
                                })
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.50)
                    //.border(Color.blue)
                    
                    
                    // bottom
                    
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                getImageFromName()
            })
        }
        
    }
    
    func updateParseActive(){
        let myObj = PFObject(className:"Users")
        myObj["active"] = false
        myObj.saveInBackground { (success, error) in
            if(success){
                print("You are connected!")
            }else{
                print("An error has occurred!")
            }
        }
    }
    
    private func deleteAccount() {
        let myObj = PFQuery(className:"Users")
        myObj.whereKey("userId", equalTo: UserDefaults.standard.string(forKey: "user_id") ?? "profile")
        myObj.getFirstObjectInBackground { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                user["active"] = false
                user.saveInBackground()
            }
        }
    }
    
    
    
    func getImageFromName() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = UserDefaults.standard.string(forKey: "user_id") ?? "profile"
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        if let imageData = try? Data(contentsOf: url) {
            let uiImage = UIImage(data: imageData)
            if uiImage != nil {
                profileImage = Image(uiImage: uiImage!)
            }
            
        } else {
            print("Couldn't get image for \(fileName)")
        }
    }
}

//struct LogoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        LogoutView()
//    }
//}
