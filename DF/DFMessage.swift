//
//  Message.swift
//  XmppChat
//
//  Created by 邓锋 on 15/8/28.
//  Copyright © 2015年 邓锋. All rights reserved.
//

import Foundation



//好友消息结构
struct Message{
    var body :String = ""
    var from :String = ""
    var isComposing :Bool = false
    var isDelay :Bool = false
    var isMe :Bool = false
}



//状态协议
protocol UserStateDelegate{
    func isOn(user:User)
    func isOff(user:User)
    func isLeave(user:User)
    func isBusy(user:User)
    func isInvisible(user:User)
}

//消息协议
protocol MessageDelegate{
    func receiveMessage(msg:Message)
}
