//
//  HttpRequet.m
//  ShareExtension
//
//  Created by Kenvin on 16/12/27.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "HttpRequet.h"
/*
    援引自AFNetworking 文件类型判断
 */
static inline NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}

@implementation HttpRequet

+ (void)normalSessionRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSData *data, NSError *error))completeHander{
   
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
 
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",[NSThread currentThread]);
        if (data && (error == nil)) {
           
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
           
            NSLog(@"error=%@",error);
        }
         completeHander(response,data,error);
    }];
    [dataTask resume];
}

+ (void)downloadFileRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander{
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [sharedSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
         completeHander(response,location,error);
    }];
    
    [downloadTask resume];
}

+ (void)uploadFileRequest:(NSString *)urlString  filePath:(NSString *)filePath fileName:(NSString *)fileName params:(NSDictionary *)params completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander{

    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 文件上传使用post
    request.HTTPMethod = @"POST";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"boundary"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // FilePath:要上传的本地文件路径  formName:表单控件名称，应于服务器一致
    NSData* data = [self getHttpBodyWithFilePath:filePath formName:@"file" reName:fileName params:params];

    request.HTTPBody = data;

    [request setValue:[NSString stringWithFormat:@"%lu",data.length] forHTTPHeaderField:@"Content-Length"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
        
    }] resume];
#if 0
    // 4.2 开始上传 使用uploadTask   fromData:可有可无，会被忽略
    [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:nil     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
#endif
}

+ (NSData *)getHttpBodyWithFilePath:(NSString *)filePath formName:(NSString *)formName reName:(NSString *)reName params:(NSDictionary *)params{
    
    NSMutableData *data = [NSMutableData data];
    NSString *fileType = AFContentTypeForPathExtension([filePath pathExtension]);
    // 表单拼接
    NSMutableString *headerStrM =[NSMutableString string];
    [headerStrM appendFormat:@"--%@\r\n",@"boundary"];
    
     NSString *boundary = @"boundary";//分隔符
    
     //multipart/form-data格式按照构建上传数据
    for (NSString *key in params) {
         NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary,key];
         [data appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
         
         id value = [params objectForKey:key];
         if ([value isKindOfClass:[NSString class]]) {
             [data appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
         }else if ([value isKindOfClass:[NSData class]]){
             [data appendData:value];
         }
         [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     }
     
    // name：表单控件名称  filename：上传文件名
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",formName,reName];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",@"boundary"];
    [data appendData:[footerStrM  dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"dataStr=%@",headerStrM);
    return data;
}

+ (NSString*)getFilePath{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userfile"];
    //初始化临时文件路径
    NSString *folderPath = path;
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    
    if (!fileExists)
    {//如果不存在创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}
@end
