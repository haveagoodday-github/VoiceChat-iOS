    //
//  Starscream.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/9.
//

import Foundation
import Starscream
import ProgressHUD
import SwiftyJSON
import Defaults

let BASE_SOCKET = "ws://192.168.31.214:8889/webSocket"

// MARK: - Socket Error Enum
enum SocketError: Error {
    case byteStream
    case eventTypeNotDetermined
    case eventDataNotPresent
    case spawnEventDataNotPresent
    case capturedSpawnEventDataNotPresent
    case newSpawnEventDataNotPresent
}

// MARK: - Socket Event Enum
enum SocketEvent: String {
    case spawnList = "spawn_list"
    case shoot = "shoot"
    case spawnCaptured = "spawn_captured"
    case newSpawn = "spawn_new"
    case sessionStart = "session_start"
    case shitCoin = "shitcoin"
    case balanceUpdate = "balance_update"
    case balanceUpdated = "balance_updated"
}


// MARK: - Socket
final class Socket: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .text(let text):
            
            chatMessage(text)
            roomMessage(text)
            
            print("接收到文本: \(text)")
            processEvent(from: text)
        case .binary(let data):
            print("接收到数据: \(data)")
        default:
            break
        }
    }
    
    // 房间消息
    func roomMessage(_ text: String) {
        debugPrint("roomMessage: \(text)")
        if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let senderUserId = json?["senderUserId"].int ?? 0
            
            if let roomMessage = json?.rawString() {
                Defaults[.roomMessage] = roomMessage
                NotificationCenter.default.post(name: .receiveNewRoomMessage, object: nil)
            }

        }
        
        
    }
    
    
    func chatMessage(_ text: String) {
        // 聊天对话消息
        if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            
            let userId = json?["userId"].int
            let beUserId = json?["beUserId"].int
            let msg = json?["msg"].string
            
            if beUserId != 0 && Defaults[.isNotificationForReceiveNewMessage], let uid = userId {
                UserRequest.getUserInfo(userId: uid) { userinfo in
                    ProgressHUD.banner(userinfo.nickname, msg, delay: 1.5)
                }
            }
            NotificationCenter.default.post(name: .receiveNewMessage, object: nil)
        }
    }
    
    
    
    // MARK: - Shared Instance
    static let shared = Socket()
    
    
    // MARK: - Private Instance Attributes
    private var webSocket: WebSocket
    
    
    // MARK: - Public Instance Attributes
    var didReceiveSpawnList: DynamicBinder<Data?>
    var didCaptureSpawn: DynamicBinder<Data?>
    var newSpawnReceived: DynamicBinder<Data?>
    var shitCoinAppeared: DynamicBinder<Void>
    var balanceUpdated: DynamicBinder<Void>
    var socketError: DynamicBinder<Error?>
    
    
    // MARK: - Initializers
    private init() {
        let url = URL(string: BASE_SOCKET)!
        var urlRequest = URLRequest(url: url)
        webSocket = WebSocket(request: urlRequest)
        didReceiveSpawnList = DynamicBinder(nil)
        didCaptureSpawn = DynamicBinder(nil)
        socketError = DynamicBinder(nil)
        newSpawnReceived = DynamicBinder(nil)
        shitCoinAppeared = DynamicBinder(())
        balanceUpdated = DynamicBinder(())
        setupBindings()
        webSocket.delegate = self
    }
}


// MARK: - Public Instance Methods For Connecting/Disconnecting
extension Socket {
    func connect() {
        webSocket.connect()
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
}


// MARK: - Public Instance Methods For Sending Data
extension Socket {
    func write(with string: String) {
        webSocket.write(string: string)
    }
}


// MARK: - Private Instance Methods For Socket Bindings
private extension Socket {
    func setupBindings() {
        webSocket.connect()
        webSocket.disconnect()
    }
}


// MARK: - Private Instance Methods For Socket Event Processing
private extension Socket {
    func processEvent(from text: String) {
        debugPrint(text)
        guard let textData = text.data(using: .utf8) else {
            print("Error converting text to byte stream")
            socketError.value = SocketError.byteStream
            return
        }
        do {
            guard let dataDic = try JSONSerialization.jsonObject(with: textData, options: []) as? [String: Any] else {
                print("Error converting byte stream to JSON")
                socketError.value = SocketError.byteStream
                return
            }
            guard let type = dataDic["type"] as? String,
                  let socketEvent = SocketEvent(rawValue: type) else {
                    print("Error figuring out socket event")
                    socketError.value = SocketError.eventTypeNotDetermined
                    return
            }
            switch socketEvent {
            case .spawnList:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                guard let spawnList = socketData["spawns"] as? [AnyObject] else {
                    print("Spawn event data not present")
                    socketError.value = SocketError.spawnEventDataNotPresent
                    return
                }
                let spawnData = try JSONSerialization.data(withJSONObject: spawnList, options: [])
                didReceiveSpawnList.value = spawnData
            case .spawnCaptured:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                let capturedSpawn = socketData["spawn"] as AnyObject
                let capturedSpawnData = try JSONSerialization.data(withJSONObject: capturedSpawn, options: [])
                didCaptureSpawn.value = capturedSpawnData
            case .newSpawn:
                guard let socketData = dataDic["data"] as? [String: Any] else {
                    print("Error retrieving socket data")
                    socketError.value = SocketError.eventDataNotPresent
                    return
                }
                let newSpawn = socketData["spawn"] as AnyObject
                let newSpawnData = try JSONSerialization.data(withJSONObject: newSpawn, options: [])
                newSpawnReceived.value = newSpawnData
            case .shitCoin:
                shitCoinAppeared.value = ()
            case .balanceUpdated:
                balanceUpdated.value = ()
            default:
                print("Event not being handled!")
            }
        } catch {
            print("Error occured with serialization: \(error)")
            socketError.value = error
        }
    }
}



// MARK: - Listener Typealias
typealias Listener<T> = (T) -> Void


// MARK: - Observer
struct Observer<T> {
    
    // MARK: - Public Instance Attributes
    weak var observer: AnyObject?
    var listener: Listener<T>?
    
    
    // MARK: - Initializers
    init(observer: AnyObject, listener: Listener<T>?) {
        self.observer = observer
        self.listener = listener
    }
}


// MARK: - DynamicBinder
final class DynamicBinder<T> {
    private var observers: [Observer<T>]
    var value: T {
        didSet {
            observers.forEach { $0.listener?(value) }
        }
    }
    
    func bind(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
    }
    
    func bindAndFire(_ listener: Listener<T>?, for observer: AnyObject) {
        let observe = Observer(observer: observer, listener: listener)
        observers.append(observe)
        listener?(value)
    }
    
    init(_ v: T) {
        value = v
        observers = []
    }
}



