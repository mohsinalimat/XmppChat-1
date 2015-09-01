//
//  AppDelegate.swift
//  XmppChat
//
//  Created by 邓锋 on 15/8/27.
//  Copyright © 2015年 邓锋. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /*
    //通道
    var xs :XMPPStream?
    //服务器是否开启
    var isOpen = false
    //密码
    var pwd = ""
    //状态代理
    var stateDelegate : IaskuStateDelegate?
    //消息代理
    var messageDelegate :IaskuMessageDelegate?
    
    func buildXmppStream(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    
    //发送上线状态
    func goOnline(){
        let p = XMPPPresence()
        xs!.sendElement(p)
    }
    
    //发送下线状态
    func goOffline(){
        let p = XMPPPresence(type: "unavailabel")
        xs?.sendElement(p)
    }
    
    //连接服务器（查看服务器是否可连接）
    func connect()-> Bool{
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
        goOffline()
        
        xs?.disconnect()
    }
    
    
    //  xmppstream delegate
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        
        do{
            try xs?.authenticateWithPassword(pwd)
        }
        catch{
            
        }
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        //上线
        goOnline()
    }
    
    //收到状态
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        
        //自己的用户名
        let myUser = sender.myJID.user
        
        //好友的用户名
        let user = presence.from().user
        
        //用户所在的域名
        let domain = presence.from().domain
        
        //状态类型
        let pType = presence.type()
        
        //如果不是自己的状态
        if user != myUser {
            
            //状态保存的结构
            var zt = IaskuState()
            zt.name = user + "@" + domain
            
            if pType == "available"{
                zt.isOnline = true
                stateDelegate?.isOn(zt)
            }else if pType == "unavailable"{
                stateDelegate?.isOn(zt)
            }
        }
    }
    
    //收到信息
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        print(message)
        print("-----------------------------")
        
        //如果是聊天消息
        if message.isChatMessage(){
            var msg :IaskuMessage = IaskuMessage()
            
            //对方正在输入
            if message.elementForName("composing") != nil {
                msg.isComposing = true
            }
            
            //离线消息
            if message.elementForName("delay") != nil{
                msg.isDelay = true
            }
            
            //消息正文
            if let body = message.elementForName("body"){
                msg.body = body.stringValue()
            }
            
            //完整的用户名
            msg.from = message.from().user + "@" + message.from().domain
            
            //调用消息代理
            messageDelegate?.receiveMessage(msg)
        }
    }
    
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print(NSHomeDirectory())
        xmppManager.connect()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

