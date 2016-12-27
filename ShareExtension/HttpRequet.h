//
//  HttpRequet.h
//  ShareExtension
//
//  Created by Kenvin on 16/12/27.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequet : NSObject

+ (void)normalSessionRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))completeHander;

+ (void)downloadFileRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander;

+ (void)uploadFileRequest:(NSString *)urlString  filePath:(NSString *)filePath fileName:(NSString *)fileName completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander;

+ (NSString*)getFilePath;
@end
