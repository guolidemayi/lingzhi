//
//  GLD_MessageUserInfoTool.m
//  yxvzb
//
//  Created by yiyangkeji on 2018/8/13.
//  Copyright © 2018年 sendiyang. All rights reserved.
//

#import "GLD_MessageUserInfoTool.h"


@implementation GLD_MessageUserInfoTool


+ (NSString *)path {
    return [NSString stringWithFormat:@"%@/Documents/GoodsObject/",NSHomeDirectory()];
}

+ (NSString *)cachePlistDirectory {
    return [NSString stringWithFormat:@"%@/Documents/GLDGoodsPlistDirectory/",NSHomeDirectory()];
}

+ (NSString *)plistPath {
    return [NSString stringWithFormat:@"%@GLDGoods.plist",[self cachePlistDirectory]];
}

+ (GLD_StoreDetailModel *)readDiskCache:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@%@",[self path],key]];
}

+ (void)createCacheDirectory:(NSString *)path {
    NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fm fileExistsAtPath:path isDirectory:&isDirectory]) {
        [fm createDirectoryAtPath:path
      withIntermediateDirectories:YES
                       attributes:@{NSFileProtectionKey:NSFileProtectionNone} error:nil];
    }
}

+ (void)writeDiskCache: (GLD_StoreDetailModel *)model {
    
    if (IsExist_String(model.storeId)) {
        //取数据，不是一个商家的不让加入购物车
        NSArray *arr = [self readDiskAllCache];
        if (IsExist_Array(arr)) {
            GLD_StoreDetailModel *oldModel = arr.firstObject;
            if (![oldModel.userId isEqualToString:model.userId]) {
                [CAToast showWithText:@"购物车里不能选择其它商家的产品, 请先结算"];
                return;
            }
        }
        if([[self readDiskAllCache] containsObject:model]){
            [CAToast showWithText:@"已加过购物车"];
            return;
        }
        model.count = @(1);
        [self createCacheDirectory:[self path]];
        [NSKeyedArchiver archiveRootObject:model
                                    toFile:[NSString stringWithFormat:@"%@%@",[self path],model.storeId]];
        [self createCacheDirectory:[self cachePlistDirectory]];
        NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self plistPath]];
        if (cacheDictionary == nil) {
            cacheDictionary = [NSMutableDictionary dictionary];
        }
        [cacheDictionary setObject:@"GLD" forKey:model.storeId];
        [cacheDictionary writeToFile:[self plistPath] atomically:YES];
        [CAToast showWithText:@"已加入"];
    }else{
        NSLog(@"没有广告Id");
    }
}
+ (void)removeAdsList: (GLD_StoreDetailModel *)model{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@%@",[self path],model.storeId]]) {
        [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@",[self path],model.storeId] error:nil];
        NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self plistPath]];
        if (cacheDictionary != nil) {
            [cacheDictionary removeObjectForKey:model.storeId];
            [cacheDictionary writeToFile:[self plistPath] atomically:YES];
        }
    }
}
+ (NSArray *)readDiskAllCache {
    NSMutableArray * downloadObjectArr = [NSMutableArray array];
    NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self plistPath]];
    if (cacheDictionary != nil) {
        NSArray * allKeys = [cacheDictionary allKeys];
        for (NSString * key in allKeys) {
            GLD_StoreDetailModel *model = [self readDiskCache:key];
            if (model) {
                [downloadObjectArr addObject:model];
            }
        }
    }
    return downloadObjectArr.copy;
}

+ (void)removeAllObj{
    
    NSMutableDictionary * cacheDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[self plistPath]];
    if (cacheDictionary != nil) {
        NSArray * allKeys = [cacheDictionary allKeys];
        for (NSString * key in allKeys) {
            GLD_StoreDetailModel *model = [self readDiskCache:key];
            [self removeAdsList:model];
        }
    }
}

@end
