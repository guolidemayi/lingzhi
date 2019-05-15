//
//  GLD_BangBanCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BangBanCell.h"
#import "GLD_ExpressModel.h"
@interface GLD_BangBanCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouJianRenLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipBut;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation GLD_BangBanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tipBut.layer.cornerRadius = 5;
}

- (void)setViewModel:(id<GLD_ExpressViewModelProtocol>)viewModel{
    _viewModel = viewModel;
    self.shouJianRenLabel.text = viewModel.receivedPhoneStr;
    self.phoneLabel.text = viewModel.receivedPersonStr;
    
    NSString *statusStr = @"";
    switch (viewModel.expressModel.state) {//0 可抢单 1 派件中 2 完成
        case 0:
            statusStr = @"抢单";
            break;
        case 1:
            statusStr = @"完成中";
            break;
        case 2:
            statusStr = @"完成";
            break;
    }
    [self.tipBut setTitle:statusStr forState:UIControlStateNormal];
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",viewModel.expressModel.start];
    self.priceLabel.text = viewModel.price;
    self.contentLabel.text = viewModel.expressModel.title;

}

@end
