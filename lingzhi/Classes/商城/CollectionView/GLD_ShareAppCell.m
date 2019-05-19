//
//  GLD_ShareAppCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/18.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_ShareAppCell.h"
#import "GLD_ShareAppModel.h"

@interface GLD_ShareAppCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation GLD_ShareAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLD_ShareAppModel *)model{
    _model = model;
    [self.imgV yy_setImageWithURL:[NSURL URLWithString:model.logo] placeholder:WTImage(@"")];
    self.titleLabel.text = model.name;
}
@end
