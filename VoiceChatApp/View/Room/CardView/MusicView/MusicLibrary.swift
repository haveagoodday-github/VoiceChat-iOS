import SwiftUI


enum MusicLibraryModel: String, CaseIterable {
    case myCollect = "我的收藏"
    case shareMusic = "共享音乐"
}

struct MusicLibrary: View {
    @State private var musicLibraryType: MusicLibraryModel = .myCollect
    @State private var searchText = ""
//    @StateObject var songListModel: SongListModel
    @StateObject var songListModel = SongListModel()
    @State private var filteredSongs: [Song] = []
    var body: some View {
        VStack(spacing: 0)  {
            HStack(alignment: .center, spacing: 0)  {
                Picker("", selection: $musicLibraryType) {
                    ForEach(MusicLibraryModel.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Image(systemName: "magnifyingglass") // 放大镜图标
                    .foregroundColor(.gray)
                
                TextField("搜索", text: $searchText, onCommit: {
                    filteredSongs = songListModel.searchSong(byName: searchText)
                    print(filteredSongs)
                })
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
                .onChange(of: searchText) { newValue in
                    filteredSongs = songListModel.searchSong(byName: newValue)
                    print(filteredSongs)
                }
                
            }
            .padding(.horizontal, 10)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding()
            
            NavigationView {
                List(filteredSongs.isEmpty || searchText.isEmpty ? songListModel.songArray : filteredSongs) { song in
                    VStack(spacing: 0)  {
                        HStack(spacing: 0)  {
                            VStack(alignment: .leading) {
                                Text(song.name)
                                    .font(.headline)
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
                                    songListModel.addOrderSong(name: song.name, artist: song.artist, uploader: song.uploader, isLike: song.isLike)
                                }) {
                                    Text("点歌")
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
            Spacer()
        }
    }
    
}


struct clickHeart2: View {
    @State var isLikeed: Bool
    
    var body: some View {
        
        Button {
            self.isLikeed.toggle()
        } label: {
            HStack(spacing: 5)  {
                ZStack {
                    image(Image(systemName: "heart.fill"), show: isLikeed)
                    image(Image(systemName: "heart"), show: !isLikeed)
                }
                
            }
        }
        
    }

    func image(_ image: Image, show: Bool) -> some View {
        image
            .tint(isLikeed ? .red : .gray)
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
        
    }
    
}



