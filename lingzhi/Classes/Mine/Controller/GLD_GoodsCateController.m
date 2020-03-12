//
//  GLD_GoodsCateController.m
//  lingzhi
//
//  Created by 博学明辨 on 2020/3/12.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsCateController.h"
#import "GLDTagViewModel.h"
#import "GLDTagItemCell.h"
#import "GLD_PersonalTagFlowLayout.h"
#import "GLDTagModel.h"
#import "HLCreatThemeView.h"

@interface GLD_GoodsCateController ()<UICollectionViewDataSource, UICollectionViewDelegate,HLCreatThemeViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation GLD_GoodsCateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self getOrderList];
}
- (void)getOrderList{
    WS(weakSelf);
    [weakSelf.dataArr removeAllObjects];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = shopCateList;
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            NSArray *arr = result[@"data"];
            
            for (NSDictionary *dic in arr) {
                GLDTagModel *model = [[GLDTagModel alloc]initWithDictionary:dic error:&error];
                
                GLDTagViewModel *viewModel = [[GLDTagViewModel alloc]initWithObject:model];
                [weakSelf.dataArr addObject:viewModel];
                
            }
            [weakSelf.collectionView reloadData];
            
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
       
    }];
}
- (void)changeCatemodel{
    GLDTagViewModel *viewModel = self.dataArr[self.selectIndex];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
       config.requestType = gld_networkRequestTypePOST;
       config.urlPath = ShopDeleteCate;
       config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                    @"id":GetString(viewModel.tagId),
                                    };
       
       [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
           if (!error) {
            [self getOrderList];
               [CAToast showWithText:@"删除成功"];
           }else{
               [CAToast showWithText:@"请求失败，请重试"];
           }
          
       }];
}
- (void)addCate:(NSString *)name{
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
       config.requestType = gld_networkRequestTypePOST;
       config.urlPath = ShopAddCate;
       config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                    @"name":GetString(name)
                                    };
       
       [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
           if (!error) {
               [self getOrderList];
              [CAToast showWithText:@"添加成功"];
               
           }else{
               [CAToast showWithText:@"请求失败，请重试"];
           }
          
       }];
}
- (void)didSelectTheme:(NSString *)themeName{
    if (self.dataArr.count <= self.selectIndex) {
        //新增
        [self addCate:themeName];
    }else{
        //删除
        [self versonUpdate];
        
    }
}
- (void)versonUpdate{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除此分类" message:@"" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        [self changeCatemodel];
       
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
   
    self.selectIndex = indexPath.row;
    if (self.dataArr.count <= indexPath.row) {
        [self showAddThemeView:@""];
    }else{
       [self versonUpdate];
    }
  
}
- (void)showAddThemeView:(NSString *)tehme{
    HLCreatThemeView *view = [[HLCreatThemeView alloc]initWithFrame:KEYWINDOW.bounds addDefaultTheme:tehme];
    [KEYWINDOW addSubview:view];
    view.delegate = self;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArr.count == indexPath.row) return CGSizeMake(W(100), W(35));
    GLDTagViewModel *viewModel = self.dataArr[indexPath.row];
    return CGSizeMake(viewModel.itemWidth, W(35));
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLDTagItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLDTagItemCell" forIndexPath:indexPath];
    if (self.dataArr.count <= indexPath.row) {
        [cell hasBorder:YES];
        cell.tagLabel.text = @"+ 新增分类";
        
        cell.tagLabel.backgroundColor = [UIColor whiteColor];
    }else{
        
        GLDTagViewModel *viewModel = self.dataArr[indexPath.row];
        
        [cell hasBorder:NO];
        cell.tagLabel.text = viewModel.nameStr;
       cell.tagLabel.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_tableViewBgColor];
    }
    return cell;
}

- (UICollectionView *)collectionView {
   if (!_collectionView) {
        GLD_PersonalTagFlowLayout *flowLayout = [[GLD_PersonalTagFlowLayout alloc] initWithType:AlignWithLeft betweenOfCell:W(20)];
//        flowLayout.minimumInteritemSpacing = W(20);
       _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
       _collectionView.backgroundColor = [UIColor whiteColor];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
       [_collectionView registerClass:[GLDTagItemCell class] forCellWithReuseIdentifier:@"GLDTagItemCell"];
   }
   return _collectionView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
