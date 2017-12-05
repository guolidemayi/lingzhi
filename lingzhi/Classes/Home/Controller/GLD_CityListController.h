//
//  GLD_CityListController.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"
#import "GLD_CityModel.h"

@protocol GLD_CityListViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id;

@end


@interface GLD_CityListController : GLD_BaseViewController
/** 城市model */
@property (strong, nonatomic) GLD_CityMainModel *cityModel;


/** 代理 */
@property (weak, nonatomic) id<GLD_CityListViewControllerDelegate> delegate;



@end
