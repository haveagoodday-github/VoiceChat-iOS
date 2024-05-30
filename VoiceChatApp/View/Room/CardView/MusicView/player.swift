//
//  player.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2023/8/10.
//

import SwiftUI
import AVKit

let url = Bundle.main.path(forResource: "audio1", ofType: "mp3")

//struct player: View {
//    @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
//    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
//    @StateObject var album = album_Data()
//    @State var animatedValue: CGFloat = 55
//    @State var time: Float = 0
//    var body: some View {
//        VStack(spacing: 0)  {
//            
//            // 显示歌曲名称，歌手
////            HStack(spacing: 0)  {
////                VStack(alignment: .leading, spacing: 8)  {
////                    Text(album.title)
////                        .fontWeight(.semibold)
////                    HStack(spacing: 10)  {
////                        Text(album.artist)
////                            .font(.caption)
////                        Text(album.type)
////                            .font(.caption)
////                    }
////                }
////            }
//            
//            // 显示歌曲图片
////            if album.artwork.count != 0 {
////                Image(uiImage: UIImage(data: album.artwork)!)
////                    .resizable()
////                    .frame(width: 250, height: 250)
////                    .cornerRadius(15)
////            }
//            
//            ZStack {
//                        
//                HStack(spacing: 15)  {
//                    Button(action: {
//                        play()
//                    }, label: {
//                        Image(systemName: album.isPlaying ? "pause.fill" : "play.fill")
//                            .foregroundColor(.green)
//                            .frame(width: 55, height: 55)
//                            .background(Color.gray.opacity(0.4))
//                            .cornerRadius(10)
//                    })
//                    
//                    Button(action: {
////                        play()
//                    }, label: {
//                        Image(systemName: "forward.end.fill")
//                            .foregroundColor(.green)
//                            .frame(width: 55, height: 55)
//                            .background(Color.gray.opacity(0.4))
//                            .cornerRadius(10)
//                    })
//                    
//                    Button(action: {
////                        play()
//                    }, label: {
//                        Image(systemName: "goforward")
//                            .foregroundColor(.green)
//                            .frame(width: 55, height: 55)
//                            .background(Color.gray.opacity(0.4))
//                            .cornerRadius(10)
//                    })
//                    
//                    Button(action: {
////                        play()
//                    }, label: {
//                        Image(systemName: "speaker.wave.2")
//                            .foregroundColor(.green)
//                            .frame(width: 55, height: 55)
//                            .background(Color.gray.opacity(0.4))
//                            .cornerRadius(10)
//                    })
//                }
//                
//            }
//            .padding(.top, 25)
//            
//            Slider(value: Binding(get: {time}, set: { newValue in
//                time = newValue
//                audioPlayer.currentTime = Double(time) * audioPlayer.duration
//            }))
//            .padding()
//            
//        }
//        .onReceive(timer) { (_) in
//            if audioPlayer.isPlaying {
//                audioPlayer.updateMeters()
//                album.isPlaying = true
//                time = Float(audioPlayer.currentTime / audioPlayer.duration )
////                    print(audioPlayer.currentTime)
//            } else {
//                album.isPlaying = false
//            }
//        }
//        .onAppear(perform: getAudioData)
//    }
//    func play() {
//        if audioPlayer.isPlaying {
//            audioPlayer.pause()
//        } else {
//            audioPlayer.play()
//        }
//    }
//    
//    func getAudioData() {
//        
//        audioPlayer.isMeteringEnabled = true
//        
//        let asset = AVAsset(url: audioPlayer.url!)
//        
//        asset.metadata.forEach { meta in
//            switch(meta.commonKey?.rawValue) {
//            case "artwork": album.artwork = meta.value == nil ? UIImage(named: "any sample pic...")!.pngData()! : meta.value as! Data
//            case "artist": album.artist = meta.value == nil ? "" : meta.value as! String
//            case "type": album.type = meta.value == nil ? "" : meta.value as! String
//            case "title": album.title = meta.value == nil ? "" : meta.value as! String
//            default : ()
//            }
//        }
//    }
//    
//    func startAnimation() {
//        var power: Float = 0
//        
//        for i in 0..<audioPlayer.numberOfChannels {
//            power += audioPlayer.averagePower(forChannel: i)
//        }
////        print(power)
//        
//        let value = max(0, power + 55)
//        
//        let animated = CGFloat(value) * (UIScreen.main.bounds.width / 2.0)
//        
//        withAnimation(Animation.linear(duration: 0.01)) {
//            self.animatedValue = animated
//        }
//        
//    }
//}



class album_Data: ObservableObject {
    @Published var isPlaying = false
    @Published var title = ""
    @Published var artist = ""
    @Published var artwork = Data(count: 0)
    @Published var type = ""
}


//
//struct player_Previews: PreviewProvider {
//    static var previews: some View {
//        player()
//    }
//}
//
