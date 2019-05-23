//
//  GLD_CityListController.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"
#import "GLD_CityModel.h"

typedef void(^cityListBlock)(GLD_CityModel *placemar);
@protocol GLD_CityListViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id;

@end


@interface GLD_CityListController : GLD_BaseViewController



/** 代理 */
@property (weak, nonatomic) id<GLD_CityListViewControllerDelegate> delegate;

@property (nonatomic, copy)cityListBlock cityListBlock;
@property (nonatomic, strong)NSString *locationCity;

@end
