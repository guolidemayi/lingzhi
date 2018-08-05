//
//  GLD_ExpressCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressCell.h"

@interface GLD_ExpressCell ()
@property (weak, nonatomic) IBOutlet UIButton *robBut;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@end

@implementation GLD_ExpressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCompoent];
}
- (void)setCompoent{
    self.robBut.layer.cornerRadius = 3;
    self.robBut.layer.masksToBounds = YES;
}
- (IBAction)robButClick:(UIButton *)sender {
    if ([self.expressDelegate respondsToSelector:@selector(robExpress:andType:)]) {
        [self.expressDelegate robExpress:self.expressModel andType:self.type];
    }
}
- (void)setType:(robType)type{
    _type = type;
    switch (type) {
        case robTypeGetExpress:{
            [self.robBut setTitle:@"抢单" forState:UIControlStateNormal];
        }break;
        case robTypeMyExpress:{
            [self.robBut setTitle:@"导航" forState:UIControlStateNormal];
        }break;
    }
}
- (void)setExpressModel:(GLD_ExpressModel *)expressModel{
    _expressModel = expressModel;
    self.priceLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"￥%zd",MAX(expressModel.price/100, 0)] find:@"￥"  flMaxFont:25 flMinFont:10 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    
    self.fromLabel.text = GetString(expressModel.start);
    self.toLabel.text = GetString(expressModel.end);
    self.tipLabel.text = GetString(expressModel.title);
}

@end
