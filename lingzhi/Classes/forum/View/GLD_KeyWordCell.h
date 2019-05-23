//
//  GLD_KeyWordCell.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/24.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GLD_KeyWordCellIdentifi;

@class GLD_TopicModel;
@protocol GLD_KeyWordCellDelegate <NSObject>

- (void)gld_KeyWordCell:(GLD_TopicModel *)model andType:(NSInteger)type;

@end
@interface GLD_KeyWordCell : UITableViewCell
@property (nonatomic, weak)id<GLD_KeyWordCellDelegate>delegate;

@property(nonatomic,strong)NSArray  *keyWordArr;
@end
