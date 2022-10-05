//
//  HomeView.swift
//  YZBox
//
//  Created by Apple on 10/3/22.
//

import SwiftUI

struct HomeView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var profileUIImage: UIImage?
    @State private var name: String = (UserDefaults.standard.string(forKey: "first_name")) ?? "Dr." + " " + (UserDefaults.standard.string(forKey: "last_name") ?? "Who")
    
    @State private var showingProfileImagePicker = false
    
    @State private var isLogoutView: Bool = false
    @State private var isUpdateNicknameView: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    //top
                    HStack {
                        VStack {
                            profileImage
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .onTapGesture(perform: {
                                    showingProfileImagePicker = true
                                })
                            
                            Text(name)
                                .onTapGesture(perform: {
                                    isUpdateNicknameView = true
                                })
                        }
                        Spacer()
                        
                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .onTapGesture(perform: {
                                isLogoutView = true
                            })
                    }
                    .frame(maxWidth:.infinity)
                    .padding()
                    //center
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: profileUIImage) { _ in loadProfileImage() }
            .sheet(isPresented: $showingProfileImagePicker) {
                ImagePicker(image: $profileUIImage)
            }
            .onAppear(perform: {
                getImageFromName()
            })
        }
        .fullScreenCover(isPresented: $isLogoutView, content: LogoutView.init)
        .fullScreenCover(isPresented: $isUpdateNicknameView, content: UpdateNicknameView.init)
        
    }
    
    func loadProfileImage() {
        guard let inputImage = profileUIImage else { return }
        profileImage = Image(uiImage: inputImage)
        if profileUIImage != nil {
            saveImageLocally(image: profileUIImage!)
        }
        
    }
    
    func saveImageLocally(image: UIImage) {
        
     // Obtaining the Location of the Documents Directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Creating a URL to the name of your file
        let fileName = UserDefaults.standard.string(forKey: "user_id") ?? "profile"
        let url = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            do {
                try data.write(to: url) // Writing an Image in the Documents Directory
            } catch {
                print("Unable to Write \(fileName) Image Data to Disk")
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



import PhotosUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
