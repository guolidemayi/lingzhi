//
//  GLD_NetworkAPIManager.m
//  GLD_Networking
//
//  Created by yiyangkeji on 2017/6/27.
//  Copyright © 2017年 yiyangkeji. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "GLD_NetworkAPIManager.h"
#import "GLD_CacheManager.h"
#import "GLD_NetworkClient.h"
#import "GLD_NetworkError.h"
#import "MBProgressHUD.h"

@implementation GLD_APIConfiguration

- (instancetype)init {
    if (self = [super init]) {
        
        self.useHttps = YES;
        self.requestType = gld_networkRequestTypePOST;
    }
    return self;
}

@end


@interface GLD_NetworkAPIManager ()

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong)NSMutableDictionary *requestCaches;
@end
@implementation GLD_NetworkAPIManager

static GLD_NetworkAPIManager *netManager;
+ (instancetype)shareNetManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [GLD_NetworkAPIManager new];
    });
    return netManager;
}
- (void)dealloc{
    [GLD_NetworkAPIManager cancelAlltask];
}
+ (void)cancelTaskWith:(NSNumber *)taskIdentifier{
    [GLD_NetworkClient cancleTaskWithTaskIdentifier:taskIdentifier];
}

+ (void)cancelAlltask{
    [GLD_NetworkClient cancelAlltask];
}
- (NSNumber *)dispatchDataTaskWith:(GLD_APIConfiguration *)config andCompletionHandler:(completionHandleBlock)completionHandle{
    //防止多次相同网络请求
    NSMutableString *requestCache  = [NSMutableString stringWithString:config.urlPath];;
    
    if (config) {
        for (NSString *key in config.requestParameters.allKeys) {
            [requestCache stringByAppendingPathComponent:key];
        }
    }
    NSNumber *task = [self.requestCaches objectForKey:requestCache];
    
    if (task && task.integerValue != -1) return @(-1);
    
    NSString *cacheKey;
    if(config.cacheValidTimeInterval > 0){
        
        NSMutableString *stringM = [NSMutableString stringWithString:config.urlPath];
        NSMutableArray *keyArr = [config.requestHeader.allKeys mutableCopy];
        
        if (keyArr.count > 0) {
            [keyArr sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
        }
       
        for (NSString *key in keyArr) {
            [stringM appendString:[NSString stringWithFormat:@"&%@=%@",key,config.requestHeader[key]]];
        }
        cacheKey = [self md5WithString:stringM.copy];
        
        GLD_Cache *cache = [[GLD_CacheManager shareCacheManager] objectForKey:cacheKey];
        if (cache.isValid) {
            completionHandle ? completionHandle(nil,cache.data) : nil;
            return @-1;
        }else{
            [[GLD_CacheManager shareCacheManager] removeObjectForKey:cacheKey];
        }
//        cacheKey	__NSCFString *	@"5444c431ac01ce2e14afee2e6b2f694f"	0x00000001742799c0
    }
    [self showHUD];
    WS(weakSelf);
    NSNumber *taskIdentifier = [[GLD_NetworkClient shareInstance] dispatchTaskWithPath:config.urlPath useHttps:config.useHttps requestType:config.requestType params:config.requestParameters headers:config.requestHeader completionHandle:^(NSURLResponse * response, id data, NSError *error) {
        [weakSelf.requestCaches removeObjectForKey:requestCache];
        [weakSelf hideHUD];
        
        if (error.code == NSURLErrorCancelled) {
            NSLog(@"请求被取消了~%@",config.urlPath);
            return ;
        }
//        if([data[@"code"] integerValue] != 200){
//            [CAToast showWithText:data[@"msg"]];
//            
//        }
        if (!error && config.cacheValidTimeInterval > 0) {
            GLD_Cache *cacheData = [GLD_Cache cacheWithData:data validTime:config.cacheValidTimeInterval];
//            [[GLD_CacheManager shareCacheManager] setObjcet:cacheData forKey:cacheKey];
            [[GLD_CacheManager shareCacheManager] setObjcet:cacheData key:cacheKey];
            
        }
        
        completionHandle ? completionHandle([weakSelf formatError:error], data):nil;
    }];
    [self.requestCaches setObject:taskIdentifier forKey:requestCache];
    return taskIdentifier;
    
}


- (NSError *)formatError:(NSError *)error{
    if(!error)return error;
    switch (error.code) {
        case NSURLErrorCancelled:
            error = gld_Error(gld_CanceledErrorNotice, gld_NetworkTaskErrorCanceled);
            break;
            
        case NSURLErrorTimedOut: error = gld_Error(gld_TimeoutErrorNotice, gld_NetworkTaskErrorTimeOut);
            break;
        case NSURLErrorCannotFindHost:
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorNotConnectedToInternet: error = gld_Error(gld_NetworkErrorNotice, gld_NetworkTaskErrorCannotConnectedToInternet);
            break;
            
        default: {
            error = gld_Error(gld_DefaultErrorNotice, gld_NetworkTaskErrorDefault);
        }   break;
    }
    
    return error;
}

- (NSString *)md5WithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    //    CC_MD5( cStr, strlen(cStr), result );
    return [[[NSString alloc] initWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSMutableDictionary *)requestCaches{
    if (!_requestCaches) {
        _requestCaches = [NSMutableDictionary dictionary];
    }
    return _requestCaches;
}
#pragma mark - MBProgressHUD
- (MBProgressHUD *)HUD {
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:[AppDelegate shareDelegate].window animated:YES];
        _HUD.mode = MBProgressHUDModeIndeterminate;
        _HUD.bezelView.color = [UIColor clearColor];
        _HUD.minShowTime = 0;//HUD_network_minShowTime;
    }
    return _HUD;
}
- (void)showHUD
{
    [self.HUD showAnimated:YES];
}
- (void)hideHUD
{
    if (_HUD) {
        [_HUD hideAnimated:NO];
        _HUD = nil;
    }
}

@end
