// 任务中心
import SwiftUI

struct MissionCenter: View {
    @StateObject private var viewModel = TaskViewModel()
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            LinearGradient(
                gradient: Gradient(colors: [Color.yellow.opacity(0.9), Color.white]),
                        startPoint: .top,
                        endPoint: .init(x: 0.5, y: 0.3) // 这里控制渐变到百分之四十的位置
                    )
                    .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 0)  {
                    DailyCheckInView()
                    NoviceTaskView(viewModel: viewModel.noviceTaskArray, taskTitle: "新手任务")
                    NoviceTaskView(viewModel: viewModel.dailyTaskArray, taskTitle: "日常任务")
                }
                .padding()
            }
        }
        .navigationBarTitle("任务中心", displayMode: .inline)
    }
}

struct DailyCheckInView: View {
    let jinbiArray: [Int] = [1,2,3,4,5,6,10]
    var body: some View {
        VStack(alignment: .leading, spacing: 12)  {
            Text("每日签到")
                .fontWeight(.bold)
                .font(.subheadline)
            ScrollView(.horizontal) {
                HStack(alignment: .center, spacing: 8)  {
                    ForEach(Array(jinbiArray.enumerated()), id: \.element) { index, jinbi in
                        VStack(alignment: .center, spacing: 4)  {
                            Image(.jinbi)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text("\(jinbi)金币")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .font(.footnote)
                            Text("第\(numberToChinese(number: index+1))天")
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.all, 4)
            }
            
            HStack(alignment: .center, spacing: 0)  {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("立即签到")
                        .frame(maxWidth: 270)
                        .padding(.vertical, 5)
                        .background(Color(red: 0.555, green: 0.804, blue: 0.195))
                        .cornerRadius(30)
                        .foregroundColor(.white)
                        .font(.title3)
                })
                Spacer()
            }
            
        }
        .padding(.all, 12)
        .background(Color.white)
        .cornerRadius(10)
        
        
        
        
    }
    
    func numberToChinese(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        numberFormatter.locale = Locale(identifier: "zh_CN")
        
        if let chineseNumber = numberFormatter.string(from: NSNumber(value: number)) {
            return chineseNumber
        } else {
            return ""
        }
    }
}


struct TaskModel: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let icon: String
    let taskInfo: String
    let taskRewards: String
    let status: String
    let allNum: String
    let doneNum: String
}


class TaskViewModel: ObservableObject {
    @Published var noviceTaskArray: [TaskModel] = []
    @Published var dailyTaskArray: [TaskModel] = []
    
    init () {
        getNoviceTaskArray()
        getDailyTaskArray()
    }
    
    func getNoviceTaskArray() {
        self.noviceTaskArray.append(TaskModel(icon: "task_01", taskInfo: "完善个人资料（性别、签名、年龄、所在地、个性标签、星座)", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.noviceTaskArray.append(TaskModel(icon: "task_02", taskInfo: "个人主页上传图片（不包括头像）", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.noviceTaskArray.append(TaskModel(icon: "task_03", taskInfo: "关注一个语音房间", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.noviceTaskArray.append(TaskModel(icon: "task_04", taskInfo: "发布一条动态", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
    }
    
    func getDailyTaskArray() {
        self.dailyTaskArray.append(TaskModel(icon: "task_09", taskInfo: "语音房间玩5分钟", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.dailyTaskArray.append(TaskModel(icon: "task_07", taskInfo: "赠送他人5次礼物", taskRewards: "+5金币奖励", status: "undone", allNum: "5", doneNum: "0"))
        self.dailyTaskArray.append(TaskModel(icon: "task_08", taskInfo: "分享一次语音房间", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.dailyTaskArray.append(TaskModel(icon: "task_10", taskInfo: "评论三条动态", taskRewards: "+5金币奖励", status: "undone", allNum: "3", doneNum: "0"))
        self.dailyTaskArray.append(TaskModel(icon: "task_04", taskInfo: "发布一条动态", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.dailyTaskArray.append(TaskModel(icon: "task_11", taskInfo: "每日充值1次6元", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
        self.dailyTaskArray.append(TaskModel(icon: "task_11", taskInfo: "每日充值1次30元", taskRewards: "+5金币奖励", status: "undone", allNum: "", doneNum: ""))
    }
}

struct NoviceTaskView: View {
    @State var viewModel: [TaskModel]
    let taskTitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12)  {
            Text(taskTitle)
                .fontWeight(.bold)
                .font(.subheadline)
            
            ForEach(viewModel, id: \.self) { nt in
                HStack(alignment: .center, spacing: 5)  {
                    Image(nt.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 3)  {
                        if nt.taskInfo.count > 16 {
                            
                            Text(nt.taskInfo)
                                .font(.footnote)
                            +
                            Text(nt.doneNum.isEmpty && nt.allNum.isEmpty ? "" : "（\(nt.doneNum)/\(nt.allNum)）")
                                .font(.footnote)
                            +
                            Text(nt.taskRewards)
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text(nt.taskInfo)
                                .font(.footnote)
                            +
                            Text(nt.doneNum.isEmpty && nt.allNum.isEmpty ? "" : "（\(nt.doneNum)/\(nt.allNum)）")
                                .font(.footnote)
                            Text(nt.taskRewards)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("去完成")
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 3)
                            .background(Color(red: 0.555, green: 0.804, blue: 0.195))
                            .cornerRadius(30)
                        
                    })
                }
            }
        }
        .padding(.all, 12)
        .background(Color.white)
        .cornerRadius(10)
    }
}




struct MissionCenter_Previews: PreviewProvider {
    static var previews: some View {
        MissionCenter()
    }
}
