//
//  HelloworldTutorialContext.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/2.
//

import Foundation
import linphonesw
import ProgressHUD
import SwiftyJSON



class IncomingCallTutorialContext : ObservableObject {
    var mCore: Core!
    var mRegistrationDelegate : CoreDelegate!
    var mCoreDelegate : CoreDelegate!
    @Published var coreVersion: String = Core.getVersion
    
    var mAccount: Account?
    
    @Published var username : String = "1002"
    @Published var passwd : String = "123456"
    @Published var domain : String = "192.168.31.229"
    @Published var loggedIn: Bool = false
    
    // Incoming call related variables
    @Published var callMsg : String = ""
    @Published var isCallIncoming : Bool = false
    @Published var isCallRunning : Bool = false
    @Published var remoteAddress : String = "sip:1001@192.168.31.229"
    @Published var isSpeakerEnabled : Bool = false
    @Published var isMicrophoneEnabled : Bool = false
    
    /*------------ Basic chat tutorial related variables -------*/
    var mChatroom : ChatRoom?
    var mChatMessageDelegate : ChatMessageDelegate!
    var mChatMessage : ChatMessage?
    var mLastFileMessageReceived : ChatMessage?
    @Published var msgToSend : String = "msg"
    @Published var messagesReceived : String = ""
    @Published var publicScreenContent: [RoomMessageTypeModel] = []
    @Published var canEditAddress : Bool = true
    
    
    
    // 添加会议相关的属性
//    var conferenceScheduler: ConferenceScheduler? = nil
//    var currentConference: Conference?
//    var currentConferenceParams: ConferenceParams?
//    @Published var conferenceAddress: String = ""
    
    
    init() {
//        LoggingService.Instance.logLevel = LogLevel.Debug
        
        try? mCore = Factory.Instance.createCore(configPath: "", factoryConfigPath: "", systemContext: nil)
        try? mCore.start()
    
        
        mCoreDelegate = CoreDelegateStub( onCallStateChanged: { (core: Core, call: Call, state: Call.State, message: String) in
            self.callMsg = message
            
            if (state == .IncomingReceived) { // When a call is received
                // 有人打过来了
                self.isCallIncoming = true
                self.isCallRunning = false
                self.remoteAddress = call.remoteAddress!.asStringUriOnly()
            } else if (state == .Connected) { // When a call is over
                
                self.isCallIncoming = false
                self.isCallRunning = true
            } else if (state == .Released) { // When a call is over
                // 被挂断了
                self.isCallIncoming = false
                self.isCallRunning = false
                self.remoteAddress = "sip:1001@192.168.31.229"
            }
             //
            if (state == .Connected) {
                // When the 200 OK has been received
                //当收到200 k时
            } else if (state == .StreamsRunning) {
                // 当前状态：通话中
                self.isCallRunning = true
            } else if (state == .Released) {
                // 没有通话中
                self.isCallRunning = false
            } else if (state == .Error) {
                
            }
        }, onAudioDeviceChanged: { (core: Core, device: AudioDevice) in
            // 当成功更改音频设备时将触发此回调
        }, onAudioDevicesListUpdated: { (core: Core) in
            //当可用设备列表发生变化时，将触发此回调;
            //例如，蓝牙耳机已经连接/断开。
        }, onAccountRegistrationStateChanged: { (core: Core, account: Account, state: RegistrationState, message: String) in
            NSLog("New registration state is \(state) for user id \( String(describing: account.params?.identityAddress?.asString()))\n")
            if (state == .Ok) {
                self.loggedIn = true
            } else if (state == .Cleared) {
                self.loggedIn = false
            }
        })
        mRegistrationDelegate = CoreDelegateStub(onMessageReceived : { (core: Core, chatRoom: ChatRoom, message: ChatMessage) in
            //当接收到消息时，我们将在此调用
            //如果聊天室不存在，则由库自动创建
            //如果我们已经发送了一个聊天消息，聊天室变量将与我们已经拥有的相同
            if (self.mChatroom == nil) {
                if (chatRoom.hasCapability(mask: ChatRoomCapabilities.Basic.rawValue)) {
                    // Keep the chatRoom object to use it to send messages if it hasn't been created yet
                    self.mChatroom = chatRoom
                    if let remoteAddress = chatRoom.peerAddress?.asStringUriOnly() {
                        self.remoteAddress = remoteAddress
                    }
                    self.canEditAddress = false
                }
            }
            // 我们将通知发送者我们已经阅读了信息
            chatRoom.markAsRead()
            
            for content in message.contents {
                if (content.isText) {
                    self.messagesReceived += "\nThem: \(message.utf8Text)"
                }
            }
            
        }, onAccountRegistrationStateChanged: { (core: Core, account: Account, state: RegistrationState, message: String) in
            NSLog("New registration state is \(state) for user id \( String(describing: account.params?.identityAddress?.asString()))\n")
            if (state == .Ok) {
                self.loggedIn = true
            } else if (state == .Cleared) {
                self.loggedIn = false
            }
        })
        
        mCore.addDelegate(delegate: mCoreDelegate)
        mCore.addDelegate(delegate: mRegistrationDelegate)
        
        mChatMessageDelegate = ChatMessageDelegateStub(onMsgStateChanged : { (message: ChatMessage, state: ChatMessage.State) in
            print("MessageTrace - msg state changed: \(state)\n")
           if (state == .Delivered) {
                self.messagesReceived += "\nMe: \(message.utf8Text)"
               
            }
        })
        
        
        login()
        
        

    }
    

    func createBasicChatRoom() {
        do {
            //在本教程中，我们将创建一个基本的聊天室
            //它不包括高级功能，如端到端加密或组
            //但是它可以与任意的SIP服务互操作，因为它依赖于SIP、SIMPLE消息
            //如果你尝试启用一个基本后端不支持的特性，isValid()将返回false
            let params = try mCore.createDefaultChatRoomParams()
            params.backend = ChatRoomBackend.Basic
            params.encryptionEnabled = false
            params.groupEnabled = false
            
            if (params.isValid) {
                //我们还需要聊天对象的ip地址
                let remote = try Factory.Instance.createAddress(addr: remoteAddress)
                //最后，我们需要本地ip地址
                let localAddress = mCore.defaultAccount?.params?.identityAddress
                mChatroom = try mCore.createChatRoom(params: params, localAddr: localAddress, participants: [remote])
                if (mChatroom != nil) {
                    canEditAddress = false
                }
            }
        } catch { NSLog(error.localizedDescription) }
    }
    
    func sendMessage() {
        do {
            if (mChatroom == nil) {
                //我们需要一个聊天室对象来发送聊天消息，所以如果还没有创建它，我们就创建它
                createBasicChatRoom()
            }
            mChatMessage = nil
            
            
//            if let userinfo = UserCache.shared.getUserInfo() {
//                let item = RoomMessageTypeModel(type: 0, roomId: self.roomId, senderUserId: userinfo.userId, beUserId: 0, sex: userinfo.sex, goldImg: "", nickname: userinfo.nickname, avatar: userinfo.avatar, avatarBox: userinfo.avatarBox ?? "", starsImg: userinfo.starsImg ?? "", ControlName: "发送普通消息", content: msgToSend, emoji: "")
////                self.publicScreenContent.append(item)
//            }
            
            //我们需要使用聊天室创建一个聊天消息对象
            mChatMessage = try mChatroom!.createMessageFromUtf8(message: msgToSend)
            
            //然后我们可以发送它，进度将使用onMsgStateChanged状态改变回调通知
            mChatMessage!.addDelegate(delegate: mChatMessageDelegate)
            
            // 发送信息
            mChatMessage!.send()
            
            // 清除消息输入字段
            msgToSend.removeAll()
        } catch { NSLog(error.localizedDescription) }
    }

}


extension IncomingCallTutorialContext {
    
    func login() {
        
        do {
            let transport : TransportType = TransportType.Udp
            
            let authInfo = try Factory.Instance.createAuthInfo(username: String(UserCache.shared.getUserInfo()?.userId ?? 0), userid: "", passwd: passwd, ha1: "", realm: "", domain: domain)
            let accountParams = try mCore.createAccountParams()
            let identity = try Factory.Instance.createAddress(addr: String("sip:" + String(UserCache.shared.getUserInfo()?.userId ?? 0) + "@" + domain))
            try! accountParams.setIdentityaddress(newValue: identity)
            let address = try Factory.Instance.createAddress(addr: String("sip:" + domain))
            try address.setTransport(newValue: transport)
            try accountParams.setServeraddress(newValue: address)
            accountParams.registerEnabled = true
            mAccount = try mCore.createAccount(params: accountParams)
            mCore.addAuthInfo(info: authInfo)
            try mCore.addAccount(account: mAccount!)
            mCore.defaultAccount = mAccount
            
        } catch { NSLog(error.localizedDescription) }
    }
    
    func unregister() {
        if let account = mCore.defaultAccount {
            let params = account.params
            let clonedParams = params?.clone()
            clonedParams?.registerEnabled = false
            account.params = clonedParams
        }
    }
    func delete() {
        if let account = mCore.defaultAccount {
            mCore.removeAccount(account: account)
            mCore.clearAccounts()
            mCore.clearAllAuthInfo()
        }
    }
    
    
    // 挂断
    func terminateCall() {
        do {
            // 终止呼叫，无论它是振铃还是运行
            try mCore.currentCall?.terminate()
        } catch { NSLog(error.localizedDescription) }
    }
    
    // 接受来电
    func acceptCall() {
        do {
            //如果需要，可以创建一个调用params对象
            //并使用此对象进行应答以更改调用配置
            //(参见外呼教程)
            try mCore.currentCall?.accept()
        } catch { NSLog(error.localizedDescription) }
    }
    
    // 打电话
    func outgoingCall(userId: Int) {
        do {
            //所有我们需要的是获取远程的SIP并将其转换为地址
            let remoteAddress = try Factory.Instance.createAddress(addr: "sip:\(String(userId))@192.168.31.229")
            //我们还需要调用params对象
            //创建call params期望一个call对象，但是对于呼出，我们必须安全地使用null
            let params = try mCore.createCallParams(call: nil)
            
            //我们现在可以配置它了
            //这里我们不要求加密，但是我们可以要求ZRTP/SRTP/DTLS
            params.mediaEncryption = MediaEncryption.None
            //如果我们想直接用视频开始通话
            // params.videoEnabled = true
            
            // 最后我们开始通话
            let _ = mCore.inviteAddressWithParams(addr: remoteAddress, params: params)
            // 调用过程可以在调用状态改变后从核心监听器回调
        } catch { NSLog(error.localizedDescription) }
        
    }
    
    
    // 麦克风
    func muteMicrophone() {
        //下面的命令切换麦克风，完全禁用/启用声音捕获
        //从设备的麦克风
        mCore.micEnabled = !mCore.micEnabled
        isMicrophoneEnabled = !isMicrophoneEnabled
    }
    
    
    func offMic() {
        mCore.micEnabled = false
        isMicrophoneEnabled = false
    }
    
    func onMic() {
        mCore.micEnabled = true
        isMicrophoneEnabled = true
    }
    // 免提
    func toggleSpeaker() {
        // 获取当前使用的音频设备
        let currentAudioDevice = mCore.currentCall?.outputAudioDevice
        let speakerEnabled = currentAudioDevice?.type == AudioDeviceType.Speaker
        
        let test = currentAudioDevice?.deviceName
        //我们可以获取所有可用音频设备的列表
        //请注意，例如在平板电脑上，可能没有耳机
        for audioDevice in mCore.audioDevices {
            //对于iOS，扬声器是个例外，linphone不能区分输入和输出。
            //这意味着默认的输出设备，耳机，与默认的电话麦克风配对。
            //将输出音频设备设置为麦克风将声音重定向到耳机。
            if (speakerEnabled && audioDevice.type == AudioDeviceType.Microphone) {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = false
                return
            } else if (!speakerEnabled && audioDevice.type == AudioDeviceType.Speaker) {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = true
                return
            }
        }
    }
}



// MARK: 会议
//extension IncomingCallTutorialContext {
//    func handleConferenceState(conference: Conference) {
//        switch conference.state {
//        case .None:
//            print("会议处于初始状态。")
//        case .Instantiated:
//            print("会议已在本地实例化。")
//        case .CreationPending:
//            print("会议正在向服务器发送创建请求...")
//        case .Created:
//            print("会议已在服务器上创建。")
//        case .CreationFailed:
//            print("会议创建失败。")
//        case .TerminationPending:
//            print("正在等待会议终止...")
//        case .Terminated:
//            print("会议在服务器上存在但在本地不存在。")
//        case .TerminationFailed:
//            print("会议终止失败。")
//        case .Deleted:
//            print("会议已在服务器上删除。")
//        }
//    }
//    
//    func initialize() {
//        // 会议
//        let coreDelegate = CoreDelegateStub(
//            onConferenceStateChanged: { (core, conference, state) in
//                self.handleConferenceState(conference: conference)
//            }
//        )
//        mCore.addDelegate(delegate: coreDelegate)
//    }
//    
//    func createConference() {
//        do {
//            let conferenceParams = try mCore.createConferenceParams(conference: nil)
//            
//            // 设置会议参数
//            conferenceParams.chatEnabled = true // 启动聊天
//            conferenceParams.audioEnabled = true // 启用音频
//            conferenceParams.videoEnabled = false // 不启用视频
//            conferenceParams.subject = "团队会议" // 设置会议主题
//            conferenceParams.description = "这是一个用于团队讨论的会议。" // 设置会议描述
//            conferenceParams.startTime = time_t(Date().timeIntervalSince1970) // 设置开始时间为当前时间
//            conferenceParams.endTime = time_t(Date().addingTimeInterval(3600).timeIntervalSince1970) // 设置结束时间为一小时后
//            conferenceParams.localParticipantEnabled = true // 启用本地参与者
//            conferenceParams.oneParticipantConferenceEnabled = false // 允许只有一个参与者的会议，这样即使只有一个人也可以创建会议，其他人可以随后加入。
//            
//            self.currentConferenceParams = conferenceParams
//            
//            // 创建Conference对象
//            do {
//                let conference = try mCore.createConferenceWithParams(params: conferenceParams)
//                
////                try conference.addParticipant(call: mCore.calls.first!)
//                print("会议创建成功")
//                
//                if let conferenceAddress = conference.conferenceAddress {
//                    print("会议地址: \(conferenceAddress.asString())")
//                    print("会议地址domain: \(conferenceAddress.domain)")
//                    print("会议地址displayName: \(conferenceAddress.displayName)")
//                    print("会议地址methodParam: \(conferenceAddress.methodParam)")
//                    print("会议地址isSip: \(conferenceAddress.isSip)")
//                    print("会议地址isValid: \(conferenceAddress.isValid)")
//                    print("会议地址scheme: \(conferenceAddress.scheme)")
//                    print("会议地址username: \(conferenceAddress.username)")
//                    
//                    self.conferenceAddress = conferenceAddress.asString()
//                    
//                    
//                    enterConference(addressString: self.conferenceAddress)
//                }
//                
//            } catch {
//                print("创建会议失败: \(error)")
//            }
//            
//        } catch {
//            
//        }
//    }
//    
//    func enterConference(addressString: String? = nil) {
//        var conferences: Conference? = nil
//        
//        if let add = addressString {
//            do {
//                let aString = try Factory.Instance.createAddress(addr: add)
//                conferences = mCore.searchConference(conferenceAddr: aString)
//                
//                if let c = conferences {
//                    
//                    let isSuccess = c.enter()
//                    print("加入会议成功---------: \(isSuccess)")
//                    currentConference = c
//                    displayConferenceInfo(conference: c) // 查看会议信息
//                    ProgressHUD.succeed("加入会议成功", delay: 1)
//                } else {
//                    print("未找到会议")
//                    ProgressHUD.error("未找到会议", delay: 5)
//                }
//            } catch {
//                debugPrint("会议catch \(addressString)")
//                return
//            }
//        } else {
//            debugPrint("会议else")
//            return
//        }
//
//    }
//    
//    
//    func exitConference() {
//        self.currentConference?.leave()
//    }
//    
//    func displayConferenceState() {
//        if let c = self.currentConference {
//            handleConferenceState(conference: c)
//        } else {
//            print("会议状态查看失败")
//        }
//    }
//    
//    // 发言（启用麦克风）
//    func enableMicrophone() {
//        if let conference = currentConference {
//            mCore.micEnabled = true
//            isMicrophoneEnabled = true
//            print("会议麦克风已启用")
//        } else {
//            print("当前没有加入任何会议")
//        }
//    }
//    
//    // 闭麦（禁用麦克风）
//    func disableMicrophone() {
//        if let conference = currentConference {
//            mCore.micEnabled = false
//            isMicrophoneEnabled = false
//            print("麦克风已禁用")
//        } else {
//            print("当前没有加入任何会议")
//        }
//    }
//    
//    func displayConferenceInfo(conference: Conference) {
//        // 获取会议信息
//        if let conferenceId = conference.conferenceAddress?.asString() {
//            print("会议地址: \(conferenceId)")
//        }
//        
//        print("会议主题: \(conference.subject)")
//    
//        let state = conference.state
//        print("会议状态: \(state)")
//        let participantCount = conference.participantCount
//        print("会议参与者数量: \(participantCount)")
//        
//        let participants = conference.participants.map { $0.asString() }
//        print("会议参与者列表: \(participants.joined(separator: ", "))")
//    }
//}
