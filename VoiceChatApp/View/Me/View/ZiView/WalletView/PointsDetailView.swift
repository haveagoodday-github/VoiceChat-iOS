//
//  PointsDetailView.swift
//  TestForVoiceChatApp
//
//  Created by 吕海锋 on 2023/12/28.
//


// 积分兑换 - 明细
import SwiftUI





struct PointsDetailModel: Decodable {
    let code: Int
    let message: String
    let data: [data]?
    
    struct data: Decodable {
        let id: Int
        let user_id: Int
        let mibi: String
        let addtime: String
        
    }
}

struct PointsDetailWithdrawModel: Decodable {
    let code: Int
    let message: String
    let data: [data]?
    
    struct data: Decodable {
        let id: Int
        let user_id: Int
        let title: String
        let money: String
        let addtime: String
    }
}


class PointsDetail: ObservableObject {
    @Published var exchangeRecord: [PointsDetailModel.data] = []
    @Published var withdrawalRecord: [PointsDetailWithdrawModel.data] = []
    
    
    init() {
        self.getExchangeRecord()
        self.getWithdrawalRecord()
    }
    
    // MARK: 获取兑换记录
    func getExchangeRecord(userId: Int = 1111239, page: Int = 1) {
        guard let url = URL(string: "\(baseUrl.url)api/exchange_log?user_id=\(String(userId))&page=\(String(page))") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("vRyrBnn8vnzi5Ggr1oshTgvMH+iG6MSXhjdli/7uyHtzMaRJfn4E+y+dZVxhB9sK", forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(PointsDetailModel.self, from: data)
                    debugPrint("getExchangeRecord \(result.message)")
                    DispatchQueue.main.async {
                        self.exchangeRecord = result.data ?? []
                    }
                } else {
                    debugPrint("getExchangeRecord other result：No data")
                }
            } catch(let error) {
                debugPrint("getExchangeRecord function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    // MARK: 获取提现记录
    func getWithdrawalRecord(userId: Int = 1111239) {
        guard let url = URL(string: "\(baseUrl.url)api/tixian_log?user_id=\(String(userId))") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("vRyrBnn8vnzi5Ggr1oshTgvMH+iG6MSXhjdli/7uyHtzMaRJfn4E+y+dZVxhB9sK", forHTTPHeaderField: "Token")
        URLSession.shared.dataTask(with: request) { [weak self] (data, res, err) in
            guard let self = self else { return }
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(PointsDetailWithdrawModel.self, from: data)
                    debugPrint("getWithdrawalRecord \(result.message)")
                    DispatchQueue.main.async {
                        self.withdrawalRecord = result.data ?? []
                    }
                } else {
                    debugPrint("getWithdrawalRecord other result：No data")
                }
            } catch(let error) {
                debugPrint("getWithdrawalRecord function Error result：\(error.localizedDescription)")
            }
        }.resume()
    }
}

struct PointsDetailView: View {
    let max_index: Int = 3
    @State var index: Int = 1
    @State var offset: CGFloat = 0
    var width = UIScreen.main.bounds.width
    @StateObject private var vm: PointsDetail = PointsDetail()
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.982, green: 0.982, blue: 0.997).ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 8)  {
                AppBar_DiamondDetailView(index: $index, offset: $offset)
                GeometryReader { g in
                    HStack(spacing: 0)  {
                        
                        PointsDetailListView(list: vm.exchangeRecord)
                            .frame(width: g.frame(in: .global).width)
                        PointsDetailWithdrawListView(list: vm.withdrawalRecord)
                            .frame(width: g.frame(in: .global).width)
                        PointsDetailListView(list: [])
                            .frame(width: g.frame(in: .global).width)

                        
                    }
                    .offset(x: offset)
                    .highPriorityGesture(DragGesture()
                        .onEnded({ value in
                            if value.translation.width > 50 {
                                changeView(left: false)
                            }
                            if -value.translation.width > 50 {
                                changeView(left: true)
                            }
                        })
                    )
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default)
        }
        .navigationTitle("明细")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    func changeView(left : Bool) {
        if left {
            if index != max_index {
                index += 1
            }
        } else {
            if index != 1 {
                index -= 1
            }
        }
        
        switch(index) {
        case 1:
            offset = 0
        case 2:
            offset = -width
        default:
            offset = 2 * -width
        }

    }
}

struct AppBar_PointsDetailView: View {
    @Binding var index: Int
    @Binding var offset: CGFloat
    var width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .center, spacing: 10)  {
            TopButtonViewItem_DiamondDetailView(text: "兑换记录", isSelected: index == 1) {
                index = 1
                offset = 0
            }
            TopButtonViewItem_DiamondDetailView(text: "提现记录", isSelected: index == 2) {
                index = 2
                offset = -width
            }
            TopButtonViewItem_DiamondDetailView(text: "其他记录", isSelected: index == 3) {
                index = 3
                offset = 2 * -width
            }

        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        
    }
}


struct PointsDetailListView: View {
    var list: [PointsDetailModel.data]
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            ForEach(list, id: \.id) { item in
                PointsDetailListViewItem(item: item)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct PointsDetailWithdrawListView: View {
    var list: [PointsDetailWithdrawModel.data]
    var body: some View {
        VStack(alignment: .center, spacing: 12)  {
            ForEach(list, id: \.id) { item in
                PointsDetailWithdrawListViewItem(item: item)
            }
        }
        .padding(.horizontal, 12)
    }
}


struct PointsDetailWithdrawListViewItem: View {
    let item: PointsDetailWithdrawModel.data

    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            VStack(alignment: .leading, spacing: 12)  {
                Text(item.title)
                Text("id:\(String(item.user_id))")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12)  {
                Text(item.money)
                Text(item.addtime)
                    .foregroundColor(.gray)
            }
            
        }
        .padding(16)
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(10)
    }
}


struct PointsDetailListViewItem: View {
    let item: PointsDetailModel.data

    var body: some View {
        HStack(alignment: .center, spacing: 0)  {
            VStack(alignment: .leading, spacing: 12)  {
                Text("积分兑换")
                Text("id:\(String(item.user_id))")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 12)  {
                Text(item.mibi)
                Text(item.addtime)
                    .foregroundColor(.gray)
            }
            
        }
        .padding(16)
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(10)
    }
}

