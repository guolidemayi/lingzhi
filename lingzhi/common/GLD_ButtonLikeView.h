//
//  GLD_ButtonLikeView.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLD_ButtonLikeView : UIView

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *imgStr;
- (instancetype)initWithTitleColor:(UIColor *)color Font:(NSInteger)font;
@end
