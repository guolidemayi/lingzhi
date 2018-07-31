//
//  GLD_GoodsDetailCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsDetailCell.h"
#import "GLD_StoreDetailModel.h"

@interface GLD_GoodsDetailCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *storeTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *StoreDetailLabel;
@end
@implementation GLD_GoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStoreModel:(GLD_StoreDetailModel *)storeModel{
    _storeModel = storeModel;
    self.priceLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"￥%zd",MAX(storeModel.storePrice/100, 0)] find:@"￥"  flMaxFont:25 flMinFont:10 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    
    self.storeTitleLabel.text = storeModel.storeName;
    self.StoreDetailLabel.text = storeModel.storeDetail;
    
}

@end
