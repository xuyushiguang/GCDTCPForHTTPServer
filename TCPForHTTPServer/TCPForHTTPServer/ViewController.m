//
//  ViewController.m
//  TCPForHTTPServer
//
//  Created by yxy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSURLSession *_session;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(100, 100, 150, 50);
    [bt setTitle:@"send request" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(actionForButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    
}

-(void)actionForButton
{
    /**
     在此处发送一个HTTP的GET请求，端口号是50001，这样在APPDelegate中的tcp服务就能监听到这个HTTP的请求,host用localhost；
     发送内容是This-is-HTTP-Request；收到的是一个json;
     **/
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    defaultConfiguration.timeoutIntervalForRequest = 3.0;
    _session =  [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURLSessionDataTask *task =  [_session dataTaskWithURL:[NSURL URLWithString:@"http://localhost:50001/This-is-HTTP-Request"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"收到HTTP响应 Response=\n %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
