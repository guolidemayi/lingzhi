//
//  GLD_CarListCell.m
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_CarListCell.h"
#import "GLD_StoreDetailModel.h"

@interface GLD_CarListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *shopNameL;
@property (nonatomic, assign) NSInteger countNum;

@end
@implementation GLD_CarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.countNum = 1;
}
- (void)setDetailModel:(GLD_StoreDetailModel *)detailModel{
    _detailModel = detailModel;
    NSArray *arr = [detailModel.pic componentsSeparatedByString:@","];
    if (IsExist_Array(arr)) {
        [self.goodsImageV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:WTImage(@"")];
    }else{
       [self.goodsImageV yy_setImageWithURL:[NSURL URLWithString:detailModel.pic] placeholder:WTImage(@"")];
    }
   
    self.goodsNameL.text = detailModel.title;
    self.priceL.text = [NSString stringWithFormat:@"单价：%@",detailModel.price];
}
- (IBAction)jianshaoClick:(id)sender {
    
    if (self.countNum == 1) {
        return;
    }
    self.countNum -= 1;
    [self goback];
    
}
- (IBAction)addClick:(id)sender {
    self.countNum += 1;
    [self goback];
}

- (void)goback{
    self.countL.text = [NSString stringWithFormat:@"%zd",self.countNum];
    if ([self.delegate respondsToSelector:@selector(payCount:andIndex:)]) {
        [self.delegate payCount:self.countNum andIndex:self.indexPath.row];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
