//
//  GLD_CarListCell.h
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

NS_ASSUME_NONNULL_BEGIN


@protocol GLD_CarListCellDelegate <NSObject>

- (void)payCount:(NSInteger)count andIndex:(NSInteger)index;

@end
@class GLD_StoreDetailModel;
@interface GLD_CarListCell : GLD_BaseCell

@property (nonatomic, strong) GLD_StoreDetailModel *detailModel;
@property (nonatomic, weak) id<GLD_CarListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *addBUt;

@property (weak, nonatomic) IBOutlet UIButton *deleteBut;
@end

NS_ASSUME_NONNULL_END
