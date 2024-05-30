
import SwiftUI

struct PromptView: View {
    let promptText: String
    @State private var isHidden = true
    
    init(promptText: String, isHidden: Bool = false) {
        self.promptText = promptText
        self.isHidden = isHidden
    }
    
    var body: some View {
        if !isHidden {
            ZStack(alignment: .center) {
                Text(promptText)
                    .font(.subheadline)
                    .padding(.all, 3)
                    .foregroundColor(.red)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 7)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isHidden = true
                    }
                }
            }
        } else {
            VStack(alignment: .center, spacing: 0)  {
                Text("000")
            }
        }
    }
}


//struct PromptView_Previews: PreviewProvider {
//    static var previews: some View {
//        PromptView(promptText: "123")
//    }
//}
