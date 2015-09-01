//
//  DFUserManager.swift
//  XmppChat
//
//  Created by 邓锋 on 15/8/28.
//  Copyright © 2015年 邓锋. All rights reserved.
//

import Foundation

enum UserState : String{
    case OnLine  = "available"//在线
    case OffLine = "unavailable"//离线
    case Busy = "do not disturb"//忙碌
    case Invisible = "invisible"//隐身
    case Leave = "away"//离开
}

class DFUserManager :NSObject{
    var groupList : [Group]? //分组列表
    
    override init(){
        super.init()
        
    }
    
    //获取好友列表
    func getMyQueryRoster(){
        let query =  DDXMLElement.elementWithName("query") as! DDXMLElement
        query.setXmlns("jabber:iq:roster")
        let iq = DDXMLElement.elementWithName("iq") as! DDXMLElement
        let myJid = xmppManager.xs?.myJID
        iq.addAttributeWithName("from", stringValue: myJid?.description)
        //iq.addAttributeWithName("to", stringValue: myJid?.domain)
        iq.addAttributeWithName("id", stringValue: "abc123")
        iq.addAttributeWithName("type", stringValue: "get")
        iq.addChild(query)
        xmppManager.xs?.sendElement(iq)
    }
}

class Group{
    var userList : [User]?
}

class User{
    var nick = "" //昵称
    var headPortrait = "" //头像
    var personalDescription = "" //个性说明
    var userState = UserState.OffLine //状态
}

