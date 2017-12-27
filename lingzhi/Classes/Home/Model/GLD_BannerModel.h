//
//  GLD_BannerModel.h
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GLD_BannerModel

@end
@interface GLD_BannerModel : JSONModel


@property (nonatomic, copy)NSString *Pic;
@property (nonatomic, copy) NSString *Titles;
@property (nonatomic, copy) NSString *Pictures;
@property (nonatomic, assign)NSInteger typeTitle;
@property (nonatomic, copy)NSString *bannerID;

@end

@interface GLD_BannerLisModel : JSONModel
@property (nonatomic, strong) NSMutableArray<GLD_BannerModel> *banner;

@end

