//
//  GLD_CommentBottomView.h
//  yxvzb
//
//  Created by yiyangkeji on 17/1/16.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLD_CommentBottomViewDelegate <NSObject>

//语音代理
- (void)record;
//输入框
- (void)content;
//收藏
- (void)collection: (UIButton *)but;
//分享
- (void)share;
//认证
- (void)toAuth;
@end

@interface GLD_CommentBottomView : UIView

//默认显示内容  默认“说些什么”
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong)NSString *bottomContent;
@property (nonatomic, strong)UITextField *textFeild;;
@property (nonatomic, strong)UIButton *collectionBut;
@property (nonatomic, assign)NSInteger count;
@property (nonatomic, weak)id<GLD_CommentBottomViewDelegate> delegate;

- (void)countLabelCorlor:(BOOL)isCollection;
//根据是否认证显示不同状态  status: 1 讲师。2 认证。3未认证
- (void)showAuthOrOthersStates:(NSInteger)status;

@end
