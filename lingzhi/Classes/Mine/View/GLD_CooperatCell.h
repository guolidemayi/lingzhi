//
//  GLD_CooperatCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

typedef NS_ENUM(NSInteger, cooperatType) {
    cooperatOne = 1,
    cooperatTwo,
    cooperatThree
    
};
typedef void(^cooperatBlock)(cooperatType type);

extern NSString *const GLD_CooperatCellIdentifier;
@interface GLD_CooperatCell : GLD_BaseCell

@property (nonatomic, copy)cooperatBlock cooperatBlock;
@property (nonatomic, strong)NSDictionary *dict;
@end
