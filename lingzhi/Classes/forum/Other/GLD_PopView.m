//
//  GLD_PopView.m
//  yxvzb
//
//  Created by yiyangkeji on 17/1/17.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PopView.h"


#define kXHALbumOperationViewSize CGSizeMake(W(200), H(50))
@interface GLD_PopView ()
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *deleteBut;
@property (nonatomic, strong) UIButton *burnButton;
@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, assign) CGRect targetRect;

@end

@implementation GLD_PopView

+ (instancetype)initailzerWFOperationView {
    GLD_PopView *operationView = [[GLD_PopView alloc] initWithFrame:CGRectZero];
    return operationView;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 5.0;
        [self addSubview:self.bgImageV];
        [self addSubview:self.replyButton];
        [self addSubview:self.burnButton];
        [self addSubview:self.deleteBut];
    }
    return self;
}


#pragma mark - 公开方法

- (void)showAtView:(UITableView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour {
    self.targetRect = targetRect;
   
    if (self.shouldShowed) {
        return;
    }
    
    [containerView addSubview:self];
    self.hidden = NO;
    
    CGFloat width = kXHALbumOperationViewSize.width;
    CGFloat height = kXHALbumOperationViewSize.height;
    
    self.frame = CGRectMake(targetRect.origin.x+ W(150), targetRect.origin.y - H(20) - height, width, 0);
    self.shouldShowed = YES;
    _bgImageV.frame = CGRectMake(0, 0, width, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = CGRectMake(targetRect.origin.x + W(150), targetRect.origin.y - H(20), width, height);
        _bgImageV.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
        [_deleteBut setTitle:(isFavour?@" 删除":@" 举报") forState:UIControlStateNormal];
        _deleteBut.tag = (isFavour?2:3);
        [_deleteBut setImage:[UIImage imageNamed:(isFavour?@"删除-评论":@"举报")] forState:UIControlStateNormal];
        [_replyButton setTitle:@" 回复" forState:UIControlStateNormal];
        [_replyButton setImage:[UIImage imageNamed:@"回复"] forState:UIControlStateNormal];
        _burnButton.tag = (containerView.tag == 1970?4:1);
        [_burnButton setTitle:(containerView.tag == 1970?@" 主题":@" 复制") forState:UIControlStateNormal];
        [_burnButton setImage:[UIImage imageNamed:@"复制"] forState:UIControlStateNormal];
    }];
}

- (void)dismiss {
    
    
    if (!self.shouldShowed) {
        return;
    }
    
    self.shouldShowed = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        [_deleteBut setTitle:nil forState:UIControlStateNormal];
        [_deleteBut setImage:nil forState:UIControlStateNormal];
        [_replyButton setTitle:nil forState:UIControlStateNormal];
        [_replyButton setImage:nil forState:UIControlStateNormal];
        [_burnButton setTitle:nil forState:UIControlStateNormal];
        [_burnButton setImage:nil forState:UIControlStateNormal];
        CGFloat width = kXHALbumOperationViewSize.width;
        self.frame = CGRectMake(self.targetRect.origin.x + W(150), self.targetRect.origin.y - H(20) - kXHALbumOperationViewSize.height, width, 0);
        _bgImageV.frame = CGRectMake(0, 0, width, 0);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.hidden = YES;
        
    }];
}


- (void)operationDidClicked:(UIButton *)senser{
    
    [self dismiss];
    if (self.didSelectedOperationCompletion) {
        self.didSelectedOperationCompletion(senser.tag);
      
        /*
         GLD_OperationTypeReply = 0,
         GLD_OperationTypeCopy = 1,
         GLD_OperationTypeDelete = 2,
         GLD_OperationTypeJuBao = 3,
         GLD_OperationTypeTheme = 4,
         */
    }
    
}


- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.tag = 0;
        [_replyButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_replyButton setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
        _replyButton.frame = CGRectMake(0, H(-5), kXHALbumOperationViewSize.width / 3.0, kXHALbumOperationViewSize.height);
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_replyButton.frame)-0.5, H(15), 0.5, H(20))];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
        [_replyButton addSubview:lineView];
        
    }
    return _replyButton;
}

- (UIButton *)burnButton {
    if (!_burnButton) {
       
        _burnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _burnButton.tag = 1;
         [_burnButton setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
        [_burnButton addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _burnButton.frame = CGRectMake(CGRectGetMaxX(_replyButton.frame), H(-5), CGRectGetWidth(_replyButton.bounds), CGRectGetHeight(_replyButton.bounds));
        _burnButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_burnButton.frame)-0.5, H(15), 0.5, H(20))];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
        [_burnButton addSubview:lineView];
    }
    return _burnButton;
}
- (UIButton *)deleteBut {
    if (!_deleteBut) {
        _deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
         [_deleteBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
        [_deleteBut addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBut.frame = CGRectMake(CGRectGetMaxX(_burnButton.frame), H(-5), CGRectGetWidth(_burnButton.bounds), CGRectGetHeight(_burnButton.bounds));
        _deleteBut.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _deleteBut;
}

- (UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc]init];
        _bgImageV.image = [UIImage imageNamed:@"回复、复制底"];
    }
    
    return _bgImageV;
}
@end
