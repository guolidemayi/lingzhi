//
//  GLD_InvitMemberController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/25.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_InvitMemberController.h"

#define GLD_CollectionCellIndent @"GLD_CollectionCellIndent"

@interface GLD_CollectionCell : UICollectionViewCell


@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, strong)UILabel *name;
@end

@implementation GLD_CollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layout];
    }
    return self;
}
- (void)setupUI{
    self.name = [UILabel creatLableWithText:@"xxx" andFont:WTFont(15) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
    [self.contentView addSubview:self.name];
    
    self.imgV = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.imgV];
}
- (void)layout{
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.left.equalTo(self.contentView).offset(W(10));
        make.right.equalTo(self.contentView).offset(W(-10));
        make.bottom.equalTo(self.name.mas_top);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.right.left.equalTo(self.contentView);
        make.height.height.equalTo(HEIGHT(25));
    }];
}
@end


@interface GLD_InvitMemberController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

@implementation GLD_InvitMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐会员收入";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return 5;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self getIndustryCollecCell:indexPath];
}
- (GLD_CollectionCell *)getIndustryCollecCell:(NSIndexPath *)indexPath{
    GLD_CollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GLD_CollectionCellIndent forIndexPath:indexPath];
    return cell;
}
- (void)getOrderList{
    WS(weakSelf);
    NSInteger offset = self.dataArr.count;
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/order/getShopOrderList";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"limit" : @"10",
                                 @"offset" : [NSString stringWithFormat:@"%zd",offset]
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
//            GLD_OrderModelListModel *orderListModel = [[GLD_OrderModelListModel alloc] initWithDictionary:result error:nil];
//            if (orderListModel.data.count == 0 && !IsExist_Array(weakSelf.dataArr)) {
//                weakSelf.noDataLabel.text = @"暂无订单消息";
//                weakSelf.noDataLabel.hidden = NO;
//                [weakSelf.view bringSubviewToFront:weakSelf.noDataLabel];
//            }else{
//                weakSelf.noDataLabel.hidden = YES;
//            }
//            [weakSelf.dataArr addObjectsFromArray:orderListModel.data];
//
            
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
       
    }];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //展示产品
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //不知道为什么 cell 比collectionView大  就不会调用
        //        flowLayout.itemSize = self.listCollection.bounds.size;
        flowLayout.itemSize = CGSizeMake(W(150), W(175));
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(W(10), W(15), 0.1, W(15));
//        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-10, -10, 10, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLD_CollectionCell class] forCellWithReuseIdentifier:GLD_CollectionCellIndent];
        
        
    }
    return _collectionView;
}
@end
