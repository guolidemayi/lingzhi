//
//  GLD_NewPayGoodsCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/14.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_NewPayGoodsCell.h"

@interface GLD_NewPayGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation GLD_NewPayGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setStoreModel:(GLD_StoreDetailModel *)storeModel{
    _storeModel = storeModel;
    NSArray *arr = [storeModel.pic componentsSeparatedByString:@","];
    if (IsExist_Array(arr)) {
        [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:WTImage(@"")];
    }
    self.titleLabel.text = storeModel.title;
    self.detailLabel.text = storeModel.summary;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",storeModel.price.floatValue * storeModel.seleteCount];
    self.countLabel.text = [NSString stringWithFormat:@"x%zd",storeModel.seleteCount];
}

@end
