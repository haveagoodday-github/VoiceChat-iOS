
import SwiftUI

struct GetModel_getCarousel: Decodable {
    let code: Int
    let message: String
    let data: [CarouselItem]
}
struct CarouselItem: Decodable, Identifiable {
    let id: Int
    let img: String
}
// 获取顶部轮播图
class CarouselViewModel: ObservableObject {
//    @State private var api = myAPI()
    @Published var carouselItems: [CarouselItem] = []
    
    init() {
        getCarousel()
    }
    
    func getCarousel() {
        
        NetworkTools.requestAPI(convertible: "api/carousel?type=0", responseDecodable: GetModel_getCarousel.self) { result in
            self.carouselItems = result.data
        } failure: { _ in
            
        }

        
//        api.loadAPI(getUrl: "\(baseUrl.url)api/carousel?type=0", resultType: GetModel_getCarousel.self) { (result: Result<GetModel_getCarousel, Error>) in
//            switch result {
//            case .success(let response):
////                print("Success:", response)
//                self.carouselItems = response.data
//            case .failure(let error):
//                print("Error:", error)
//            }
//        }
        
        
    }
    
}
