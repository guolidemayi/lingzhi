//
//  GLD_CashCountCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/13.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_CashCountCell.h"
#import "BRTextField.h"
#import "NSDate+BRAdd.h"

@interface GLD_CashCollectCell : UICollectionViewCell <UITextFieldDelegate>

/** 钱数 */
@property (nonatomic, strong) BRTextField *nameTF;
@end
@implementation GLD_CashCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupNameTF:self];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GLD_CashCollectCellCLick:) name:@"GLD_CashCollectCellNoti" object:nil];
    }
    return self;
}
- (void)GLD_CashCollectCellCLick:(NSNotification *)noti{
//    GLD_CashCollectCell *cell = noti.object;
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
}
- (BRTextField *)getTextField:(UICollectionViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - W(230), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeDefault;
    [cell.contentView addSubview:textField];
    return textField;
}

#pragma mark - 门店名称
- (void)setupNameTF:(UICollectionViewCell *)cell{
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
//        _nameTF.placeholder = @"请输入";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GLD_CashCollectCellNoti" object:self];
    self.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTF resignFirstResponder];
    
    return YES;
}
@end

NSString *const GLD_CashCountCellIdentifier = @"GLD_CashCountCellIdentifier";
@interface GLD_CashCountCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, weak)GLD_CashCollectCell *cashCell;
@end
@implementation GLD_CashCountCell

- (void)setupUI{
    [self.contentView addSubview:self.collectionView];
    
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getCashCountCell:indexPath];
}


- (NSString *)moneyStr{
    if (IsExist_String(self.cashCell.nameTF.text)) {
        _moneyStr = self.cashCell.nameTF.text;
    }
    return _moneyStr;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GLD_CashCollectCell *cell = (GLD_CashCollectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.moneyStr = self.titleArr[indexPath.row];
    cell.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;
    self.cashCell.layer.borderColor = [UIColor clearColor].CGColor;
    self.cashCell.nameTF.text = @"";
    [self.cashCell.nameTF resignFirstResponder];
}
- (GLD_CashCollectCell *)getCashCountCell:(NSIndexPath *)indexPath{
    GLD_CashCollectCell *cell = (GLD_CashCollectCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_CashCollectCell" forIndexPath:indexPath];
//    GLD_CashCollectCell *cell = [[GLD_CashCollectCell alloc]initWithFrame:CGRectZero];
    NSString *str = self.titleArr[indexPath.item];
    if (IsExist_String(str)) {
        cell.nameTF.placeholder = str;
        cell.nameTF.userInteractionEnabled = NO;
    }else{
        self.cashCell = cell;
        cell.nameTF.placeholder = @"自定义钱数";
        cell.nameTF.userInteractionEnabled = YES;
    }
    return cell;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //展示产品
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //不知道为什么 cell 比collectionView大  就不会调用
        //        flowLayout.itemSize = self.listCollection.bounds.size;
        flowLayout.itemSize = CGSizeMake(W(90), W(30));
        flowLayout.minimumInteritemSpacing = W(10);
        //        flowLayout.minimumLineSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(W(10), W(30), W(10), W(30));
        //        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, -10, 10, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLD_CashCollectCell class] forCellWithReuseIdentifier:@"GLD_CashCollectCell"];
        
        
    }
    return _collectionView;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"2000",@"3000",@"5000",@"6000",@"10000",@""];
    }
    return _titleArr;
}
@end
