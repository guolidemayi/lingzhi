//
//  GLD_IndustryModel.h
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GLD_IndustryModel

@end
@interface GLD_IndustryModel : JSONModel

@property (nonatomic, copy)NSString *iconImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy)NSString *industryId;
@end


@interface GLD_IndustryListModel : JSONModel

@property (nonatomic, strong) NSMutableArray<GLD_IndustryModel> *category;
@end
