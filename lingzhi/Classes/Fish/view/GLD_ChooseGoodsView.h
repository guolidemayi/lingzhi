//
//  GLD_ChooseGoodsView.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/8.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLD_ChooseGoodsViewDelegate <NSObject>

- (void)didSelectedTimeItem:(NSInteger)index andChooseCount:(NSInteger)count;

@end
@class GLD_StoreDetailModel;
@interface GLD_ChooseGoodsView : UIView

+ (instancetype)instanceChooseGoodsView;
@property (nonatomic, strong)GLD_StoreDetailModel *storeModel;
@property (nonatomic, weak) id<GLD_ChooseGoodsViewDelegate> timeDelegate;
@end

NS_ASSUME_NONNULL_END
