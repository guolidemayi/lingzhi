//
//  GLD_PaoTuiCell.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLD_ExpressViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLD_PaoTuiCell : UITableViewCell

@property (nonatomic, strong) id<GLD_ExpressViewModelProtocol> viewModel;
@end

NS_ASSUME_NONNULL_END
