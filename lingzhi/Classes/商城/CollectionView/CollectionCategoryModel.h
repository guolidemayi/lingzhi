//
//  CategoryModel.h
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "JSONModel.h"
#import "GLD_StoreDetailModel.h"
@interface CollectionCategoryModel : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray<GLD_StoreDetailModel> *goods;

@end

@interface SubCategoryModel : NSObject

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;

@end
