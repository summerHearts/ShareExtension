//
//  ShareViewController.m
//  FileExtension
//
//  Created by Kenvin on 16/12/7.
//  Copyright © 2016年 上海方创金融信息服务股份有限公司. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController


- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    
    
    __block BOOL hasExistsUrl = NO;
    [self.extensionContext.inputItems enumerateObjectsUsingBlock:^(NSExtensionItem * _Nonnull extItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [extItem.attachments enumerateObjectsUsingBlock:^(NSItemProvider * _Nonnull itemProvider, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",itemProvider);
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"])
            {
                [itemProvider loadItemForTypeIdentifier:@"public.url"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                          {
                                              NSLog(@"分享的URL = %@", item);
                                              NSLog(@"分享的URL1 = %@", ((NSURL *)item).absoluteString);
                                              NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.legend.shareShow"];
                                              [userDefaults setValue: ((NSURL *)item).absoluteString forKey:@"share-url"];
                                              //用于标记是新的分享
                                              [userDefaults setBool:YES forKey:@"has-new-share"];
                                              [self CopyFileOrgFileName:(NSURL *)item];
                                              
                                              
                                              
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
            //            @"public.png"
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.png"])
            {
                //                @"public.jpeg"
                [itemProvider loadItemForTypeIdentifier:@"public.png"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          NSLog(@"%@",item);
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                          {
                                              
                                              [self CopyFileOrgFileName:(NSURL *)item];
                                              
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
            if ([itemProvider hasItemConformingToTypeIdentifier:@"public.jpeg"])
            {
                //                @"public.jpeg"
                [itemProvider loadItemForTypeIdentifier:@"public.jpeg"
                                                options:nil
                                      completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                                          NSLog(@"%@",item);
                                          if ([(NSObject *)item isKindOfClass:[NSURL class]])
                                          {
                                              
                                              [self CopyFileOrgFileName:(NSURL *)item];
                                              
                                          }
                                          
                                      }];
                
                hasExistsUrl = YES;
                *stop = YES;
            }
        }];
        //        NSLog(@"标题:%@",extItem.attributedTitle);
        //        NSLog(@"内容:%@",extItem.attributedContentText);
        //        NSLog(@"照片:%@",extItem.attachments);
        if (hasExistsUrl)
        {
            *stop = YES;
        }
        
    }];
    
    
    
    
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

//文件复制
- (BOOL)CopyFileOrgFileName:(NSURL *)srcPath
{
    //    NSString *srcPath=oName;
    NSString * tempFileName = [srcPath.path lastPathComponent];
    //    NSString *groupURL = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.legend.shareShow"].path;
    NSLog(@"%@",groupURL);
    NSString *fileNameNew = [groupURL stringByAppendingPathComponent:tempFileName];
    NSLog(@"%@",fileNameNew);
    NSURL *tarPath = [NSURL URLWithString:fileNameNew];
    NSLog(@"%@",tarPath);
    
    
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.legend.shareShow"];
    [userDefaults setValue: [srcPath.path lastPathComponent] forKey:@"share-name"];
    
    
    
    NSData *imageDataOrigin = [NSData dataWithContentsOfFile:srcPath.path];
    
    [imageDataOrigin writeToFile:tarPath.path atomically:YES];

    return YES;
}

@end
