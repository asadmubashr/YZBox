//
//  TabsView.swift
//  YZBox
//
//  Created by Apple on 10/5/22.
//

import SwiftUI

struct TabsView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State public var tabViewSelection = 3
    
    var body: some View {
        TabView(selection: $tabViewSelection) {
            OtherView()
                .tabItem{
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("LearnMode")
                        .font(.system(size: 14))
                }
                .tag(0)
            
            OtherView()
                .tabItem{
                    Image(systemName: "circle")
                    Text("Eg-Cn")
                }
                .tag(1)
            
            OtherView()
                .tabItem{
                    Image(systemName: "circle")
                    Text("Cn-Eg")
                }
                .tag(2)
            
            HomeView()
                .tabItem{
                    profileImage
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text("Mine")
                }
                .tag(3)
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

//struct TabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsView()
//    }
//}


struct OtherView: View {
    var body: some View {
        Text("")
    }
}
