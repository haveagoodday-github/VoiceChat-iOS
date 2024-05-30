

import SwiftUI

//struct LoadingView: View {
//    @State var show = false
//    var body: some View {
//        VStack(alignment: .center, spacing: 0)  {
//            
//        }
//    }
//}


struct Loader: View {
    let loadingText: String
    let isLoadAnimation: Bool
    let loadingTextColor: Color
    @State var animate: Bool
    
    init(loadingText: String, isLoadAnimation: Bool, loadingTextColor: Color = .black, animate: Bool) {
        self.loadingText = loadingText
        self.isLoadAnimation = isLoadAnimation
        self.loadingTextColor = loadingTextColor
        self.animate = animate
    }
    
    var body: some View {
        VStack  {
            if isLoadAnimation {
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(AngularGradient(gradient: .init(colors: [.red, .orange]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                    .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            }
            
            
            Text("加载中...")
                .foregroundColor(loadingTextColor)
                .padding(.top)
        }
        .padding(20)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(15)
        .onAppear {
            self.animate.toggle()
        }
    }
}


//struct LoadingView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView()
//    }
//}
