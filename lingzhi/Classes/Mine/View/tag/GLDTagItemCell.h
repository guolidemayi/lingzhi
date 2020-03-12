//
//  GLDTagItemCell.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/25.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDTagItemCell : UICollectionViewCell

- (UILabel *)tagLabel;
- (void)hasSelect:(BOOL)isYes;
- (void)hasBorder:(BOOL)isYes;
@end

NS_ASSUME_NONNULL_END
