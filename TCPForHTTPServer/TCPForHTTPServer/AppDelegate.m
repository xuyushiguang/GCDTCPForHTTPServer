//
//  AppDelegate.m
//  TCPForHTTPServer
//
//  Created by yxy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "AppDelegate.h"
#import <GCDAsyncSocket.h>


@interface AppDelegate ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_listenSocket;///< 监听
    GCDAsyncSocket *_temSocket;///< 收到新的连接
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /**
     建立HTTP服务，使用tcp建立一个代理服务，监听端口号50001的HTTP请求，当收到HTTP请求后可以收到http所有的数据，然后再响应
     HTTP。
     **/
    _listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    if (![_listenSocket acceptOnPort:50001 error:&error]) {
        NSLog(@"建立监听失败error=%@",error);
    }else{
        NSLog(@"建立监听success");
    }
    
    return YES;
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"监听到tcp连接newSocket%@",newSocket);
    _temSocket = newSocket;
    [newSocket readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    /**
     收到数据之后，在这里进行数据转发和响应；这里是模拟收到数据之后直接用tcp封装一个http协议格式的数据作为应答；
     **/
    NSLog(@"***监听到HTTP的请求socket=%@  data=\n %@",sock,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    /**
     应答一串json数据 {"students":[{"name":"QQ","age":"10"},{"name":"CS","age":"11"},{"name":"DNF","age":"12"}]};
     */
    NSLog(@"***开始应答HTTP,应答一串json数据");
    /**
     按照HTTP协议的格式，在这里组装一个HTTP响应数据包，
     */
    NSString *str = @"HTTP/1.1 200 \nServer: Microsoft-IIS/5.1 \nDate: Thu, 25 Oct 2018 13:6:39 GMT \nConnection: close \nContent-Type: text/json \nContent-Length: 90  \n\n {\"students\":[{\"name\":\"QQ\",\"age\":\"10\"},{\"name\":\"CS\",\"age\":\"11\"},{\"name\":\"DNF\",\"age\":\"12\"}]}";
    
    [_temSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];

    [_temSocket disconnectAfterWriting];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"tcp连接断开socket=%@ error=%@\n",sock,err);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
