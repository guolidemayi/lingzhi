//
//  GLD_ExpressListController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressListController.h"
#import "GLD_ExpressCell.h"
#import "MapNavigationManager.h"
#import "GLD_PostExpressController.h"
#import "SDCycleScrollView.h"
#import "GLD_BannerModel.h"
#import "GLD_BannerDetailController.h"
#import "GLD_SendView.h"
#import "GLD_ExpressViewModel.h"
#import "GLD_NewPostExressController.h"
#import "GLD_PaoTuiCell.h"
#import "GLD_BangBanCell.h"
@interface GLD_ExpressListController ()<UITableViewDelegate,UITableViewDataSource,GLD_ExpressCellDelegate,SDCycleScrollViewDelegate,UIScrollViewDelegate>{
    NSInteger offset;
    NSInteger pagNo;
    UIView  *_remindView;
    UIView  *_commentView;
}
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, weak)UIImageView *bgImageV;
@property (nonatomic, weak)UIImageView *changeImgV;
@property (nonatomic, weak)UIButton *lastBut;
@property (nonatomic, weak)UIButton *MyBut;
@property (nonatomic, weak)UIImageView *redPoint;
@property (nonatomic, strong)UIScrollView *bottomScrollView;
@property (nonatomic, weak)UITableView *remindTable;
@property (nonatomic, weak)UITableView *commentTable;
@property (nonatomic, strong)NSMutableArray *remindArrM;
@property (nonatomic, strong)NSMutableArray *commentArrM;
@property (nonatomic, assign) NSInteger type;//0快递 1 我的抢单 2 跑腿 3代买 4帮办
@property (nonatomic, strong)SDCycleScrollView *cycleView;
@property (nonatomic, strong)GLD_BannerLisModel *bannerListModel;
@property (nonatomic, strong) GLD_SendView *sendView;
@property (nonatomic, strong) NSString *showTitle;
@end

@implementation GLD_ExpressListController

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _remindArrM = [NSMutableArray array];
    _commentArrM = [NSMutableArray array];
    offset = 0;
    pagNo = 0;
   
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    [self setupTopView];
    [self layoutTopView];
    [self setContentView];
//    [self getCommentMessageContent];
   
    [self getBannerData];
    [self setUpNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self getRemindMessageContent];
}
- (void)setUpNav
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    if (self.type == 0) {
        
        self.navigationItem.leftBarButtonItem = backItem;
        UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(sendExpress)];
        self.navigationItem.rightBarButtonItem = sendItem;
    }
}
- (void)pop
{
    if(self.type == 0){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)sendExpress{
    GLD_NewPostExressController *postVc = [GLD_NewPostExressController new];
    [self.navigationController pushViewController:postVc animated:YES];
}
- (void)getRemindMessageContent{
    WS(weakSelf);
    [self.remindArrM removeAllObjects];
    [self getDataRequest:@{@"city":IsExist_String([AppDelegate shareDelegate].placemark.area_name)? [AppDelegate shareDelegate].placemark.area_name :@"北京",
                           @"lat":@([AppDelegate shareDelegate].placemark.lat),
                           @"lng":@([AppDelegate shareDelegate].placemark.lon),
                           @"type":@(self.type)
                           } andComplentBlock:^(id result) {
        GLD_ExpressListModel *listModel = [[GLD_ExpressListModel alloc]initWithDictionary:result error:nil];
        
                              
                               
        if (listModel.data.count > 0) {
            [weakSelf.remindArrM addObjectsFromArray: [listModel.data.rac_sequence map:^id _Nullable(GLD_ExpressModel  *_Nullable value) {
                return [[GLD_ExpressViewModel alloc]initWithModel:value];
            }].array];
            [weakSelf.remindTable.mj_footer endRefreshing];
        }else{
            [weakSelf.remindTable.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.remindTable.mj_header endRefreshing];
        [weakSelf.remindTable reloadData];
    }];
    
}
- (void)getCommentMessageContent{
    WS(weakSelf);
    [self.commentArrM removeAllObjects];
    [self getDataRequest:@{@"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                           @"type":@(1),
                           @"city":IsExist_String([AppDelegate shareDelegate].placemark.area_name)? [AppDelegate shareDelegate].placemark.area_name :@"北京",
                           } andComplentBlock:^(id result) {
        GLD_ExpressListModel *listModel = [[GLD_ExpressListModel alloc]initWithDictionary:result error:nil];
        
        if (listModel.data.count > 0) {
            [weakSelf.commentArrM addObjectsFromArray:listModel.data];
            [weakSelf.commentTable.mj_footer endRefreshing];
        }else{
            [weakSelf.commentTable.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.commentTable.mj_header endRefreshing];
        [weakSelf.commentTable reloadData];
    }];
    
   
}

- (void)getDataRequest:(NSDictionary *)parame andComplentBlock:(void(^)(id result))complentBlock{
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = expressRequest;
    config.requestParameters = parame;
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            complentBlock(result);
        });
        
    }];
}


- (void)getBannerData{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/banner";
    config.requestParameters = @{@"type":@"4"};
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.bannerListModel = [[GLD_BannerLisModel alloc] initWithDictionary:result error:nil];
        NSMutableArray *arrM = [NSMutableArray array];
        for (GLD_BannerModel *model in weakSelf.bannerListModel.data) {
            [arrM addObject:GetString(model.Pic)];
        }
        if (arrM.count > 0) {
            weakSelf.cycleView.imageURLStringsGroup = arrM.copy;
        }
        [weakSelf.remindTable reloadData];
    }];
}
#pragma GLD_ExpressCellDelegate
- (void)robExpress:(GLD_ExpressModel *)model andType:(robType)type{
    switch (type) {
        case robTypeMyExpress:{
//            CLLocationCoordinate2D coordinate;
//            coordinate.latitude = model.latitude;
//            coordinate.longitude = model.longitude;
//            [MapNavigationManager showSheetWithCoordinate2D:coordinate];
        }break;
        case robTypeGetExpress:{
            model.state = 1;
            [self toRobExpressRequest:model];
        }break;
        case robTypeHasRob:{
            //完成
            model.state = 2;
        }break;
    }
}

- (void)toRobExpressRequest:(GLD_ExpressModel *)model{
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = robExpressRequest;
    config.requestParameters = @{@"id":GetString(model.expressId),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"status":@(model.state)
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:@"请求成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
    }];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section > 0 || [tableView isEqual:self.commentTable]) return 0.01;
//    return W(150);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if ([tableView isEqual:self.commentTable]) return nil;
//    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
//    if (section > 0) return headView;
//    [headView addSubview:self.cycleView];
//    return headView;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.remindTable]) {
        return _remindArrM.count;
    }else{
        return _commentArrM.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([tableView isEqual:self.remindTable]) {
        
        GLD_ExpressViewModel *viewModel = self.remindArrM[indexPath.row];
        if (viewModel.expressModel.type.integerValue != 4) {
            return [self getBangBanCell:indexPath andTableView:tableView];
        }else{
            return [self getPaoTuiCell:indexPath andTableView:tableView];
        }
    }else{
        
        GLD_ExpressViewModel *viewModel = self.commentArrM[indexPath.row];
        if (viewModel.expressModel.type.integerValue == 4) {
            return [self getBangBanCell:indexPath andTableView:tableView];
        }else{
            return [self getPaoTuiCell:indexPath andTableView:tableView];
        }
    }
    
    return [UITableViewCell new];
}

- (GLD_BangBanCell *)getBangBanCell:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    GLD_BangBanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_BangBanCell"];
    if (tableView == self.remindTable) {
        
        cell.viewModel = self.remindArrM[indexPath.row];
    }else{
        cell.viewModel = self.commentArrM[indexPath.row];
    }
    return cell;
}
- (GLD_PaoTuiCell *)getPaoTuiCell:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView{
    GLD_PaoTuiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_PaoTuiCell"];
    if (tableView == self.remindTable) {
        
        cell.viewModel = self.remindArrM[indexPath.row];
    }else{
        cell.viewModel = self.commentArrM[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.remindTable) {
        GLD_ExpressViewModel *viewModel = self.remindArrM[indexPath.row];
        return viewModel.cellHeight;
    }else{
        
        GLD_ExpressViewModel *viewModel = self.commentArrM[indexPath.row];
        return viewModel.cellHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)MyButClick: (UIButton *)senser{
    
    _commentView.hidden = YES;
    self.changeImgV.image = [UIImage imageNamed:@"右tab"];
    [_MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    [_lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        
        self.changeImgV.frame = self.MyBut.frame;
    }];
    [self.bottomScrollView bringSubviewToFront:self.commentTable];
    if (!IsExist_Array(self.commentArrM))
    [self getCommentMessageContent];
}

- (void)lastButClick: (UIButton *)senser{
    
    _remindView.hidden = YES;
    
    self.changeImgV.image = [UIImage imageNamed:@"左tab"];
    [_MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [_lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.changeImgV.frame = self.lastBut.frame;
    }];
    [self.bottomScrollView bringSubviewToFront:self.remindTable];
}


- (void)setupTopView{
    
    [self.bottomScrollView addSubview:self.cycleView];
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    self.bgImageV = bgImageV;
    //    bgImageV.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    bgImageV.userInteractionEnabled = YES;
    bgImageV.image = [UIImage imageNamed:@"Shape"];
    //    bgImageV.layer.cornerRadius = 3;
    bgImageV.layer.masksToBounds = YES;
    
    UIImageView *changeImgV = [[UIImageView alloc]init];
    self.changeImgV = changeImgV;
    changeImgV.image = [UIImage imageNamed:@"左tab"];
    
    UIButton *lastBut = [[UIButton alloc]init];
    self.lastBut = lastBut;
    lastBut.titleLabel.font = WTFont(17);
    [lastBut setTitle:[NSString stringWithFormat:@"%@列表",self.showTitle] forState:UIControlStateNormal];
    [lastBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
    [lastBut addTarget:self action:@selector(lastButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *MyBut = [[UIButton alloc]init];
    self.MyBut = MyBut;
    MyBut.titleLabel.font = WTFont(17);
    [MyBut setTitle:@"我的接单" forState:UIControlStateNormal];
    [MyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [MyBut addTarget:self action:@selector(MyButClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.bottomScrollView addSubview:topView];
    self.sendView = [GLD_SendView instanceSendView];
    
    [self.bottomScrollView addSubview:self.sendView];
    
    [topView addSubview:bgImageV];
    [bgImageV addSubview:changeImgV];
    [bgImageV addSubview:lastBut];
    [bgImageV addSubview:MyBut];
}

- (void)setContentView{

    UITableView *remindT = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    remindT.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [remindT registerNib:[UINib nibWithNibName:@"GLD_ExpressCell" bundle:nil] forCellReuseIdentifier:@"GLD_ExpressCell"];
    
    [remindT registerNib:[UINib nibWithNibName:@"GLD_BangBanCell" bundle:nil] forCellReuseIdentifier:@"GLD_BangBanCell"];
    
    [remindT registerNib:[UINib nibWithNibName:@"GLD_PaoTuiCell" bundle:nil] forCellReuseIdentifier:@"GLD_PaoTuiCell"];
    remindT.delegate = self;
    remindT.dataSource = self;
    remindT.gestureChoiceHandler = ^BOOL(id _, id __) { return YES; };
    WS(weakSelf);
    remindT.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        offset = 0;
        [weakSelf.remindArrM removeAllObjects];
        [weakSelf getRemindMessageContent];
    }];
    remindT.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        [weakSelf getRemindMessageContent];
    }];
    self.remindTable = remindT;
    
    UITableView *commentT = [[UITableView alloc]init];
    
    commentT.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentT.delegate = self;
    commentT.dataSource = self;
    commentT.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.commentArrM removeAllObjects];
        [weakSelf getCommentMessageContent];
    }];
    commentT.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        [weakSelf getCommentMessageContent];
    }];
     [commentT registerNib:[UINib nibWithNibName:@"GLD_ExpressCell" bundle:nil] forCellReuseIdentifier:@"GLD_ExpressCell"];
    
    [commentT registerNib:[UINib nibWithNibName:@"GLD_BangBanCell" bundle:nil] forCellReuseIdentifier:@"GLD_BangBanCell"];
    
    [commentT registerNib:[UINib nibWithNibName:@"GLD_PaoTuiCell" bundle:nil] forCellReuseIdentifier:@"GLD_PaoTuiCell"];
    self.commentTable = commentT;
    
    [self.bottomScrollView addSubview:commentT];
    [self.bottomScrollView addSubview:remindT];
    
    [remindT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.topView);
        make.bottom.equalTo(self.bottomScrollView);
        make.height.equalTo(@(DEVICE_HEIGHT));
        make.width.equalTo(@(DEVICE_WIDTH));
    }];
    [commentT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(remindT);
    }];
    
}

- (void)layoutTopView{
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.bottomScrollView);
        make.top.equalTo(self.bottomScrollView);
        make.width.equalTo(@(DEVICE_WIDTH));
        make.height.equalTo(HEIGHT(150));
    }];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.bottomScrollView);
        make.width.equalTo(@(DEVICE_WIDTH));
        make.top.equalTo(self.sendView.mas_bottom);
        make.height.equalTo(WIDTH(54));
    }];
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.topView).offset(5);
        make.width.equalTo(WIDTH(240));
        make.height.equalTo(HEIGHT(30));
        
    }];
    [self.changeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.bgImageV);
    }];
    [self.lastBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.bgImageV);
    }];
    [self.MyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageV);
        make.width.equalTo(WIDTH(120));
        make.height.equalTo(HEIGHT(30));
        make.left.equalTo(self.lastBut.mas_right);
    }];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.MyBut.mas_top);
        make.centerX.equalTo(self.MyBut.mas_right);
        make.width.height.equalTo(@10);
    }];
    CGFloat height = 0;
    if(self.type == 0){
        height = 200;
        self.sendView.hidden = NO;
    }else{
        self.sendView.hidden = YES;
    }
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom);
        make.height.equalTo(@(height));
        make.right.left.equalTo(self.cycleView);
    }];
    
}
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero
                                                        delegate:self
                                                placeholderImage:[UIImage imageNamed:@"tabbar_icon0_normal"]];
        
        
        _cycleView.autoScrollTimeInterval = 3;// 自动滚动时间间隔
        _cycleView.autoScroll = YES;
        _cycleView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(150));
        //        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
    }
    return _cycleView;
}
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
//        scroll.bounces = NO;
        scroll.delegate = self;
        _bottomScrollView = scroll;
        self.view = scroll;
        _bottomScrollView.gestureChoiceHandler = ^BOOL(id _, id __) { return YES; };
        _bottomScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomScrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bottomScrollView) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            scrollView.scrollEnabled = NO;
        }
    }else{
        if (scrollView.contentOffset.y >= 0) {
            self.bottomScrollView.scrollEnabled = YES;
        }
    }
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"%zd", index);
    GLD_BannerDetailController *bannerVc =[GLD_BannerDetailController new];
    bannerVc.bannerModel = self.bannerListModel.data[index];
    [self.navigationController pushViewController:bannerVc animated:YES];
}
- (void)setType:(NSInteger)type{//0快递 1 我的抢单 2 跑腿 3代买 4帮办
    _type = type;
    switch (type) {
        case 0:
        {
            self.showTitle = @"服务";
        }
            break;
        case 2:
        {
            self.showTitle = @"跑腿";
        }
            break;
        case 3:
        {
            self.showTitle = @"代买";
        }
            break;
        case 4:
        {
            self.showTitle = @"帮办";
        }
            break;
    }
    self.title = self.showTitle;
}
@end
