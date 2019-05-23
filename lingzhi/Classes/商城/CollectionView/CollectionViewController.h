//
//  CollectionViewController.h
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "GLD_BaseViewController.h"
/**
 * 积分
 */
//String SCORE = "1";
///**
// * 特卖
// */
//String SELL = "2";
///**
// * 代金券
// */
//String TICKET = "3"

@interface CollectionViewController : GLD_BaseViewController

@property (nonatomic, assign) NSInteger type;//1积分商城 2 特卖 2 代金券
@end
