//
//  InputKeyboardView.h
//  yxvzb
//
//  Created by wangxin on 16/4/29.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol keyboardDelegate <NSObject>

-(void)closeKeyborad:(NSString *)text;

-(void)sendKeyboard:(NSString *)text;
@optional
- (void)fenxiangImgAction;

- (void)yaoqingFriendImgAction;


@end

@interface InputKeyboardView : UIView<UITextViewDelegate>


@property (nonatomic, weak) id<keyboardDelegate> delegate;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UITextView *textField;

@property (strong, nonatomic) UIImageView *fenxiang;

@property (strong, nonatomic) UIButton *yaoqingBut;

@property (nonatomic,assign) BOOL isHideStatus;

@property (nonatomic,assign) BOOL isFrom;
-(void)showKeyboardView:(NSString *)text isHideStatus:(BOOL)isHideStatus;

@end
