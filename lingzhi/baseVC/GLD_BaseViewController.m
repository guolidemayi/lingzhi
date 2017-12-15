//
//  GLD_BaseViewController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/23.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@interface GLD_BaseViewController ()

@end

@implementation GLD_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)outLayoutSelfSubviews
{
    for (UIView *views in self.view.subviews) {
        views.frame = WTCGRectMake(views.frame);
        
        if ([views isKindOfClass:[UIWebView class]]) {
            continue;
        }
        if ([views isKindOfClass:[UIButton class]]) {
            continue;
        }
        if ([views isKindOfClass:[UISearchBar class]]){
            continue;
        }
        for (UIView *subViews in views.subviews) {
            subViews.frame = WTCGRectMake(subViews.frame);
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
