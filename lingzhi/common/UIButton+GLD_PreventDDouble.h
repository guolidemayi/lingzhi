//
//  UIButton+GLD_PreventDDouble.h
//  test
//
//  Created by yiyangkeji on 2018/2/8.
//  Copyright © 2018年 com.guolide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (GLD_PreventDDouble)

@property (nonatomic, assign) NSTimeInterval gld_acceptEventInterval; // 重复点击的间隔(在按钮点击时间中设置此项值)

@end
