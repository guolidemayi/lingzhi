//
//  GLD_CommentBottomView.m
//  yxvzb
//
//  Created by yiyangkeji on 17/1/16.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_CommentBottomView.h"

typedef NS_ENUM(NSInteger, recordType) {
    
    recordTypeTeacher = 2017,
    recordTypeAuth,
    recordTypeNotAuth
};
@interface GLD_CommentBottomView ()
{
    UIButton *recordBut;
    UIButton *textBut;
    
    UILabel *countLabel;
    UIButton *shareBut;
}

@property (nonatomic, assign) recordType rType;
@end


@implementation GLD_CommentBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXUniversal colorWithHexString:@"#F7F7F7"];
        [self setUI];
        [self layout];
        
    }
    return self;
}


- (void)recordClick:(UIButton *)senser{

    switch (self.rType) {
        case recordTypeTeacher:
            // App-评论-语音评论
            
            [_delegate record];
            break;
        case recordTypeAuth:
            // App-评论-实名徽章
          
            NSLog(@"auth");
            break;
        case recordTypeNotAuth:
            // App-评论-实名徽章
            [_delegate toAuth];
            break;
    }
   
}

- (void)textClick{
    // App-评论-点击文本框

    [_delegate content];
}
- (void)collectionClick: (UIButton *)senser{
    // App-评论-收藏
    
    [_delegate collection:senser];
}
- (void)shareClick{
    // App-评论-分享
  
    [_delegate share];
}
- (void)countLabelCorlor:(BOOL)isCollection{
    !isCollection ? (countLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]) : (countLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTyellow]);
}

- (void)setCount:(NSInteger)count{
    _count = count;
    if(count > 99){
        countLabel.text = @"99+";
    }else{
    countLabel.text = [NSString stringWithFormat:@"%zd",count];
    }
}


- (void)setBottomContent:(NSString *)bottomContent{
    _bottomContent = bottomContent;
    _textFeild.placeholder = bottomContent;
}

- (void)showAuthOrOthersStates:(NSInteger)status{
    switch (status) {
        case 1:{
            [recordBut setBackgroundImage:[UIImage imageNamed:@"语音按钮"] forState:UIControlStateNormal];
            self.rType = recordTypeTeacher;
        }break;
        case 2:{
            [recordBut setBackgroundImage:[UIImage imageNamed:@"已实名v2"] forState:UIControlStateNormal];
            self.rType = recordTypeAuth;
        }break;
        case 3:{
            [recordBut setBackgroundImage:[UIImage imageNamed:@"未实名v2"] forState:UIControlStateNormal];
            self.rType = recordTypeNotAuth;
        }break;
        
    }
}

- (void)setUI{
    
    recordBut = [[UIButton alloc]init];
    [recordBut setBackgroundImage:[UIImage imageNamed:@"语音按钮"] forState:UIControlStateNormal];
    [recordBut addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _textFeild = [[UITextField alloc] init];
    _textFeild.borderStyle = UITextBorderStyleRoundedRect;
    _textFeild.placeholder = @" 说点什么";
    _textFeild.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKwirte];
    textBut = [[UIButton alloc]init];
    [textBut addTarget:self action:@selector(textClick) forControlEvents:UIControlEventTouchUpInside];
    _collectionBut = [[UIButton alloc] init];
    [_collectionBut setImage:WTImage(@"未收藏pinglun ") forState:UIControlStateNormal];
    [_collectionBut setImage:WTImage(@"未收藏pinglun ") forState:UIControlStateHighlighted];
    [_collectionBut setImage:WTImage(@"收藏 pinglun") forState:UIControlStateSelected];
    [_collectionBut setImage:WTImage(@"收藏 pinglun") forState:UIControlStateSelected | UIControlStateHighlighted];
    [_collectionBut addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
    countLabel = [UILabel creatLableWithText:@"" andFont:WTFont(10) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray]];
    shareBut = [[UIButton alloc]init];
    [shareBut setImage:WTImage(@"分享pinglun") forState:UIControlStateNormal];
    [shareBut addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:recordBut];
    [self addSubview:_textFeild];
    [self addSubview:textBut];
    [self addSubview:_collectionBut];
    [self addSubview:countLabel];
    [self addSubview:shareBut];
}

- (void)layout{
  
    
    [recordBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(W(10));
        make.left.equalTo(self).offset(W(15));
        make.width.equalTo(WIDTH(25));
        make.height.equalTo(WIDTH(25));
    }];
    [shareBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(W(-15));
        make.centerY.equalTo(recordBut);
        make.width.equalTo(WIDTH(25));
        make.height.equalTo(WIDTH(25));
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_collectionBut.mas_top);
        make.centerX.equalTo(_collectionBut.mas_right);
    }];
    [_collectionBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(recordBut);
        make.right.equalTo(shareBut.mas_left).offset(W(-15));
        make.width.equalTo(WIDTH(25));
        make.height.equalTo(WIDTH(25));
    }];
    [_textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(recordBut);
        make.left.equalTo(recordBut.mas_right).offset(W(10));
        make.right.equalTo(_collectionBut.mas_left).offset(W(-10));
    }];
    [textBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_textFeild);
        make.width.height.equalTo(_textFeild);
    }];
    
}
@end
