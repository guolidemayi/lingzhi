//
//  GLD_SearchResultCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/7.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"
extern NSString *const GLD_SearchResultCellIdentifier;
@interface GLD_SearchResultCell : GLD_BaseCell

@property (nonatomic, strong)MKMapItem *item;
@end
