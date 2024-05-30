//
//  OriginalSVGA.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/9.
//

import SwiftUI

//struct SVGAPlayerView_Gift: UIViewRepresentable {
//    var url:URL
//    var loops: Int
//    @Default(.room_show_gift_animation_svga) var room_show_gift_animation_svga
//    @Default(.me_dress_preview_svga_url_over) var me_dress_preview_svga_url_over
//    
//    func makeUIView(context: Context) -> SVGAPlayer {
//        let player = SVGAPlayer()
//        player.delegate = context.coordinator // Set delegate
//        let parser = SVGAParser()
//        parser.parse(with: url) { videoItem in
//            if let item = videoItem {
//                player.videoItem = item
//                player.loops = Int32(loops)
//                player.startAnimation()
//                player.clearsAfterStop = true
//            }
//        }
//
//        return player
//    }
//    
//    func updateUIView(_ uiView: SVGAPlayer, context: Context) { }
//    
//    func makeCoordinator() -> Coordinator {
//            Coordinator(self)
//        }
//        
//        class Coordinator: NSObject, SVGAPlayerDelegate {
//            let parent: SVGAPlayerView_Gift
//            
//            init(_ parent: SVGAPlayerView_Gift) {
//                self.parent = parent
//            }
//            
//            func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
//                parent.room_show_gift_animation_svga = false
//                parent.me_dress_preview_svga_url_over = ""
//            }
//        }
//}


//struct SVGAPlayerView: UIViewRepresentable {
//    var url: URL
//    var loops: Int
//
//    func makeUIView(context: Context) -> SVGAPlayer {
//        let player = SVGAPlayer()
//        let parser = SVGAParser()
//        parser.parse(with: url) { videoItem in
//            if let item = videoItem {
//                player.videoItem = item
//                player.loops = Int32(loops)
//                player.startAnimation()
//            }
//        }
//
//        return player
//    }
//    
//    func updateUIView(_ uiView: SVGAPlayer, context: Context) { }
//    
//}



//struct SVGAShow_Gift: View {
//    let url: String
//    @State var loops: Int = 0
//    var body: some View {
//        SVGAPlayerView_Gift(url: URL(string: url)!, loops: loops)
//    }
//}


//struct SVGAShow: View {
//    var url: String
//    @State var loops: Int = 0
//    
//    var body: some View {
//        if !url.isEmpty {
//            SVGAPlayerView(url: URL(string: url)!, loops: loops)
//                
//        }
//    }
//
//}



//struct UserInfoAvatarBorder: View {
//    @State var avatarBorder: String
//    let size: CGFloat
//    @State var plusSize: CGFloat = 20
//    var body: some View {
//        if let url = URL(string: avatarBorder) {
//            SVGAPlayerView(url: url, loops: 0)
//                .frame(width: size + plusSize, height: size + plusSize)
//        }
//        
//    }
//}
