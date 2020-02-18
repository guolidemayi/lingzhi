//
//  GLD_OrderDetailCell.m
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_OrderDetailCell.h"
#import "GLD_OrderDetailModel.h"

@interface GLD_OrderDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@end
@implementation GLD_OrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLD_OrderDetailModel *)model{
    _model = model;
    self.nameL.text = model.goodsName;
    self.priceL.text = [NSString stringWithFormat:@"价格:%@",model.prize];
    self.countL.text = [NSString stringWithFormat:@"数量:%@",model.goodscount];
    NSArray *arr = [model.goodsPic componentsSeparatedByString:@","];
       if (IsExist_Array(arr)) {
           [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:WTImage(@"")];
       }else{
          [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:model.goodsPic] placeholder:WTImage(@"")];
       }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
