//
//  GLD_ExpressCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressCell.h"

@interface GLD_ExpressCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
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
    switch (self.type) {
        case robTypeGetExpress:{
            self.type = robTypeHasRob;
        }break;
        case robTypeMyExpress:{
           
        }break;
        case robTypeHasRob:{
           
        }break;
    }
}
- (void)setType:(robType)type{
    _type = type;
    switch (type) {
        case robTypeGetExpress:{
            [self.robBut setTitle:@"抢单" forState:UIControlStateNormal];
        }break;
        case robTypeMyExpress:{
            [self.robBut setTitle:@"完成" forState:UIControlStateNormal];
        }break;
        case robTypeHasRob:{
            [self.robBut setTitle:@"配送中" forState:UIControlStateNormal];
        }break;
    }
}
- (void)setExpressModel:(GLD_ExpressModel *)expressModel{
    _expressModel = expressModel;
    self.priceLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"￥%zd",MAX(expressModel.price, 0)] find:@"￥"  flMaxFont:25 flMinFont:10 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",expressModel.phone];
    switch (expressModel.status) {
        case 0:{
            self.type = robTypeGetExpress;
        }break;
        case 1:{
            self.type = robTypeMyExpress;
        }break;
        case 2:{
            self.type = robTypeHasRob;
        }break;
    }
    self.fromLabel.text = GetString(expressModel.start);
    self.toLabel.text = GetString(expressModel.end);
    self.tipLabel.text = GetString(expressModel.title);
}

@end
