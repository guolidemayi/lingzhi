//
//  GLD_BannerCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BannerCell.h"
#import "SDCycleScrollView.h"

@interface GLD_BannerCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)SDCycleScrollView *cycleView;

@end
@implementation GLD_BannerCell

- (void)setupUI{
    [self.contentView addSubview:self.cycleView];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}


- (void)setBannerData:(NSMutableArray *)bannerData{
    _bannerData = bannerData;
    self.cycleView.imageURLStringsGroup = bannerData.copy;
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}

- (void)layout{
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                                delegate:self
                                                        placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];

        
        _cycleView.autoScrollTimeInterval = 5.;// 自动滚动时间间隔
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
@end
