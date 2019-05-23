//
//  GLD_IndustryCollecCell.h
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_IndustryModel;
extern NSString *const GLD_IndustryCollecCellIdentifier;

@interface GLD_IndustryCollecCell : UICollectionViewCell

@property (nonatomic, strong) GLD_IndustryModel *model;
@end
