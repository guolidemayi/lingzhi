//
//  GLD_ShareAppModel.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/18.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol GLD_ShareAppModel

@end
@interface GLD_ShareAppModel : JSONModel

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *logo;
@end


@interface GLD_ShareAppListModel : JSONModel


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray<GLD_ShareAppModel> *apps;

@end
NS_ASSUME_NONNULL_END
