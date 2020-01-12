//
//  GLD_ForumCell.h
//  lingzhi
//
//  Created by rabbit on 2018/1/1.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

@class GLD_ForumDetailModel;
@interface GLD_ForumCell : GLD_BaseCell
+ (GLD_ForumCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, strong)GLD_ForumDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
