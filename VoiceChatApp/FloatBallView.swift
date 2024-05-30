//
//  FloatBallView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/1/20.
//

import SwiftUI

import Defaults

struct floatModel: Codable, Defaults.Serializable {
    var headimgurl: String
    var roomName: String
    var roomId: Int
    var status: Bool
}

struct FloatBallView: View {
    @State private var dragAmount: CGPoint?
    @State private var isAnimation: Bool = false
    var floatValue: floatModel
    var openRoomAction: (() -> ())
    var closeAction: (() -> ())
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                VStack(alignment: .center, spacing: 0)  {
                    Spacer()
                    RoomFloatButtonView
                        .frame(width: 100, height: 50)
                        .position(dragAmount ?? CGPoint(x: geo.size.width - 90, y: geo.size.height - 100))
                        .gesture (
                            DragGesture()
                                .onChanged {
                                    self.dragAmount = $0.location
                                }
                                .onEnded { value in
                                    var currentPosition = value.location
                                      
                                    if currentPosition.x < (geo.size.width / 2) {
                                        currentPosition.x = 76
                                    } else {
                                        currentPosition.x = geo.size.width - 90
                                    }
                                    
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        dragAmount = currentPosition
                                    }
                                    
                                }
                        )
                }
            }
        }
        .onAppear {
            withAnimation(
                Animation
                    .linear(duration: 5)
                    .repeatForever(autoreverses: false)
            ) {
                isAnimation = true
            }
            
        }
        
    }
}

extension FloatBallView {
    var RoomFloatButtonView: some View {
        HStack(alignment: .center, spacing: 4)  {
            KFImageView_Fill(imageUrl: floatValue.headimgurl)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                .onTapGesture {
                    openRoomAction()
                }
                .rotationEffect(Angle(degrees: isAnimation ? 360 : 0))
            
            VStack(alignment: .leading, spacing: 12)  {
                Text(floatValue.roomName)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                Text(String(floatValue.roomId))
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 60, height: 35, alignment: .leading)
            .onTapGesture {
                openRoomAction()
            }

            
            Image(.viewFlowWindowClose)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    closeAction()
                }
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(30)
    }
}
