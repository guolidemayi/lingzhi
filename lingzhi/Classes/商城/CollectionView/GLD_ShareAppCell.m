//
//  GLD_ShareAppCell.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/18.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_ShareAppCell.h"
#import "GLD_ShareAppModel.h"
#import "UIImageView+WebCache.h"

@interface GLD_ShareAppCell ()
@end
@implementation GLD_ShareAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.hidden = YES;
    self.imgV.layer.cornerRadius = 5;
    self.imgV.layer.masksToBounds = YES;
    self.titleLabel.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblack alpha:.8];
//    self.titleLabel.
}
- (void)setModel:(GLD_ShareAppModel *)model{
    _model = model;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
//    self.imgV.yy_imageURL = [NSURL URLWithString:@"http://ww4.sinaimg.cn/large/62b4e495gw1evvzalu8y8j20p018ggnw.jpg"];
//    [self.imgV yy_setImageWithURL:[NSURL URLWithString:model.logo] placeholder:WTImage(@"")];
    self.titleLabel.text = model.name;
}
@end
