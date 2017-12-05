//
//  GLD_IndustryModel.h
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GLD_BannerModel

@end
@interface GLD_IndustryModel : JSONModel

@property (nonatomic, copy)NSString *iconUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy)NSString *industryId;
@end


@interface GLD_IndustryListModel : JSONModel

@property (nonatomic, strong) NSMutableArray<GLD_BannerModel> *data;
@end
