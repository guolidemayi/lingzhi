//
//  GLD_CityModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol GLD_CityModel

@end
@interface GLD_CityModel : NSObject


/** 城市 */
@property (strong, nonatomic) NSString *name;
/** ID */
@property (assign, nonatomic) NSInteger Id;

/** 是否被选中 */
@property (assign, nonatomic, getter=isSelected) BOOL selected;




@end
@protocol GLD_CityListModel

@end
@interface GLD_CityListModel : JSONModel

/** 城市数组 */
@property (strong, nonatomic) NSArray<GLD_CityModel> *citys;

/** 首字母 */
@property (strong, nonatomic) NSString *initial;



@end
@interface GLD_CityMainModel : JSONModel

/** 城市列表 */
@property (strong, nonatomic) NSArray<GLD_CityListModel> *list;

/** 选中城市 */
@property (strong, nonatomic) NSString *selectedCity;

/** 选中城市ID */
@property (assign, nonatomic) NSInteger selectedCityId;

/** 高度 */
@property (assign, nonatomic) CGFloat hotCellH;
@end



