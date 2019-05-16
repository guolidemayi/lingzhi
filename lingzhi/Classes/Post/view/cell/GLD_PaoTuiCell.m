//
//  GLD_PaoTuiCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_PaoTuiCell.h"
#import "GLD_ExpressModel.h"

@interface GLD_PaoTuiCell ()
@property (weak, nonatomic) IBOutlet UILabel *sendPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *starAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipBut;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *receivedPhoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;

@end
@implementation GLD_PaoTuiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setViewModel:(id<GLD_ExpressViewModelProtocol>)viewModel{
    _viewModel = viewModel;
    self.sendPhoneLabel.text = viewModel.sendPhoneStr;
    self.sendPersonLabel.text = viewModel.sendPersonStr;
    self.receivedPhoneLabel.text = viewModel.receivedPhoneStr;
    self.receivedPersonLabel.text = viewModel.receivedPersonStr;
    
    NSString *statusStr = @"";
    switch (viewModel.expressModel.state) {//0 可抢单 1 派件中 2 完成
        case 0:
            statusStr = @"抢单";
            self.sendPhoneLabel.hidden = YES;
            self.receivedPhoneLabel.hidden = YES;
            break;
        case 1:
            statusStr = @"完成中";
            self.sendPhoneLabel.hidden = NO;
            self.receivedPhoneLabel.hidden = NO;
            break;
        case 2:
            statusStr = @"完成";
            self.sendPhoneLabel.hidden = YES;
            self.receivedPhoneLabel.hidden = YES;
            break;
    }
    [self.tipBut setTitle:statusStr forState:UIControlStateNormal];
    
    [self.imgV yy_setImageWithURL:viewModel.goodsPic placeholder:WTImage(@"")];
    self.starAddressLabel.text = viewModel.expressModel.start;
    self.endAddressLabel.text = viewModel.expressModel.end;
    self.priceLabel.text = viewModel.price;
    self.contentLabel.text = viewModel.expressModel.title;
    self.detailViewHeight.constant = MAX(viewModel.contentHeight, 68);
}

@end
