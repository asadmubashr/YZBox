//
//  UpdateNicknameView.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI

struct UpdateNicknameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var name: String = (UserDefaults.standard.string(forKey: "first_name")) ?? "Dr." + " " + (UserDefaults.standard.string(forKey: "last_name") ?? "Who")
    
    @State private var nickname: String = ""
    
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
                            TextField("Nickname", text: $nickname)
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 40)
                                .foregroundColor(Color.gray)
                                .padding([.leading])
                                .border(Color.gray, width: 2)
                                .cornerRadius(5)
                                
                            Spacer()
                            
                            Text("Save")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 40)
                                .background(Color.pink)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .onTapGesture(perform: {
                                    
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

struct UpdateNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNicknameView()
    }
}
