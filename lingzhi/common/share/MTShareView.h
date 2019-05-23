//
//  MTShareView.h
//  MingTieApp
//
//  Created by felix liang on 12/23/15.
//  Copyright © 2015 SDY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ShareViewType)
{
    KShareViewTypePerson,
    KShareViewTypeAll,
};


@protocol MTShareViewDelegate <NSObject>

- (void)shareSuccess;

@end

@interface MTShareView : UIView

@property (weak, nonatomic) id<MTShareViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *button_wechat_friend;

@property (weak, nonatomic) IBOutlet UIButton *button_wechat;

@property (weak, nonatomic) IBOutlet UIButton *button_qqShare;

@property (weak, nonatomic) IBOutlet UIButton *button_SMS;

@property (weak, nonatomic) IBOutlet UIButton *button_Sina;

@property (weak, nonatomic) IBOutlet UILabel *label_wechat_friend;

@property (weak, nonatomic) IBOutlet UILabel *label_wechat;

@property (weak, nonatomic) IBOutlet UILabel *label_qqShare;

@property (weak, nonatomic) IBOutlet UILabel *label_SMS;

@property (weak, nonatomic) IBOutlet UILabel *label_Sina;

@property (weak, nonatomic) IBOutlet UILabel *label_title;

@property (weak, nonatomic) IBOutlet UIButton *button_Cancel;

@property (weak, nonatomic) IBOutlet UIView *shareBGView;

@property (weak, nonatomic) IBOutlet UIView *share_bg;

@property (weak, nonatomic) IBOutlet UIView *shareView1;

@property (weak, nonatomic) IBOutlet UIView *shareView2;

@property (weak, nonatomic) IBOutlet UILabel *weixin_title;

@property (weak, nonatomic) IBOutlet UILabel *pengyouquan_title;

@property (weak, nonatomic) IBOutlet UIButton *quxiao_button;

@property (assign, nonatomic) id showDelegate;

@property (nonatomic, assign) BOOL isImageShare;

- (void)setLabelTitleSring:(NSString *)string;

- (void)setShareViewWithType:(ShareViewType)type shareText:(NSString *)tagStr shareUrl:(NSString *)tagUrl withDelegate:(UIViewController *)delegate shareDetail:(NSString *)detail shareImage:(NSString *)image;

- (void)setImageShareViewWithType:(ShareViewType)type image:(UIImage *)image shareUrl:(NSString *)url originalImage:(NSData *)originalImage withDelegate:(UIViewController *)delegate;

@end
