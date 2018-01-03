//
//  GLD_CityModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface GLD_CityModel : NSObject


/** 城市 */
@property (strong, nonatomic) NSString *area_name;
/** ID */
@property (assign, nonatomic) NSInteger Id;
/** 子区域id */
@property (strong, nonatomic) NSString *parent_id;

@property (strong, nonatomic) NSString *first;//头。如： Q

@property (assign, nonatomic) CGFloat lat;//经
@property (assign, nonatomic) CGFloat lon;
@end



