//
//  GLD_BMessageCell.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/24.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GLD_ForumDetailModel;

@protocol GLD_BMessageCellDelegate <NSObject>

- (void)gld_BMessageCellDelegatePush:(NSString *)userId;

@end

extern  NSString  *const GLD_BMessageCellIdentifi;

@interface GLD_BMessageCell : UITableViewCell

@property (nonatomic, strong)GLD_ForumDetailModel *CCdetailModel;
@property (nonatomic, weak)id<GLD_BMessageCellDelegate> delegate;

@end
