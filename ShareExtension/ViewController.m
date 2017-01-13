//
//  ViewController.m
//  ShareExtension
//
//  Created by Kenvin on 16/12/7.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Hex.h"
#import "HttpRequet.h"

static NSString *const normalUrl = @"http://www.jianshu.com/p/27cc136b24ed";

static NSString *const downLoadUrl = @"http://192.168.0.50/iOS-AutoLayout开发秘籍-第2版.pdf";

static NSString *const uploadImageUrl = @"http://192.168.0.50/loadFile.php";

/*
 外网不能访问。你可以把127.0.0.1替换成你本机的ip，这样跟你的电脑在同一个局域网下的设备就可以访问，例如你的手机。
 */

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

/**
 *  1: 启动Apache 服务  
     //开启apache:  sudo apachectl start
 
     //重启apache:  sudo apachectl restart
 
     //关闭apache:  sudo apachectl stop
 
    2: 点击Finder,然后Command+Shift+G,前往如下路径(mac下Apache服务器的文件路径)/Library/WebServer/Documents
 
    3: 编写php上传文件代码 设置要存储文件的读写权限
 */

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    //网址加载
    //[HttpRequet normalSessionRequest:normalUrl completeHander:^(NSURLResponse *response,
    //                                                            NSData *data,
    //                                                           NSError *error) {
    //    NSLog(@"%@", response.MIMEType);
     //      [self.webView loadData:data MIMEType:response.MIMEType textEncodingName:@"UTF8" baseURL:nil];
   // }];
    
    //文件下载
    [HttpRequet downloadFileRequest:downLoadUrl completeHander:^(NSURLResponse *response, NSURL *location, NSError *error) {
        if (error == nil) {
            // location:下载任务完成之后,文件存储的位置，这个路径默认是在tmp文件夹下!
            // 只会临时保存，因此需要将其另存
            NSLog(@"location:%@",location.path);
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *path = [[HttpRequet getFilePath] stringByAppendingPathComponent:@"iOS-AutoLayout开发秘籍-第2版.pdf"];
            
            // 移动文件
            NSError *fileError;
            
            BOOL isMove = [fileManager moveItemAtPath:location.path toPath:path error:&fileError];
            if (isMove) {
                NSLog(@"移动成功");
            } else {
                NSLog(@"移动失败");
            }
            
            if (fileError == nil) {
                NSLog(@"file save success");
            } else {
                NSLog(@"file save error: %@",fileError);
            }
        } else {
            NSLog(@"download error:%@",error);
        }
    }];
    
    
    //文件上传
    NSString *path = [[HttpRequet getFilePath] stringByAppendingPathComponent:@"iOS-AutoLayout开发秘籍-第2版.pdf"];
    NSString *fileName = path.lastPathComponent;
    [HttpRequet uploadFileRequest:uploadImageUrl filePath:path fileName:fileName params:nil  completeHander:^(NSURLResponse *response, NSURL *location, NSError *error) {
        
    }];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}


- (IBAction)btnccc:(id)sender {
   
}

@end
