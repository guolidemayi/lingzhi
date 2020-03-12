//
//  HLCreatThemeView.h
//  HLFamily
//
//  Created by 胡红磊 on 2019/11/18.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HLCreatThemeViewDelegate <NSObject>

- (void)didSelectTheme:(NSString *)themeName;

@end

@interface HLCreatThemeView : UIView

- (instancetype)initWithFrame:(CGRect)frame addDefaultTheme:(NSString *)defaultTheme;

@property(nonatomic,weak)id<HLCreatThemeViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
