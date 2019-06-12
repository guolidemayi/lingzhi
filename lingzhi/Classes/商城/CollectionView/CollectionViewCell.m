//
//  CollectionViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionCategoryModel.h"
#import "CollectionViewCell.h"
#import "GLD_StoreDetailModel.h"

@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.layer.cornerRadius = 5;
        self.imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageV];

        self.name = [[UILabel alloc] init];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.name];
        self.price = [UILabel creatLableWithText:@"" andFont:WTFont(13) textAlignment:NSTextAlignmentRight textColor:[YXUniversal colorWithHexString:COLOR_YX_RED_TEXT]];
        [self.contentView addSubview:self.price];
        [self layout];
        self.contentView.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline].CGColor;
        self.contentView.layer.borderWidth = 1;
        
    }
    return self;
}

- (void)layout{
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView).offset(8);
        //        make.right.equalTo(self.contentView).offset()
        make.bottom.equalTo(self.name.mas_top);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV);
        make.height.equalTo(HEIGHT(20));
        make.bottom.equalTo(self.contentView);
        make.width.equalTo(WIDTH(100));
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageV);
        make.centerY.equalTo(self.name);
    }];
}
- (void)setModel:(GLD_StoreDetailModel *)model
{
    _model = model;
    NSArray *arr = [model.pic componentsSeparatedByString:@","];
    if (IsExist_Array(arr)) {
        [self.imageV yy_setImageWithURL:[NSURL URLWithString:arr.firstObject] placeholder:WTImage(@"")];
    }
    self.name.text = model.title;
    self.price.text = [NSString stringWithFormat:@"¥ %zd",model.price.integerValue];
}

@end
