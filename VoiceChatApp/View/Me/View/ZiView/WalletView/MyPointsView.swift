//
//  MyPointsView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/28.
//

import SwiftUI




struct MyPointsView: View {
    var PointsNumber: String
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.982, green: 0.982, blue: 0.997).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12)  {
                Points
                NavigationLink(destination: PointExchangeView(PointsNumber: PointsNumber)) {
                    MyPointsViewButtonItem(t1: "积分兑换", t2: "1积分等于1钻石/1K积分起兑换")
                }
                
                MyPointsViewButtonItem(t1: "积分提现", t2: "有提现问题请联系官方客服")
                    .modifier(PointWithdrawalViewFullCover(PointsNumber: PointsNumber))
                
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("我的积分")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: trailingButton)
    }
    
    var Points: some View {
        ZStack(alignment: .topLeading) {
                    LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .bottomTrailing, endPoint: .topLeading)
                        .frame(height: 120)
                        .cornerRadius(10)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(-30))
                                .offset(x: 35, y: 35)
                                .clipped()
                        }
                    
                    VStack(alignment: .leading, spacing: 18)  {
                        Text("可使用积分余额")
                            .font(.system(size: 18))
                        Text(PointsNumber)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(12)
                }
    }
    
    var trailingButton: some View {
        NavigationLink(destination: PointsDetailView()) {
            Text("明细")
                .foregroundColor(.black)
        }
    }
}

struct MyPointsViewButtonItem: View {
    let t1: String
    let t2: String
    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            VStack(alignment: .leading, spacing: 8)  {
                Text(t1)
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .bold))
                Text(t2)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            Spacer()
            
            Image(systemName: "chevron.forward")
                .foregroundColor(.gray)
                .font(.system(size: 16))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(10)
    }
}


