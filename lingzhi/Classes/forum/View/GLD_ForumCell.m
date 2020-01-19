//
//  GLD_ForumCell.m
//  lingzhi
//
//  Created by rabbit on 2018/1/1.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ForumCell.h"
#import "GLD_ForumModel.h"
#import "GLD_PictureCell.h"
#import "GLD_PictureView.h"

@interface GLD_ForumCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colleHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (copy, nonatomic)  NSArray *pictures;//tu pian
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@end
@implementation GLD_ForumCell

+ (GLD_ForumCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil];
    GLD_ForumCell *cell = (GLD_ForumCell*)[topLevelObjects firstObject];
    [cell setup];
    cell.detailText.scrollEnabled = NO;
    return cell;
}

- (void)setDetailModel:(GLD_ForumDetailModel *)detailModel{
    _detailModel = detailModel;
    
    self.titleLabel.text = detailModel.title;
    self.nameLabel.text = detailModel.userName;
    self.timeLabel.text = detailModel.time;
    [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:detailModel.userPhone] placeholder:WTImage(@"默认头像")];
    self.detailText.text = detailModel.summary;
//    self.contentHeight.constant = [YXUniversal calculateCellHeight:0 width:300 text:detailModel.summary font:12] + 40;
    if (detailModel.pic.length > 10) 
    self.pictures = [detailModel.pic componentsSeparatedByString:@","];
    if (self.pictures.count > 3) {
        self.colleHeight.constant = W(200);
    }else if (self.pictures.count > 0) {
        self.colleHeight.constant = W(100);
    }else{
        self.colleHeight.constant = W(1);
    }
}
- (NSArray *)pictures{
    if(_pictures == nil){
        _pictures = [NSArray array];
    }
    return _pictures;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLD_PictureView * broser = [[GLD_PictureView alloc]initWithImageArray:self.pictures currentIndex:indexPath.row];
    
    [broser show];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

        return self.pictures.count ;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
        GLD_PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_PictureCell" forIndexPath:indexPath];
    [cell.picImageV yy_setImageWithURL:self.pictures[indexPath.row] placeholder:nil];
    cell.deleteBut.hidden = YES;
       
        return cell;
}

- (void)setup{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(W(105), W(105));
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    
    
    self.collectView.backgroundColor = [UIColor whiteColor];
    self.collectView.alwaysBounceVertical = YES;
    
    self.collectView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
   
    self.collectView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.collectView.scrollEnabled = NO;
    [self.collectView registerClass:[GLD_PictureCell class] forCellWithReuseIdentifier:@"GLD_PictureCell"];
}
@end
