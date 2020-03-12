//
//  GLDTagItemCell.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/25.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import "GLDTagItemCell.h"


@interface GLDTagItemCell ()

@property (nonatomic, strong) UILabel *tagLabel;
@end
@implementation GLDTagItemCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)hasBorder:(BOOL)isYes{
    if (isYes) {
        _tagLabel.layer.borderWidth = 1;
    }else{
        _tagLabel.layer.borderWidth = 0;
    }
}
- (void)hasSelect:(BOOL)isYes{
    if (isYes) {
        
//        self.tagLabel.textColor = [UIColor whiteColor];
//        self.tagLabel.textColor = [UIColor colorWithHexString:THEM_TextYellow];
        
    }else{
//        self.tagLabel.textColor = [UIColor colorWithHexString:THEME_blacTitlekColor];
//        _tagLabel.textColor = [UIColor colorWithHexString:THEM_TextYellow];
    }
}
- (UILabel *)tagLabel {
   if (!_tagLabel) {
       _tagLabel = [UILabel new];
       _tagLabel.font = WTFont(16);
       _tagLabel.textAlignment = NSTextAlignmentCenter;
       _tagLabel.layer.cornerRadius = W(3);
       _tagLabel.layer.masksToBounds = YES;
       _tagLabel.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_tableViewBgColor];
//       _tagLabel.textColor = [UIColor colorWithHexString:THEM_TextYellow];
       _tagLabel.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKgray].CGColor;
       _tagLabel.layer.borderWidth = 0;
   }
   return _tagLabel;
}

@end
