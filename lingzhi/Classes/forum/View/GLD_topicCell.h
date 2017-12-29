//
//  GLD_topicCell.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXRecordButton,GLD_topicCell,GLD_TopicModel;
@protocol GLD_topicCellDelegate <NSObject>

- (void)deleteOraddTopicCallBack:(NSString *)topic andCell:(GLD_topicCell *)cell isDelete:(BOOL)del;

@end
@interface GLD_topicCell : UICollectionViewCell

@property (nonatomic, strong)NSString *topicName;
@property (nonatomic, strong)GLD_TopicModel *topicModel;

@property (nonatomic, weak)id<GLD_topicCellDelegate> delegate;
@end
