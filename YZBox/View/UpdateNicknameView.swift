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
    @State private var name: String = "Dr.Who"
    
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
                                .scaledToFit()
                                .frame(width: 120, height: 120)
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
                                .frame(height: 60)
                                .foregroundColor(Color.gray)
                                .padding([.leading])
                                .border(Color.gray, width: 2)
                                .cornerRadius(5)
                                
                            Spacer()
                            
                            Text("Save")
                                .frame(maxWidth: geo.size.width * 0.75)
                                .frame(height: 60)
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
        }
    }
}

struct UpdateNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateNicknameView()
    }
}
