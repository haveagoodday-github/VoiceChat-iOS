//
//  Feedback.swift
//  testProject
//
//  Created by MacBook Pro on 2023/8/26.
//

import SwiftUI


struct Feedback: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.966, green: 0.95, blue: 0.97)
                .ignoresSafeArea()
            
            
            VStack(alignment: .center, spacing: 12)  {
                feedbackFrom()
                addImages_optional()
                ContactInformation_optional()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle("我要反馈")
        .navigationBarItems(trailing: submitView())
    }
}




struct feedbackFrom: View {
    @State var FeedbackContent: String = ""
    @State var isPlaceholder: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6)  {
            HStack(alignment: .bottom, spacing: 3)  {
                Text("意见反馈")
                    .foregroundColor(Color(red: 0.879, green: 0.518, blue: 0.966))
                    .font(.system(size: 16, weight: .medium))
                Text("\(FeedbackContent.count)/300")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .light))
            }
            HStack(alignment: .top, spacing: 0)  {
                TextEditor(text: $FeedbackContent)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .frame(minHeight: 100)
            }
            
            Spacer()
        }
        .frame(height: 120)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        
    }
}

// 添加图片（选填，最多4张）
struct addImages_optional: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6)  {
            // 添加照片（选填，最多4张
            HStack(alignment: .bottom, spacing: 3)  {
                Text("添加照片（选填，最多4张")
                    .foregroundColor(Color(red: 0.879, green: 0.518, blue: 0.966))
                    .font(.system(size: 16, weight: .medium))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 18) {
                    updataImage()
                    updataImage()
                    updataImage()
                    updataImage()
                }
                .padding(12)
            }
            .frame(maxHeight: 150)
        }
        .frame(maxHeight: 150)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

// 添加图片View
struct addImagePlusItemView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, lineCap: .butt, dash: [4]))
                .frame(width: 60, height: 60)
            Image(systemName: "plus")
                .foregroundColor(.gray)
        }
    }
}




// 上传图片View
struct updataImage: View {
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    var body: some View {
        VStack {
            if let image = selectedImage {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(10)
                    
                    Button(action: {
                        selectedImage = nil
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.footnote)
                            .padding(4)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: 5, y: -5)
                    })
                }
            } else {
                Button(action: {
                    isImagePickerPresented.toggle()
                }, label: {
                    addImagePlusItemView()
                })
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                
            }
        }
    }
}



struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        picker.allowsEditing = false // 是否编辑图片
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


// 联系方式（选填）
struct ContactInformation_optional: View {
    @State var ContactInformationContent: String = ""
    @State var isPlaceholder: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6)  {
            HStack(alignment: .bottom, spacing: 3)  {
                Text("联系方式（选填）")
                    .foregroundColor(Color(red: 0.879, green: 0.518, blue: 0.966))
                    .font(.system(size: 16, weight: .medium))
            }
            HStack(alignment: .top, spacing: 0)  {
                TextEditor(text: $ContactInformationContent)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .frame(minHeight: 100)
            }
            
            Spacer()
        }
        .frame(height: 120)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}



struct submitView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("提交")
        })
    }
}



struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        Feedback()
        
    }
}
