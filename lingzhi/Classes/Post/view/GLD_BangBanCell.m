//
//  GLD_BangBanCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BangBanCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
