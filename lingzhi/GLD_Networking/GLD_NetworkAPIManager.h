//
//  GLD_NetworkAPIManager.h
//  GLD_Networking
//
//  Created by yiyangkeji on 2017/6/27.
//  Copyright © 2017年 yiyangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLD_NetworkConfig.h"
#import "GLD_RefreshHeader.h"
#import "YXFooterRefresh.h"


//#define WEB_SERVICE_REQUESTBASEURL @"http://www.hhlmcn.com:8080" //服务器网络链接;
#define WEB_SERVICE_REQUESTBASEURL @"http://192.168.0.225:8089" //测试网络链接;

//2027463920@qq.com/lp13393185821
//appleId 843394241zZ
typedef void(^completionHandleBlock)(NSError *error, id result);

@interface GLD_APIConfiguration : NSObject

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
@property (copy, nonatomic) NSString *urlPath;
@property (strong, nonatomic) NSDictionary *requestParameters;

@property (assign, nonatomic) BOOL useHttps;
@property (strong, nonatomic) NSDictionary *requestHeader;
@property (assign, nonatomic) gld_networkRequestType requestType;

@property (assign, nonatomic) NSTimeInterval cacheValidTimeInterval;
@end

@interface GLD_NetworkAPIManager : NSObject

+ (void)cancelTaskWith:(NSNumber *)taskIdentifier;

- (NSNumber *)dispatchDataTaskWith:(GLD_APIConfiguration *)config andCompletionHandler:(completionHandleBlock)completionHandle;
@end
