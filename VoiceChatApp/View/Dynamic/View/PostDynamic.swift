// 发布动态

import SwiftUI
import PhotosUI

import ProgressHUD

struct PostDynamic: View {
    @StateObject var viewModel: DynamicViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .bold))
                    .padding(4)
                    .onTapGesture {
                        print("返回")
                        viewModel.isShowFullCoverSheet.toggle()
                    }
                Spacer()
                TopTrailingButtonView
            }
            .padding(.horizontal, 12)
            .overlay {
                Text("发布动态")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 18)  {
                    postTextView(inputText: $viewModel.inputText)
//                    PostDynamic_UpdataImageView(viewModel: viewModel)
                    EditDynamicImagesView(viewModel: viewModel)
                    TagsListView(items: viewModel.tagsArray, resultArray: $viewModel.resultArray)
                }
                .padding()
            }
        }
        .onDisappear {
            ProgressHUD.dismiss()
        }
        
    }
    var TopTrailingButtonView: some View {
        HStack(alignment: .center, spacing: 12)  {
            Button(action: {
                viewModel.postDynamicContent()
            }, label: {
                Text("发布")
                    .font(.headline)
                    .foregroundColor(viewModel.inputText.isEmpty || viewModel.inputText.count > 100 ? .gray : .blue)
            })
            .disabled(viewModel.inputText.isEmpty || viewModel.inputText.count > 100)
        }
    }
    
    
    
}


struct postTextView: View {
    @Binding var inputText: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack {
            TextEditor(text: $inputText)
                .foregroundColor(inputText.isEmpty ? Color.gray : Color.black)
                .onTapGesture {
                    if inputText.isEmpty {
                        inputText = ""
                    }
                }
                .overlay(
                    Text(inputText.isEmpty ? "有很多小伙伴都在等你发动态哦~" : "")
                        .foregroundColor(Color.gray)
                        .padding(.all, 8)
                    ,alignment: .topLeading
                )
                .frame(height: 120)
//                .padding()
                .focused($isFocused)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack(alignment: .center, spacing: 0)  {
                            Spacer()
                            Button(action: {
                                hideKeyboard()
                            }, label: {
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .font(.system(size: 14))
                            })
                        }
                    }
                }
            
            HStack {
                Spacer()
                Text("\(inputText.count)/100")
                    .foregroundColor(inputText.count > 100 ? Color.red : Color.gray)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
            }
        }
        .onAppear {
            isFocused = true
        }
    }
}



struct EditDynamicImagesView: View {
    @StateObject var viewModel: DynamicViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            if !viewModel.images.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                    ForEach(0..<viewModel.images.count, id: \.self) { index in
                        Image(uiImage: viewModel.images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 100)
                            .cornerRadius(10)
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "xmark.circle.fill")
                                    .scaledToFill()
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                    .padding(4)
                                    .onTapGesture {
                                        viewModel.images.remove(at: index)
                                    }
                            }
                    }
                    
                    if viewModel.images.count < 6 {
                        updataImageButton
                    }
                }
                
            } else if viewModel.images.count < 6 {
                updataImageButton
            }
        }
        .padding(.horizontal, 12)
        .sheet(isPresented: $viewModel.picker) {
            ImagePickerSecond(images: $viewModel.images, picker: $viewModel.picker, selectionLimit: 6)
        }
        .onChange(of: viewModel.images, perform: { newValue in
            if viewModel.images.count > 6 {
                viewModel.images.removeSubrange(6..<viewModel.images.count)
            }
        })
    }
    
    
    
    var updataImageButton: some View {
        Button(action: {
            viewModel.picker.toggle()
        }, label: {
            Image(systemName: "plus")
                .font(.title)
                .frame(height: 100)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.28)
                .foregroundColor(.black.opacity(0.3))
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        })
        
    }
}

struct TagsListView: View {
    let items: [String]
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    
    @Binding var resultArray: [String]
    
    
    init(items: [String], resultArray: Binding<[String]>) {
        self._resultArray = resultArray
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        return groupedItems
        
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4)  {
                ForEach(groupedItems, id: \.self) { subItems in
                    HStack(alignment: .center, spacing: 4)  {
                        ForEach(subItems, id: \.self) { word in
                            TagsItemView(content: word, add: {
                                resultArray.append(word)
                            }, del: {
                                resultArray.removeAll(where: { $0 == word })
                            })
                        }
                        
                    }
                }
            }
        }
        
    }
}

struct TagsItemView: View {
    let content: String
    let add: () -> Void
    let del: () -> Void
    @State var isSelected: Bool = false
    var body: some View {
        Button(action: {
            isSelected.toggle()
            if isSelected {
                add()
            } else {
                del()
            }
        }, label: {
            Text("#\(content)")
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(LinearGradient(colors: isSelected ? [Color(red: 0.758, green: 0.659, blue: 1.0), Color(red: 0.484, green: 0.462, blue: 1.001)] : [.gray.opacity(0.5)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(30)
        })
    }
}




