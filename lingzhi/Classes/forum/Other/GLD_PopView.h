//
//  GLD_PopView.h
//  yxvzb
//
//  Created by yiyangkeji on 17/1/17.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GLD_OperationType) {
    GLD_OperationTypeReply = 0,
    GLD_OperationTypeCopy = 1,
    GLD_OperationTypeDelete = 2,
    GLD_OperationTypeJuBao = 3,
    GLD_OperationTypeTheme = 4,
};

typedef void(^DidSelectedOperationBlock)(GLD_OperationType operationType);
@interface GLD_PopView : UIView
@property (nonatomic, assign) BOOL shouldShowed;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, copy) DidSelectedOperationBlock didSelectedOperationCompletion;

+ (instancetype)initailzerWFOperationView;

- (void)showAtView:(UIView *)containerView rect:(CGRect)targetRect isFavour:(BOOL)isFavour;

- (void)dismiss;

@end
