//
//  GLD_KeyWordCell.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/24.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_KeyWordCell.h"
#import "GLD_DrawBut.h"
#import "GLD_TopicModel.h"

@interface GLD_KeyWordCell ()

@property (nonatomic, weak)UIScrollView *scrollView;
@end

NSString *const GLD_KeyWordCellIdentifi = @"GLD_KeyWordCellIdentifi";
@implementation GLD_KeyWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, H(54))];
        _scrollView = scrollView;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
    }
    return self;
}
- (void)butClick:(GLD_DrawBut *)but{
     
    if ([self.delegate respondsToSelector:@selector(gld_KeyWordCell:andType:)]) {
        [self.delegate gld_KeyWordCell:but.model andType:but.type];
    }
}

- (void)setKeyWordArr:(NSArray *)keyWordArr{
    _keyWordArr = keyWordArr;
    for (UIView *but in self.scrollView.subviews) {
        if ([but isMemberOfClass:[GLD_DrawBut class]]) {
            [but removeFromSuperview];
            
        }
    }
    
    //    CGFloat w = W(90);
    CGFloat h = H(34);
    CGFloat x = W(15);
    for (int i = 0; i < keyWordArr.count; i++) {
        GLD_TopicModel *model = keyWordArr[i];
        CGFloat beW = [YXUniversal calculateLabelWidth:20 text:[NSString stringWithFormat:@"# %@",model.categoryName] font:WTFont(15)]+ 15;
        NSString *butTitle = [NSString stringWithFormat:@"#%@",model.categoryName];
        
        NSInteger type = [butTitle hash] % 7;
        if (type < 0) {
            type = 0 - type;
        }
        CGFloat butW = MAX(beW, W(90));
        GLD_DrawBut *but = [[GLD_DrawBut alloc]initWithFrame:CGRectMake(x, H(10), butW, h) andType:type];
        [but setTitle:butTitle forState:UIControlStateNormal];
        [_scrollView addSubview:but];
        [but addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.titleLabel.font = WTFont(15);
        but.model = model;
        but.type = type;
        x = x + butW + W(15);
        [but startDrawlineChart];
        
    }
    _scrollView.contentSize = CGSizeMake(x, 0);
}
@end
