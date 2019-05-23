//
//  GLD_StoreDetailCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_StoreDetailCell.h"



@interface GLD_StoreDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeImgV;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *storePriceLabel;
@end

@implementation GLD_StoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStoreModel:(GLD_StoreDetailModel *)storeModel{
    _storeModel = storeModel;
    
    self.storePriceLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"￥%.2f",MAX(storeModel.price.floatValue, 0)] find:@"￥"  flMaxFont:25 flMinFont:10 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    
    if([storeModel.pic containsString:@","]){
        NSArray *arr = [storeModel.pic componentsSeparatedByString:@","];
        [self.storeImgV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:nil];
    }else{
        
        [self.storeImgV yy_setImageWithURL:[NSURL URLWithString:storeModel.pic] placeholder:nil];
    }
    self.storeNameLabel.text = GetString(storeModel.title);
    self.storeDetailLabel.text = GetString(storeModel.summary);
    
}

@end
