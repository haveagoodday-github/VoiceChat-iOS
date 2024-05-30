//
//  PointExchangeView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/28.
//

import SwiftUI

struct PointExchangeView: View {
    var PointsNumber: String
    @State private var payAmount: ConversionQuantityModel = ConversionQuantityModel(text: "0", amount: 0)
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.982, green: 0.982, blue: 0.997).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 12)  {
                Points
                ConversionQuantityView(payAmount: $payAmount)
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("积分兑换")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [Color(red: 0.993, green: 0.628, blue: 0.879), Color(red: 0.834, green: 0.474, blue: 0.997)], startPoint: .trailing, endPoint: .leading))
                .frame(height: 45)
                .overlay {
                    Text("确认支付")
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    print("确认支付")
                }
                .padding(.horizontal, 12)
        }
        
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
}

struct ConversionQuantityView: View {
    let col = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    @State var list: [ConversionQuantityModel] = [
        ConversionQuantityModel(text: "100", amount: 10),
        ConversionQuantityModel(text: "200", amount: 20),
        ConversionQuantityModel(text: "500", amount: 50),
        ConversionQuantityModel(text: "1000", amount: 1000),
        ConversionQuantityModel(text: "5000", amount: 5000),
        ConversionQuantityModel(text: "10000", amount: 10000),
        ConversionQuantityModel(text: "30000", amount: 30000),
        ConversionQuantityModel(text: "50000", amount: 50000),
        ConversionQuantityModel(text: "100000", amount: 100000)
    ]
    @Binding var payAmount: ConversionQuantityModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            Text("兑换数量")
            LazyVGrid(columns: col, content: {
                ForEach(list, id: \.amount) { item in
                    ConversionQuantityViewItem(item: item, isSelected: payAmount.amount == item.amount) {
                        payAmount = item
                    }
                }
            })
        }
    }
}



struct ConversionQuantityViewItem: View {
    let item: ConversionQuantityModel
    var isSelected: Bool
    var action: () -> ()
    var body: some View {
        VStack(alignment: .center, spacing: 8)  {
            Text("\(item.text) 积分")
                .foregroundColor(isSelected ? .purple : .black)
                .font(.system(size: 16))
            Text("\(String(item.amount))元")
                .foregroundColor(isSelected ? .purple.opacity(0.6) : .black.opacity(0.6))
                .font(.system(size: 14))
        }
        .frame(width: UIScreen.main.bounds.width * 0.3 , height: 70)
        .background(Color.white)
        .cornerRadius(10)
        .padding(1)
        .background(isSelected ? Color.purple : Color.clear)
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.purple.opacity(0.2))
//                    .stroke(.purple, lineWidth: 1, antialiased: true)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.purple)
                    .frame(width: 20, height: 12)
                    .overlay {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                    }
            }
        }
    }
}

struct ConversionQuantityModel: Decodable {
    let text: String
    let amount: Int
}
