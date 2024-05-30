//
//  SIPView.swift
//  VoiceChatApp
//
//  Created by 吕海锋 on 2024/5/3.
//


import SwiftUI

//struct SIPView: View {
//
//    
//    @ObservedObject var tutorialContext : IncomingCallTutorialContext
//    
//    func callStateString() -> String {
//        if (tutorialContext.isCallRunning) {
//            return "Call running"
//        } else if (tutorialContext.isCallIncoming) {
//            return "Incoming call"
//        } else {
//            return "No Call"
//        }
//    }
//    
//    
//    @State var roomId: Int = 3001
//    
//    
//    var body: some View {
//        VStack {
//            Group {
//                HStack {
//                    Text("Username:")
//                        .font(.title)
//                    TextField("", text : $tutorialContext.username)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .disabled(tutorialContext.loggedIn)
//                }
//                HStack {
//                    Text("Password:")
//                        .font(.title)
//                    TextField("", text : $tutorialContext.passwd)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .disabled(tutorialContext.loggedIn)
//                }
//                HStack {
//                    Text("Domain:")
//                        .font(.title)
//                    TextField("", text : $tutorialContext.domain)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .disabled(tutorialContext.loggedIn)
//                }
//                
//                VStack {
//                    HStack {
//                        Text("登陆状态 : ")
//                            .font(.footnote)
//                        Text(tutorialContext.loggedIn ? "Logged in" : "Unregistered")
//                            .font(.footnote)
//                            .foregroundColor(tutorialContext.loggedIn ? Color.green : Color.black)
//                    }.padding(.top, 10.0)
//                }
//                VStack {
//                    HStack {
//                        Text("谁打过来了:").font(.title).underline()
//                        Text(tutorialContext.remoteAddress)
//                        Spacer()
//                    }.padding(.top, 5)
//                    HStack {
//                        Text("Call msg:").font(.title3).underline()
//                        Text(tutorialContext.callMsg)
//                        Spacer()
//                    }.padding(.top, 5)
//                    HStack {
//                        Button(action: tutorialContext.muteMicrophone) {
//                            Text((tutorialContext.isMicrophoneEnabled) ? "麦克风已关闭" : "麦克风已打开")
//                                .font(.title3)
//                                .foregroundColor(Color.white)
//                                .frame(width: 160.0, height: 42.0)
//                                .background(Color.gray)
//                        }
//                        .disabled(!tutorialContext.isCallRunning)
//                    }.padding(.top, 10)
//                }.padding(.top, 30)
//                
//                VStack(alignment: .center, spacing: 4)  {
//                    HStack {
//                        Text("你要打给谁:")
//                            .font(.title)
//                        TextField("", text : $tutorialContext.remoteAddress)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .disabled(!tutorialContext.loggedIn)
//                    }
//                    
//                    HStack(spacing: 4) {
//                        Button(action: {
//                            if (self.tutorialContext.isCallRunning) {
//                                self.tutorialContext.terminateCall()
//                            } else {
//                                self.tutorialContext.outgoingCall()
//                            }
//                        }) {
//                            Text( (tutorialContext.isCallRunning) ? "挂断" : "打电话")
//                                .font(.largeTitle)
//                                .foregroundColor(Color.white)
//                                .frame(width: 180.0, height: 42.0)
//                                .background(Color.gray)
//                        }
//                        HStack {
//                            Text(tutorialContext.isCallRunning ? "Running" : "")
//                                .italic().foregroundColor(.green)
//                            Spacer()
//                        }
//                    }
//                    
//                    HStack {
//                        Text("Call msg:").font(.title3).underline()
//                        Text(tutorialContext.callMsg)
//                        Spacer()
//                    }.padding(.top, 5)
//                    
//                    Button {
//                        self.tutorialContext.outgoingCall() // 挂断
//                        self.tutorialContext.unregister()
//                        self.tutorialContext.delete()
//                    } label: {
//                        Text("退出房间")
//                            .font(.largeTitle)
//                            .foregroundColor(Color.white)
//                            .frame(width: 220.0, height: 90)
//                            .background(Color.gray)
//                    }
//                    
//                    
//                }
//            }
//            Group {
//                ScrollView {
//                    Text(tutorialContext.messagesReceived)
//                }.border(Color.gray)
//                HStack {
//                    TextField("Sent text", text : $tutorialContext.msgToSend)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    Button(action: tutorialContext.sendMessage)
//                    {
//                        Text("Send")
//                            .font(.callout)
//                            .foregroundColor(Color.white)
//                            .frame(width: 50.0, height: 30.0)
//                            .background(Color.gray)
//                    }
//                }
//            }
//            Group {
//                Spacer()
//                Text("Core Version is \(tutorialContext.coreVersion)")
//            }
//        }
//        .padding()
//        .onChange(of: tutorialContext.isCallIncoming, perform: { newValue in
//            if newValue {
//                tutorialContext.acceptCall() // 自动接听
//                tutorialContext.toggleSpeaker() // 自动切换免提
//            }
//        })
//    }
//}
