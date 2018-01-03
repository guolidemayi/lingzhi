//
//  GLD_BannerDetailController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/14.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BannerDetailController.h"
#import "SDCycleScrollView.h"
#import "GLD_BannerModel.h"
#import "GLD_ApplyBusnessController.h"
#import "GLD_ApplyUnionController.h"

@interface GLD_BannerDetailController ()<SDCycleScrollViewDelegate>


@property (nonatomic, copy)NSMutableArray *bannerData;
@property (nonatomic, copy)NSArray *titleArr;

@property (nonatomic, strong)SDCycleScrollView *cycleView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UIButton *shareBut;

@property (nonatomic, strong)UIButton *applyBut;//申请
@end

@implementation GLD_BannerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layout];
    self.title = @"详情";
}

- (void)setupUI{
    [self.view addSubview:self.cycleView];
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.applyBut];
    [self.view addSubview:self.shareBut];
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
}


- (void)setBannerData:(NSMutableArray *)bannerData{
    _bannerData = bannerData;
    NSMutableArray *arrM = [NSMutableArray array];
    
    self.cycleView.imageURLStringsGroup = arrM.copy;
    
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (index == self.titleArr.count - 1) {
        self.titleLabel.hidden = YES;
        self.shareBut.hidden = NO;
        self.applyBut.hidden = NO;
        [self.applyBut setTitle:self.titleArr[index] forState:UIControlStateNormal];
    }else{
        self.titleLabel.hidden = NO;
        self.shareBut.hidden = YES;
        self.applyBut.hidden = YES;
        if (index > self.titleArr.count) return;
        self.titleLabel.text = self.titleArr[index];
    }
}

- (void)layout{
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(W(-60));
    }];
    [self.shareBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(W(-60));
    }];
    
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.shareBut.mas_top);
    }];
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        
        
//        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
//        _cycleView.autoScroll = YES;
        _cycleView.showPageControl = NO;
        NSArray *arr = [self.bannerModel.Pictures componentsSeparatedByString:@";"];
//        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleView.localizationImageNamesGroup = arr;
        self.titleArr = [self.bannerModel.Titles componentsSeparatedByString:@";"];
        self.titleLabel.text = self.titleArr[0];
    }
    return _cycleView;
}

- (void)applybutClick{
    if (hasLogin) {
        [CAToast showWithText:@"已经登陆"];
    }else{
        switch (self.bannerModel.typeTitle) {
            case 0:{
                GLD_ApplyBusnessController *applyVc = [GLD_ApplyBusnessController new];
                [self.navigationController pushViewController:applyVc animated:YES];
            }break;
            case 1:{
                GLD_ApplyUnionController *applyVc = [GLD_ApplyUnionController new];
                [self.navigationController pushViewController:applyVc animated:YES];
            }break;
        }
    }
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
//        [_applyBut setTitle:@"申请合作" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        _applyBut.hidden = YES;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
- (UIButton *)shareBut{
    if (!_shareBut) {
        _shareBut = [[UIButton alloc]init];
        _shareBut.hidden = YES;
        [_shareBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        [_shareBut setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBut setImage:WTImage(@"分享 copy 3") forState:UIControlStateNormal];
        _shareBut.titleLabel.font = WTFont(12);
       
        [_shareBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBut;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
//        _titleLabel.text = @"我的钱包";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKwirte];
    }
    return _titleLabel;
}
@end
