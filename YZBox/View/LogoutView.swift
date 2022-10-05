//
//  LogoutView.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI
import CoreData

struct LogoutView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var name: String = "Dr.Who"
    
    @State private var isHomeView: Bool = false
    
    var body: some View {
        if isHomeView {
            HomeView()
        }
        else {
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
                                Text("Upgrade Pro")
                                    .frame(maxWidth: geo.size.width * 0.75)
                                    .frame(height: 60)
                                    .background(Color.pink)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                    
                                Spacer()
                                Text("Log Out")
                                    .frame(maxWidth: geo.size.width * 0.75)
                                    .frame(height: 60)
                                    .background(Color.pink)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture(perform: {
                                        isHomeView = true
                                    })
                                
                                Text("Delete Account")
                                    .frame(maxWidth: geo.size.width * 0.75)
                                    .frame(height: 60)
                                    .background(Color.pink)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                                    .onTapGesture(perform: {
                                        deleteAccount()
                                        isHomeView = true
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
    
    private func deleteAccount() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "YZBox_user")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["user_id", UserDefaults.standard.string(forKey: "user_id")!])
        
        do {
            let test = try self.viewContext.fetch(fetchRequest)
            
            if test.count > 0 {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(false, forKey: "active")
                
                do {
                    try self.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
            
        }
        catch let error as NSError{
            fatalError("Couldn't fetch. \(error), \(error.userInfo)")
        }
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        LogoutView()
    }
}
