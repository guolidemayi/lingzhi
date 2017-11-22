//
//  MTShareView.m
//  MingTieApp
//
//  Created by felix liang on 12/23/15.
//  Copyright © 2015 SDY. All rights reserved.
//

#import "MTShareView.h"

#define KBUTTONWIDTH 57
#define KBUTTONHEIGHT 48
#define KLABELWIDTH 63
#define KLABELHEIGHT 21

#define KBUTTONORIGINY 27
#define KLABELORIGINY 78

@interface MTShareView ()<ShareModuleDelegate>

@end

@implementation MTShareView

- (void)awakeFromNib
{
    [self setValuesFont];
    [self setCornerRadius];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewAction:)];
    [_shareBGView addGestureRecognizer:gesture1];
    
    [self outLayoutSelfSubviews];
    self.share_bg.frame = CGRectMake(0, DEVICE_HEIGHT - 190, DEVICE_WIDTH, 190);
//    self.shareView2.frame = CGRectMake(0, DEVICE_HEIGHT - 190, DEVICE_WIDTH, 190);
    
    
    self.label_title.frame = CGRectMake(0, 20, DEVICE_WIDTH, 20);
    self.button_wechat.frame = CGRectMake(0, 50, W(60), H(60));
    self.button_wechat.center = CGPointMake(DEVICE_WIDTH/2 - 75, self.button_wechat.center.y);
    self.button_wechat_friend.frame = CGRectMake(0, 50, W(60), H(60));
    self.button_wechat_friend.center = CGPointMake(DEVICE_WIDTH/2 + 75, self.button_wechat_friend.center.y);
    
    self.weixin_title.frame = CGRectMake(0, 120, 60, 20);
    self.weixin_title.center = CGPointMake(self.button_wechat.center.x, self.weixin_title.center.y);
    
    self.pengyouquan_title.frame = CGRectMake(0, 120, 60, 20);
    self.pengyouquan_title.center = CGPointMake(self.button_wechat_friend.center.x, self.pengyouquan_title.center.y);
    
    self.quxiao_button.frame = CGRectMake(0, 150, 70, 25);
    self.quxiao_button.center = CGPointMake(DEVICE_WIDTH/2, self.quxiao_button.center.y);
    
    [self.quxiao_button setBackgroundImage:[UIImage imageNamed:@"icon_dianjiqian"] forState:UIControlStateNormal];
    [self.quxiao_button setTitle:@"取消" forState:UIControlStateNormal];
    
    self.shareView1.hidden = YES;
    [super awakeFromNib];
}

- (void)setValuesTextColor
{
    _label_wechat.textColor =
    _label_wechat_friend.textColor =
    [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXT];
    
    _label_title.textColor = [UIColor whiteColor];
}

- (void)setValuesFont
{
    _button_Cancel.titleLabel.font = WTFont(16.0);
    _label_qqShare.font = WTFont(12.0);
    _label_Sina.font = WTFont(12.0);
    _label_SMS.font = WTFont(12.0);
    _label_wechat.font = WTFont(12.0);
    _label_wechat_friend.font = WTFont(12.0);
}

- (void)setCornerRadius
{
    
//    CGRect frame = self.button_wechat.frame;
//    frame.size = CGSizeMake(W(60), H(60));
//    self.button_wechat.frame = frame;
    _shareView1.layer.cornerRadius = 5.0;
    _shareView2.layer.cornerRadius = 5.0;
}
- (void)setLabelTitleSring:(NSString *)string {
    
    self.label_title.text = string;
    
    
}

- (void)setShareViewWithType:(ShareViewType)type shareText:(NSString *)tagStr shareUrl:(NSString *)tagUrl withDelegate:(UIViewController *)delegate shareDetail:(NSString *)detail shareImage:(NSString *)image
{
    [MTShareModule getInstance].str_shareText = tagStr;
    [MTShareModule getInstance].str_shareUrl = tagUrl;
    [MTShareModule getInstance].str_shareDetailText = detail;
    [MTShareModule getInstance].str_shareImage = image;
    [MTShareModule getInstance].wxMedia = 0;
    self.showDelegate = delegate;
    //[self setShareButtonsEnable];
    
}

- (void)setImageShareViewWithType:(ShareViewType)type image:(UIImage *)image shareUrl:(NSString *)url originalImage:(NSData *)originalImage withDelegate:(UIViewController *)delegate
{
    [MTShareModule getInstance].url = url;
    [MTShareModule getInstance].img = image;
    [MTShareModule getInstance].originalImage = originalImage;
    [MTShareModule getInstance].wxMedia = 1;
    self.showDelegate = delegate;
    //[self setShareButtonsEnable];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self removeFromSuperview];
}

- (void)shareViewAction:(UITapGestureRecognizer *)gesture
{
    [self cancelBtnClick:nil];
}

#pragma mark - 分享
- (void)setShareButtonsEnable
{
    if([MTShareModule getWechatAppIsInstalled] == NO)//未安装微信
    {
        self.button_wechat.enabled = NO;
    }
    if ([MTShareModule getQQAppIsInstalled] == NO) {
        self.button_qqShare.enabled = NO;
    }
}


- (IBAction)weChatFriendBtnClick:(id)sender
{
    [[MTShareModule getInstance] shareFriendCircle];
    [MTShareModule getInstance].authRespDelegate = self;
}
- (IBAction)weChatBtnClick:(id)sender {
    [[MTShareModule getInstance] shareWeChat];
    [MTShareModule getInstance].authRespDelegate = self;
}

- (void)wechatSuccess {
    [self removeFromSuperview];
    [self.delegate shareSuccess];
}


- (IBAction)qqShareBtnClick:(id)sender {
    [[MTShareModule getInstance] shareQQ];
}
- (IBAction)smsShareBtnClick:(id)sender {
    [[MTShareModule getInstance] shareSMS];
}
- (IBAction)sinaShareBtnClick:(id)sender {
    [[MTShareModule getInstance] shareSina];
}

- (void)outLayoutSelfSubviews
{
    for (UIView *views in self.subviews) {
        
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

@end
