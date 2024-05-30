# 深圳职业技术大学2024届毕业生毕业设计（论文）

- 第二章 关键技术介绍  10
  - 2 多平台支持的关键技术选择与实现  10
    - 2.1.1 HTTP服务  10
    - 2.1.2 Alamofire框架概述  10
    - 2.1.3 选型依据  10
    - 2.2 图片加载  11
      - 2.2.1 Kingfisher框架概述  11
      - 2.2.2 选型依据  11
    - 2.3 WebSocket网络通信协议  11
      - 2.3.1 Starscream框架概述  11
      - 2.3.2 选型依据  11
    - 2.4 Linphone框架概述  12
      - 2.4.1.1 选型依据  12
    - 2.5 MVVM开发模式  12
      - 2.5.1 MVVM开发模式概述  12
      - 2.5.2 选型依据  13
    - 2.6 CocoPods管理标准库  13
      - 2.6.1 CocoPods概述  13
      - 2.6.2 选型依据  13
    - 2.7 本章小结  13
- 第三章 语聊APP详细设计  15
  - 3 系统关键功能的具体实现  15
    - 3.1 面向对象编程思想的应用  15
      - 3.1.1 模块封装  15
      - 3.1.2 继承与扩展  16
    - 3.2 网络请求的二次封装  16
      - 3.2.1 基础封装  16
      - 3.2.2 图片上传封装  17
    - 3.3 图片显示的二次封装  17
    - 3.4 WebSocket网络通信  18
      - 3.4.1 本章小结  19


## 第二章 关键技术介绍
### 2 多平台支持的关键技术选择与实现
在开发iOS语聊APP过程中，我们采用了多种关键技术。为了确保应用在未来能够支持多个平台（如macOS、tvOS、watchOS、Android和Windows），我们在选择框架和工具时进行了慎重考虑。本章将详细介绍应用中采用的关键技术及其选型依据，包括HTTP服务、图片加载、WebSocket网络通信协议、MVVM开发模式、Linphone框架以及CocoPods依赖管理工具，框架流程如图2-1所示：


#### 2.1.1 HTTP服务
在前后端交互方面，HTTP服务是应用程序与服务器通信的基础。考虑到未来可能支持多个平台，我们选择了最为主流的Alamofire框架作为iOS客户端的HTTP服务解决方案。

#### 2.1.2 Alamofire框架概述
Alamofire是一个基于Swift语言的HTTP网络库，提供了简单优雅的API，用于处理网络请求和响应。它内置了许多功能，如数据请求、文件上传下载、JSON解析、认证处理等，极大简化了HTTP服务的开发工作。

#### 2.1.3 选型依据
- **跨平台支持**，Alamofire不仅支持iOS平台，还支持macOS、tvOS和watchOS，这使得应用在未来扩展到其他苹果设备时，能够继续使用该框架，减少了迁移和维护成本。
- **性能与稳定性**，Alamofire在处理网络请求方面表现出色，具备高性能和稳定性。它的异步请求机制能够有效避免主线程阻塞，提高了用户体验。
- **社区支持**，Alamofire拥有庞大的开发者社区和丰富的文档资源，开发者可以方便地获取支持和参考资料，提升开发效率。

### 2.2 图片加载
图片加载和显示是应用中不可或缺的功能。为了确保图片加载的高效性和流畅性，我们选择了Kingfisher框架。

#### 2.2.1 Kingfisher框架概述
Kingfisher是一个强大的Swift库，专为图片下载和缓存设计。它提供了异步下载、内存缓存和磁盘缓存、占位图支持等功能，能够满足应用中各种图片处理需求。

#### 2.2.2 选型依据
- **多平台支持**，Kingfisher支持iOS、macOS、tvOS和watchOS，适应了我们未来多平台扩展的需求。
- **缓存机制**，Kingfisher提供了内存缓存和磁盘缓存机制，能够显著提升图片加载的效率，减少网络请求次数，优化用户体验。
- **易用性**，Kingfisher的API设计简洁易用，支持链式调用，方便开发者快速实现图片加载和显示功能。

### 2.3 WebSocket网络通信协议
为了实现高效的实时通信，我们选择了Starscream框架作为iOS客户端的WebSocket网络通信协议。

#### 2.3.1 Starscream框架概述
Starscream是一个适用于Swift的WebSocket库，提供了WebSocket协议的完整实现。它支持连接管理、数据传输、心跳机制、错误管理和多线程操作，确保WebSocket通信的稳定性和高效性。

#### 2.3.2 选型依据
- **符合Swift开发语言的要求**，Starscream完全用Swift编写，完美契合iOS开发环境，能够充分利用Swift的语言特性，提高开发效率。
- **线程安全**，Starscream提供了Swift GCD自定义队列，确保多线程环境下的线程安全，避免数据竞争和死锁问题。
- **后台托管**，Starscream支持后台连接管理和数据传输，能够在应用进入后台时继续保持WebSocket连接，确保实时通信的连续性。

### 2.4 Linphone框架概述
Linphone是一个强大的开源库，提供了完整的SIP协议实现，支持语音通话、视频通话和即时消息。它适用于各种呼叫、在线状态和IM功能。

#### 2.4.1.1 选型依据
- **基于SIP协议**：Linphone完全基于SIP协议，确保了语音和视频通话的标准化和互操作性。
- **开源与灵活性**：作为一个开源项目，Linphone提供了高可定制性和灵活性，开发者可以根据需要进行二次开发和优化。
- **多平台支持**：Linphone支持多个平台，包括iOS、Android、Windows和Linux，使其成为跨平台语音和视频通信的理想选择。

### 2.5 MVVM开发模式
为了提升代码的可维护性和可扩展性，我们在应用中采用了MVVM（Model-View-ViewModel）开发模式。

#### 2.5.1 MVVM开发模式概述
MVVM架构是一种设计模式，旨在分离UI和业务逻辑。它将应用程序划分为Model、View和ViewModel三个部分，MVVM开发模式流程如图2-2所示：
- **Model**：负责处理数据逻辑和业务规则。
- **View**：负责呈现UI界面。
- **ViewModel**：作为View与Model之间的桥梁，负责处理界面逻辑并将数据传递给View。

![MVVM开发模式流程图](https://github.com/haveagoodday-github/VoiceChat-iOS/assets/81958418/0ec9411c-0b2a-48c6-9efe-270f0353783d)

#### 2.5.2 选型依据
- **提升代码可维护性**，通过将 UI 和业务逻辑分离，MVVM 开发模式使代码更加模块化，易于维护和扩展。
- **增强可测试性**，MVVM 开发模式使得业务逻辑可以独立于 UI 进行单元测试，提高了代码的可靠性。
- **提高开发效率**，MVVM 模式通过数据绑定机制，使得数据和 UI 状态保持同步，减少了手动更新 UI 的工作量，提高了开发效率。

### 2.6 CocoPods管理标准库
为了简化第三方库的集成和管理，我们选择使用CocoPods作为依赖管理工具。

#### 2.6.1 CocoPods概述
CocoPods是一个iOS和macOS项目的依赖管理工具，它使用一个名为Podfile的文件来指定项目依赖库，并自动处理依赖关系。CocoPods可以简化第三方库的集成和管理过程，确保项目中的所有依赖库版本一致，避免由于版本差异导致的兼容性问题。

#### 2.6.2 选型依据
- **简化依赖管理**，CocoPods能够
```swift
final class Socket: WebSocketDelegate {
    static let shared = Socket()
    
    private var webSocket: WebSocket!
    
    init() {
        var request = URLRequest(url: URL(string: "wss://your.websocket.url")!)
        request.timeoutInterval = 5
        webSocket = WebSocket(request: request)
        webSocket.delegate = self
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("WebSocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("WebSocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            print("Received text: \(text)")
            NotificationCenter.default.post(name: .receiveNewRoomMessage, object: nil, userInfo: ["message": text])
        case .binary(let data):
            print("Received data: \(data)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("WebSocket connection cancelled")
        case .error(let error):
            print("WebSocket encountered an error: \(String(describing: error))")
        }
    }
}

extension Socket {
    func connect() {
        webSocket.connect()
    }
    
    func disconnect() {
        webSocket.disconnect()
    }

    func write(with string: String) {
        webSocket.write(string: string)
    }
}
```
通过定义Socket类并实现WebSocketDelegate协议，我们实现了WebSocket连接的监听和管理。设计为单例模式确保了整个APP生命周期内的WebSocket连接管理，避免了多个连接的资源占用问题。

### 3.4.1 本章小结
本章详细介绍了语聊APP的设计思路和实现方法。通过采用面向对象编程思想，我们实现了功能模块的高效分离和封装，提高了代码的重用性和可维护性。通过对Alamofire和Kingfisher框架的二次封装，我们提升了网络请求和图片加载的性能和稳定性。通过Starscream框架，我们实现了高效的WebSocket通信。以上设计和实现方法，为APP的高效开发和未来扩展打下了坚实基础。

## 第四章 总结和展望
### 4 总结
本论文详细阐述了语聊APP的开发过程和关键技术选型。通过对iOS平台上常用的开发框架和工具进行深入研究和合理应用，我们成功实现了功能丰富、性能稳定的语聊APP。在开发过程中，采用面向对象编程思想，将功能模块进行分离，通过封装和继承实现代码的重用和扩展，极大地提高了代码的可维护性和可读性。

在网络请求方面，采用Alamofire框架并进行二次封装，简化了HTTP请求的实现，提高了网络通信的可靠性和效率。对于图片加载，我们选择了Kingfisher框架，通过封装统一的图像视图组件，优化了图片加载和缓存的性能。在实时通讯方面，采用Starscream框架实现了WebSocket连接，确保了语音聊天和即时通讯的实时性和稳定性。

此外，本论文还展示了如何通过面向对象编程和现代化框架的结合，实现复杂业务逻辑的高效管理。整个开发过程遵循模块化和组件化设计原则，不仅实现了高质量的代码结构，还为未来的扩展和维护提供了良好的基础。


