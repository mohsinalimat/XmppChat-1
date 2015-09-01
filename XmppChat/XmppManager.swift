//
//  XmppManager.swift
//  XmppChat
//
//  Created by 邓锋 on 15/8/27.
//  Copyright © 2015年 邓锋. All rights reserved.
//

import UIKit

let xmppManager = XmppManager.shareInstance()

protocol XmppManagerDelegate{
    
    func isOn(user:String)
    func isOff(user:String)
    func isLeave(user:String)
    func isBusy(user:String)
    func isInvisible(user:String)
    
    func receiveTextMessage(msg:Message)
}

class XmppManager: NSObject,XMPPStreamDelegate,XMPPRosterDelegate,XMPPReconnectDelegate,XMPPRoomDelegate{
    var delegate : XmppManagerDelegate?
    
    var userManager = DFUserManager()
    
    var xmppRoster : XMPPRoster?
    
    var xmppRosterStorage = XMPPRosterCoreDataStorage()
    
    var xmppReconnect = XMPPReconnect()
    
    var xmppMessageArchivingCoreDataStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
    
    var xmppMessageArchivingModule : XMPPMessageArchiving?
    
    var xmppRoomRosterStorage = XMPPRoomCoreDataStorage()
    
    var xmppGroup = XMPPGroupCoreDataStorageObject()
    
    var xmppRoom :XMPPRoom?
    
    
    
    //通道
    var xs = XMPPStream()
    //服务器是否开启
    var isOpen = false
    //密码
    var pwd = ""
    
    //返回XmppManager的单例
    class func shareInstance()->XmppManager{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:XmppManager? = nil
        }
        dispatch_once(&Singleton.predicate,{
                Singleton.instance=XmppManager()
            }
        )
        return Singleton.instance!
    }
    
    override init() {
        super.init()
        //创建通道
        buildXmppStream()
        
        xmppReconnect.activate(xs)
        
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        
        xmppRoster?.activate(xs)
        
        xmppRoster?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        xmppMessageArchivingModule = XMPPMessageArchiving(messageArchivingStorage: xmppMessageArchivingCoreDataStorage)
        
        xmppMessageArchivingModule?.clientSideMessageArchivingOnly = true
        
        xmppMessageArchivingModule?.activate(xs)
        
        xmppMessageArchivingModule?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
        
    }
    
    func isOn(user:User){}
    func isOff(user:User){}
    func isLeave(user:User){}
    func isBusy(user:User){}
    func isInvisible(user:User){}
    func receiveMessage(msg:Message){}
    
    
    /*******************XmppStream Delegate Begin********************/
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        do{
            try xs?.authenticateWithPassword(pwd)
            
        }
        catch{
            
        }
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //验证通过 向服务器发送上线状态
        self.goOnline()
        //userManager.getMyQueryRoster()
        xmppRoster?.fetchRoster()
        self.creatGroup("haha")
        xmppRoom?.fetchConfigurationForm()
        xmppRoom?.configureRoomUsingOptions(nil)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        //print(iq)
        if "result" == iq.type(){
            
            let query = iq.childElement()
            
            
            if query.name() == "query"{
                
                let items = query.children()
                for item in items{
                    let jid = item.attributeStringValueForName("jid")
                    let subscription = item.attributeStringValueForName("subscription")
                    //print(jid)
                    //print(subscription)
                }
                
            }
            
            //print(xmppRoster)
            
            return true
            
        }
        return true
    }
    //收到好友的状态信息时回调
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        //这里有五种状态
        //自己的用户名
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
        
        //用户所在的域
        let domain = presence.from().domain
        
        //状态类型
        let pType = presence.type()
        
        //如果不是自己的状态
        if user != myUser{
            //根据状态类型进行回调
            let user = user + "@" + domain
            if pType == "available"{
                self.delegate?.isOn(user)
            }else if pType == "unavailable"{
                self.delegate?.isOff(user)
            }
            else if pType == "away"{
                self.delegate?.isLeave(user)
            }
            else if pType == "do not disturb"{
                self.delegate?.isBusy(user)
            }
        }
        
        
    }
    
    
    
    /*******************XmppStream Delegate End********************/
    
    //创建通道
    private func buildXmppStream(){
        xs!.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //连接服务器
    func connect()->Bool{
        buildXmppStream()
        
        //通道已经连接
        if xs!.isConnected(){
            return true
        }
        //通道未连接
        let user = "menghui@dengfeng.local"
        let password = "menghui"
        let server = "localhost"
        
        xs!.myJID = XMPPJID.jidWithString(user)
        
        xs?.hostName = server
        
        pwd = password
        
        do{
            try xs?.connectWithTimeout(5000)
            return true
        }
        catch{
            return false
        }

    }
    
    //断开连接
    func disConnect(){
        xs?.disconnect()
    }
    
    //发送上线状态
    private func goOnline(){
        let p = XMPPPresence()
        xs!.sendElement(p)
    }
    //发送下线 隐身状态
    func goOffline(){
        let p = XMPPPresence(type: "unavailabel")
        xs?.sendElement(p)
    }
    //发送离开状态
    func goLeave(){
        let p = XMPPPresence(type: "away")
        xs?.sendElement(p)
    }
    //发送忙碌状态
    func goBusy(){
        let p = XMPPPresence(type: "do not disturb")
        xs?.sendElement(p)
    }
    /*
    -(void)createGroup:(NSString*)groupName
    {
    XMPPRoomCoreDataStorage *rosterstorage = [[XMPPRoomCoreDataStorage alloc] init];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@conference.%@/%@",groupName,@"server",self.strUsername]] dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:[self xmppStream]];
    [xmppRoom joinRoomUsingNickname:@"nickname" history:nil];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self performSelector:@selector(ConfigureNewRoom) withObject:nil afterDelay:5];
    }*/
    
    func creatGroup(groupName:String){
        xmppRoom = XMPPRoom(roomStorage:xmppRoomRosterStorage,jid:XMPPJID.jidWithString("\(groupName)@conference.localhost/menghui"), dispatchQueue: dispatch_get_main_queue())
        xmppRoom?.activate(xs)
        xmppRoom?.joinRoomUsingNickname("nickname", history: nil)
        xmppRoom?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        
    }
    /*******************XmppRoster Delegate Begin********************/
    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        print(presence)
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print(item)
    }
    func xmppRosterDidEndPopulating(sender: XMPPRoster!) {
        print("获取到所有好友列表")
    }
    
    /*******************XmppRoster Delegate End********************/
    
    /*******************XmppReconnect Delegate Begin********************/
    func xmppReconnect(sender: XMPPReconnect!, didDetectAccidentalDisconnect connectionFlags: SCNetworkConnectionFlags) {
        print("didDetectAccidentalDisconnect:\(connectionFlags)")
    }
    func xmppReconnect(sender: XMPPReconnect!, shouldAttemptAutoReconnect connectionFlags: SCNetworkConnectionFlags) -> Bool {
        print("shouldAttemptAutoReconnect:\(connectionFlags)")
        return true
    }
    /*******************XmppXmppReconnect Delegate End********************/
    
    func xmppRoom(sender: XMPPRoom!, didConfigure iqResult: XMPPIQ!) {
        print(iqResult)
    }
    func xmppRoomDidCreate(sender: XMPPRoom!) {
        print("创建\(sender)")
    }
    
}
