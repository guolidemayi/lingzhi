//
//  GLD_RemindCell.h
//  yxvzb
//
//  Created by yiyangkeji on 17/2/8.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_RemindModel;
@interface GLD_RemindCell : UITableViewCell
@property(nonatomic,weak) UIImageView *accImageV;
@property(nonatomic,strong) GLD_RemindModel * model;
@end
