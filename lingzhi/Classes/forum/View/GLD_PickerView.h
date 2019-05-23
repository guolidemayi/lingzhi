//
//  GLD_PickerView.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_TopicModel;
typedef void(^pickerViewBlock)(GLD_TopicModel *model);
@interface GLD_PickerView : UIView

//目前只支持两组或者一组的情况。  dict有值则加载第二组 
+ (instancetype)gld_getPickerViewWithContent:(NSArray *)contentArr andDict:(NSDictionary *)dict andBlock:(pickerViewBlock)block;
//显示pickerView
- (void)showPickerVeiw;
@end
