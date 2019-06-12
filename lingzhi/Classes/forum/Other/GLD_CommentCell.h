//
//  GLD_CommentCell.h
//  yxvzb
//
//  Created by yiyangkeji on 17/1/13.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GLD_CommentType) {
    GLD_CommentLike = 2019,
    GLD_CommentRecord = 2020,
     GLD_CommentUser = 2021,
    GLD_CommentBeUser = 2022
};


@class YXCommentContent2Model;

@protocol GLD_CommentCellDelegate <NSObject>

- (void)showPopViewInSomeWhere:(NSIndexPath *)indexPath andLocation:(CGFloat)location;

@end

typedef void(^commentBlock)(NSIndexPath *index,GLD_CommentType type);
@class GLD_Button;
@interface GLD_CommentCell : UITableViewCell 

@property (nonatomic,strong) NSIndexPath * commentIndexPath;
@property (nonatomic, strong)YXCommentContent2Model *commentModel;
@property (nonatomic, copy)commentBlock commentBlock;
@property (nonatomic, strong) GLD_Button *likeBut;
@property (nonatomic, weak)id<GLD_CommentCellDelegate> delegate;
@end
