//
//  SVGA_AvatarView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/9.
//

import SwiftUI

struct SVGA_AvatarView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            Spacer()
            Text("123")
//            SVGAPlayerView33(svgaSource: "posche")
//                .frame(width: 100, height: 100)
//                .background(Color.gray)
//            
//            SVGAPlayerView33(svgaSource: "posche3")
//                .frame(width: 100, height: 100)
//                .background(Color.blue)
//            
//            SVGAPlayerView33(svgaSource: "https://www.msyuyin.cn/upload/wares/3400261520482f3e8e1fe16cace1d057.svga")
//                .frame(width: 100, height: 100)
//                .background(Color.green)
            
            SVGAPlayerView33(svgaSource: "https://www.msyuyin.cn/upload/wares/36dcd3e4ec8f6ffd3536437e02a3adb8.svga")
                .frame(width: 100, height: 100)
                .background(Color.red)
            Spacer()
        }
        
    }
}

struct SVGAPlayerView33: UIViewRepresentable {
    let player = SVGAExPlayer()
    var svgaSource: String
    var loop: Int = 0

    func makeUIView(context: Context) -> SVGAExPlayer {
        player.play(svgaSource)
        player.isAnimated = true
        player.isEnabledMemoryCache = true
        player.isHidesWhenStopped = true
        player.loops = loop
        return player
    }

    func updateUIView(_ uiView: SVGAExPlayer, context: Context) {
        
    }
}
