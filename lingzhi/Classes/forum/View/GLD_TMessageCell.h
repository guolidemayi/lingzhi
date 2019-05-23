//
//  GLD_TMessageCell.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/21.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_ForumDetailModel;

@protocol GLD_TMessageCellDelegate <NSObject>

- (void)gld_TMessageCellDelegatePush:(NSString *)userId;

@end

extern  NSString  *const GLD_TMessageCellIdentifi;

@interface GLD_TMessageCell : UITableViewCell

@property (nonatomic, weak)id<GLD_TMessageCellDelegate> delegate;
@property (nonatomic, strong)GLD_ForumDetailModel *BLdetailModel;
@property (nonatomic, strong)GLD_ForumDetailModel *TZdetailModel;

@end
