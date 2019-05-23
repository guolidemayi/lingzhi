//
//  WTBootPageStartViewController.m
//  WorldTradeApp
//
//  Created by liuxiting on 15/6/8.
//  Copyright (c) 2015年 Appconomy. All rights reserved.
//

#import "WTBootPageStartViewController.h"


@interface WTBootPageStartViewController ()

@end

@implementation WTBootPageStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self scrollEnable:NO];
//    [self hideNavigationBar];
    //TODO:临时用的，确定UI后视情况删除
    self.bootScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.bootScrollView.contentSize = CGSizeMake(DEVICE_WIDTH * 3, 0);
    self.imageView_1.frame = CGRectMake(0, -STATUS_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.imageView_2.frame = CGRectMake(DEVICE_WIDTH, -STATUS_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.imageView_3.frame = CGRectMake(DEVICE_WIDTH * 2, -STATUS_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.imageView_3.userInteractionEnabled = YES;
    self.bootScrollView.pagingEnabled = YES;
    self.bootScrollView.delegate = self;
    
}


- (void)pushToBootPageEndVCtrl
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:isFirstLogin];
    //进入首页
    [[AppDelegate shareDelegate] initMainPageBody];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > DEVICE_WIDTH * 1.1) {

        UIButton *but = [[UIButton alloc]init];
        but.backgroundColor = [UIColor clearColor];
        [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView_3 addSubview:but];
        
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imageView_3).offset(-40*DEVICEHEIGHT_SCALE);
            make.centerX.equalTo(self.imageView_3);
            make.height.equalTo(@50);
            make.width.equalTo(@150);
            
        }];
        
    }
    
    

}

- (void)butClick{
    
    [self pushToBootPageEndVCtrl];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.view removeFromSuperview];
    [UIView commitAnimations];
}

@end
