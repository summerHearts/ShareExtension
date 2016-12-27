//
//  ViewController.m
//  ShareExtension
//
//  Created by Kenvin on 16/12/7.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>
#import "UIColor+Hex.h"
#import "HttpRequet.h"

static NSString *const normalUrl = @"http://www.jianshu.com/p/27cc136b24ed";

static NSString *const specialUrl = @"http://192.168.0.50/iOS高级工程师－姚亚杰.pdf";/*
                                                                     外网不能访问。你可以把127.0.0.1替换成你本机的ip，这样跟你的电脑在同一个局域网下的设备就可以访问，例如你的手机。
                                                                     */
static NSString *const uploadImageUrl = @"http://192.168.0.50/loadFile.php";

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.webView];
    
    //网址加载
    [HttpRequet normalSessionRequest:normalUrl completeHander:^(NSURLResponse *response,
                                                                NSData *data,
                                                                NSError *error) {
        NSLog(@"%@", response.MIMEType);
           [self.webView loadData:data MIMEType:response.MIMEType textEncodingName:@"UTF8" baseURL:nil];
    }];
    
    //文件下载
    [HttpRequet downloadFileRequest:specialUrl completeHander:^(NSURLResponse *response, NSURL *location, NSError *error) {
        if (error == nil) {
            // location:下载任务完成之后,文件存储的位置，这个路径默认是在tmp文件夹下!
            // 只会临时保存，因此需要将其另存
            NSLog(@"location:%@",location.path);
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSString *path = [[HttpRequet getFilePath] stringByAppendingPathComponent:@"iOS高级工程师－姚亚杰.pdf"];
            
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
    
    NSString *path = [[HttpRequet getFilePath] stringByAppendingPathComponent:@"iOS高级工程师－姚亚杰.pdf"];
    NSString *fileName = path.lastPathComponent;
    [HttpRequet uploadFileRequest:uploadImageUrl filePath:path fileName:fileName completeHander:^(NSURLResponse *response, NSURL *location, NSError *error) {
        
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)btnccc:(id)sender {
   
}

@end
