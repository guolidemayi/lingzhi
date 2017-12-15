//
//  GLD_MapDetailCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

extern NSString *const GLD_MapDetailCellIdentifier;

@protocol GLD_MapDetailCellDelegate <NSObject>

- (void)reloadApplyListHeight:(CGFloat) height;

- (void)selectLocation:(AMapPOI *)location;
@end
@interface GLD_MapDetailCell : GLD_BaseCell

@property (nonatomic, copy)NSArray *dataArr;

@property (nonatomic, weak)id<GLD_MapDetailCellDelegate> mapDelegate;

@end
