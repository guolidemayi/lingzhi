//
//  GLD_CarouselModel.h
//  YHImageCarousel
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLD_CarouselModel : NSObject

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, assign)NSInteger showTime;
@property (nonatomic, copy) NSString *courseType;//课程类型 1线上。0线下
@property (nonatomic, copy)NSString *titleName; //名称


@property (nonatomic, copy) NSString *courseId;

+ (instancetype)instanceCarouselModelWith:(NSDictionary *)dict;
@end
