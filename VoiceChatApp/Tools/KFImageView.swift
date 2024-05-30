//
//  KFImageView.swift
//  LanguageLink
//
//  Created by 吕海锋 on 2024/4/7.
//

import SwiftUI
import Kingfisher

struct KFImageView: View {
    var imageUrl: String
    var body: some View {
        KFImage(URL(string: imageUrl))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.5)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .scaledToFit()
    }
}



struct KFImageView_Fill: View {
    var imageUrl: String
    var body: some View {
        KFImage(URL(string: imageUrl))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.5)
            .placeholder {
                ProgressView()
            }
            .resizable()
            .scaledToFill()
    }
}
