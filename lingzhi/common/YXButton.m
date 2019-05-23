//
//  Created by 吴凯强 on 16/6/2.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "YXButton.h"



@interface YXButton ()

@end

@implementation YXButton

+ (instancetype)creatButWithTitle:(nullable NSString *)title andImageStr:(nullable NSString *)imgStr andFont:(NSInteger)font andTextColorStr:(NSString *)colorStr {
    
    
    YXButton *but = [[YXButton alloc] init];
    but.label.textColor = [YXUniversal colorWithHexString:colorStr ? colorStr : COLOR_YX_DRAKBLUE];
    
    but.imgV.image = [UIImage imageNamed:imgStr];
    
    but.label.font = font ? WTFont(font) : WTFont(15);
    but.label.text = title;
    return but;
    
}


- (instancetype)init {
    self = [super init];
    if (self) {

        self.imgV = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgV];
        [self addSubview:self.label];
       
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.imgV = [[UIImageView alloc] init];
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgV];
        [self addSubview:self.label];
        
    }
    
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        //        make.bottom.equalTo(self.titleLabel.mas_top);
        make.height.equalTo(@(self.frame.size.height * 0.60));
        
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@(self.frame.size.height * 0.30));
        make.centerX.equalTo(self);
    }];
    
}
@end
