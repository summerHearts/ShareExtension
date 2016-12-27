//
//  HttpRequet.h
//  ShareExtension
//
//  Created by Kenvin on 16/12/27.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequet : NSObject
/**
 *  普通的网络请求
 *
 *  @param urlString      需要请求的url
 *  @param completeHander 请求完成回调
 */
+ (void)normalSessionRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSData *data, NSError *connectionError))completeHander;
/**
 *  下载网络请求
 *
 *  @param urlString      需要下载的url
 *  @param completeHander 请求完成回调
 */
+ (void)downloadFileRequest:(NSString *)urlString completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander;

/**
 *  上传网络请求
 *
 *  @param urlString      上传的网址
 *  @param filePath       上传文件的本地路径
 *  @param fileName       上传文件的文件名
 *  @param completeHander 请求完成的回调
 */
+ (void)uploadFileRequest:(NSString *)urlString  filePath:(NSString *)filePath fileName:(NSString *)fileName params:(NSDictionary *)params completeHander:(void(^)(NSURLResponse *response, NSURL * location, NSError *error))completeHander;

+ (NSString*)getFilePath;
@end
