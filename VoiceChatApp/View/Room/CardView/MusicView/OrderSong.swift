
import SwiftUI
import AVKit

class AudioManger {
    static let instance = AudioManger()
    var player: AVAudioPlayer?
    
    func playSound(soundsURL: String) {
        guard let url = URL(string: soundsURL) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}




struct OrderSong: View {
    @StateObject var songListModel = SongListModel()
    var body: some View {
        VStack(spacing: 0)  {
            NavigationView {
                //            Button(action: {
                //                AudioManger.instance.playSound(soundsURL: "https://pic.ibaotu.com/17/95/96/616888piCS3M.mp3")
                //            }, label: {
                //                Text("play")
                //            })
                List(songListModel.orderSongArray) { song in
                    VStack(spacing: 0)  {
                        HStack(spacing: 0)  {
                            Image(systemName: "person")
                                .padding(.all, 5)
                                .background(Color.gray)
                                .clipShape(Circle())
                                .padding(.trailing, 5)
                            VStack(alignment: .leading) {
                                Text(song.name)
                                    .font(.footnote)
                                HStack(spacing: 0)  {
                                    Text("Artist: \(song.artist)")
                                    Text("Uploader: \(song.uploader)")
                                }
                                .foregroundColor(.gray)
                                .font(.caption)
                            }
                            Spacer()
                            HStack(spacing: 20) {
                                clickHeart2(isLikeed: song.isLike)
                                Button(action: {
                                    withAnimation {
                                        songListModel.deleteSong(from: &songListModel.orderSongArray, songToDelete: song)
                                    }
                                }) {
                                    Text("删除")
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 3)
                                        .background(Color.gray)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
//            player()
        }
    }
}







struct Song: Identifiable {
    let id = UUID()
    let name: String
    let artist: String
    let uploader: String
    var isLike: Bool
}


class SongListModel: ObservableObject {
    @Published var songArray: [Song] = []
    @Published var orderSongArray: [Song] = []
    
    init () {
        addSong()
        defAddOrderSong()
    }
    
    func addSong() {
        self.songArray.append(Song(name: "Song 1", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Song 2", artist: "Artist 2", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Song 3", artist: "Artist 3", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Song 4", artist: "Artist 4", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Song 5", artist: "Artist 5", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Song 6", artist: "Artist 6", uploader: "Uploader 1", isLike: true))
        self.songArray.append(Song(name: "Sony 7", artist: "Artist 7", uploader: "Uploader 1", isLike: true))
    }
    

    
    func searchSong(byName name: String) -> [Song] {
        return songArray.filter { $0.name.lowercased().contains(name.lowercased()) }
    }
    
    
    func addOrderSong(name: String, artist: String, uploader: String, isLike: Bool) {
        self.orderSongArray.append(Song(name: name, artist: artist, uploader: uploader, isLike: isLike))
    }
    
    func deleteSong(from array: inout [Song], songToDelete: Song) {
        if let index = array.firstIndex(where: { $0.id == songToDelete.id }) {
            array.remove(at: index)
        }
    }
    
    
    // test
    func defAddOrderSong() {
        self.orderSongArray.append(Song(name: "Song 1oo", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 2order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
        self.orderSongArray.append(Song(name: "Song 3order", artist: "Artist 1", uploader: "Uploader 1", isLike: true))
    }
    
}

