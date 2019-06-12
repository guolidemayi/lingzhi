//
//  GLD_ShareAppCell.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/18.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GLD_ShareAppModel;
@interface GLD_ShareAppCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) GLD_ShareAppModel *model;
@end

NS_ASSUME_NONNULL_END
