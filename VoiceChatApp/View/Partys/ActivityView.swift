//
//  ActivityView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/7/29.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = context.coordinator
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Do nothing
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            // Handle Safari view controller dismissal
        }
    }
}


struct activityModel: Identifiable {
    let id: String = UUID().uuidString
    let actImgURL: String
    let actTimeRange: String
}



struct ActivityView: View {
    @State private var isShowingSafari = false
    @ObservedObject var viewModel = ActivityViewModel()
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
    ]
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0)  {
                LazyVGrid (columns: columns ) {
                    ForEach(viewModel.activityArray) { item in
                        VStack(spacing: 0)  {
                            if let imageURL = URL(string: item.img) {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                        .clipped()
                                    
                                } placeholder: {
                                    ProgressView()
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                        .clipped()
                                }
                            }
                            
                            
                            HStack(spacing: 0)  {
                                Text("\(formattedDateRange(from: item.start_time, to: item.end_time))")
                                Spacer()
                                
                                Button(action: {
                                    isShowingSafari = true
                                }) {
                                    Text("查看详情>")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .sheet(isPresented: $isShowingSafari) {
                                    if item.url.lowercased().hasPrefix("http") {
                                        SafariView(url: URL(string: item.url)!)
                                    } else {
                                        SafariView(url: URL(string: "http://\(item.url)")!)
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        
                    }
                }
                Spacer()
            }
        }
        
        
        
    }
    
    func formattedDateRange(from start: String, to end: String) -> String {
            guard let startDate = dateFormatter.date(from: start),
                  let endDate = dateFormatter.date(from: end) else {
                return ""
            }
            
            let startMonth = Calendar.current.component(.month, from: startDate)
            let startDay = Calendar.current.component(.day, from: startDate)
            
            let endMonth = Calendar.current.component(.month, from: endDate)
            let endDay = Calendar.current.component(.day, from: endDate)
            
            return "\(startMonth)月\(startDay)日-\(endMonth)月\(endDay)日"
        }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}


