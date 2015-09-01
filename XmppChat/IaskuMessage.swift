////
////  IaskuMessage.swift
////  XmppChat
////
////  Created by 邓锋 on 15/8/27.
////  Copyright © 2015年 邓锋. All rights reserved.
////
//
//import Foundation
//
////好友消息结构
//struct IaskuMessage{
//    var body :String = ""
//    var from :String = ""
//    var isComposing :Bool = false
//    var isDelay :Bool = false
//    var isMe :Bool = false
//}
//
////状态结构
//struct IaskuState{
//    var name :String = ""
//    var isOnline :Bool = false
//}
//
////状态协议
//protocol IaskuStateDelegate{
//    func isOn(state:IaskuState)
//    func isOff(state:IaskuState)
//    func meOff()
//}
//
////消息协议
//protocol IaskuMessageDelegate{
//    func receiveMessage(msg:IaskuMessage)
//}