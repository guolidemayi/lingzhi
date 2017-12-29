//
//  GLD_NewsCell.h
//  yxvzb
//
//  Created by yiyangkeji on 17/2/6.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol GLD_NewsCellDelegate <NSObject>

- (void)refreshCellHeight:(CGFloat)height;
@optional
- (void)pushToViewControllor:(NSString *)courseId;
@end
@interface GLD_NewsCell : UITableViewCell

@property(nonatomic,strong) NSString *contentString;
@property(nonatomic,weak) id<GLD_NewsCellDelegate> delegate;

@property (nonatomic, strong)NSString *forumDetailUrl;

@end
