//
//  GLD_AllDetailController.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/25.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_AllDetailController.h"
#import "GLD_TMessageCell.h"

#import "GLD_TopicModel.h"
#import "GLD_ForumModel.h"
#import "GLD_BMessageCell.h"
#import "GLD_ForumDetailController.h"

@interface GLD_AllDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger pageNo;
    NSMutableArray *forumListArrM;
}

@property (nonatomic, weak)UITableView *ATableView;
@property (nonatomic, weak)UIView *topView;
@property (nonatomic, weak)UILabel *numberLabel;
@end

@implementation GLD_AllDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    forumListArrM = [NSMutableArray arrayWithCapacity:0];
   
    [self getTopView];
    [self getContentDetailRequest];
   
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //竖屏时露出状态栏
   
//    [self hideNavigationBar];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)getContentDetailRequest{
    
    if (forumListArrM.count > 0) {
        pageNo ++;
    }else{
        
        pageNo = 1;
    }
    
    WS(weakSelf)
//    GLD_ForumRequest *request = [GLD_ForumRequest shareManager];
//    [request httpPost:@"" parameters:@{@"pageNo":[NSString stringWithFormat:@"%zd",pageNo],@"categoryName":self.keywordModel.categoryName,@"categoryId":self.keywordModel.categoryId} block:^(WTBaseRequest *request, NSError *error) {
//        if (error) {
//            [weakSelf showNoDataViewOrLoadView:error];
//            [weakSelf.ATableView.mj_footer endRefreshing];
//            [weakSelf.ATableView.mj_header endRefreshing];
//        }else{
//            [weakSelf hiddenNoDataView];
//            GLD_ForumModel *model = request.resultArray.firstObject;
//            if (!IsExist_Array(forumListArrM))
//            _numberLabel.text = [NSString stringWithFormat:@"%zd帖子",model.totalNum];
//            if (model.list.count > 0) {
//                [weakSelf.ATableView.mj_footer endRefreshing];
//                [forumListArrM addObjectsFromArray:model.list];
//            }else{
//                [weakSelf.ATableView.mj_footer endRefreshingWithNoMoreData];
//                
//            }
//            [weakSelf.ATableView.mj_header endRefreshing];
//            
//            [weakSelf.ATableView reloadData];
//            
//        }
//    }];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getTopView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 200)];
    _topView = topView;
    
//    topView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:topView];
    NSString *imgStr = [NSString stringWithFormat:@"标签%zd",self.topImgType + 1];
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
    [topView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView);
    }];
    
    UILabel *titleLabel = [UILabel creatLableWithText:self.keywordModel.categoryName andFont:WTFont(23) textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
    if (self.keywordModel.categoryName.length > 5) {
        titleLabel.font = WTFont(18);
    }
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView).offset(H(-10));
        make.centerX.equalTo(topView);
    }];
    
    UILabel *numberL = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor]];
    [topView addSubview:numberL];
    _numberLabel = numberL;
    [numberL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(titleLabel.mas_bottom).offset(H(10));
    }];
    
    [self.ATableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.right.bottom.left.equalTo(self.view);
    }];
    
    UIButton *backBut = [[UIButton alloc]init];
    [topView addSubview:backBut];
    [backBut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [backBut setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(W(15));
        make.top.equalTo(topView).offset(W(35));
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_ForumDetailController *detailVc = [[GLD_ForumDetailController alloc]init];
    GLD_ForumDetailModel *Model = forumListArrM[indexPath.row];
    detailVc.type = Model.type;
    detailVc.newsId = Model.newsId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return forumListArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!IsExist_Array(forumListArrM))return [[UITableViewCell alloc]init];
    GLD_ForumDetailModel *model = forumListArrM[indexPath.row];
    if ([model.type isEqualToString:@"2"]) {
        //病例
        return [self setBLMessageModel:model andIdexPath:indexPath];
    }else if([model.type isEqualToString:@"4"]){
        //课程答疑
        return [self setBMessageModel:model andIdexPath:indexPath];
    }
    return [self setTMessageModel:model andIdexPath:indexPath];
}

- (UITableViewCell *)setBLMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.ATableView registerClass:[GLD_TMessageCell class] forCellReuseIdentifier:GLD_TMessageCellIdentifi];
    GLD_TMessageCell *cell = [self.ATableView dequeueReusableCellWithIdentifier:GLD_TMessageCellIdentifi];
    cell.BLdetailModel = model;
    
    return cell;
}
- (UITableViewCell *)setTMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.ATableView registerClass:[GLD_TMessageCell class] forCellReuseIdentifier:GLD_TMessageCellIdentifi];
    GLD_TMessageCell *cell = [self.ATableView dequeueReusableCellWithIdentifier:GLD_TMessageCellIdentifi];
    cell.TZdetailModel = model;
    
    return cell;
}
- (UITableViewCell *)setBMessageModel:(GLD_ForumDetailModel *)model andIdexPath:(NSIndexPath *)indexPath{
    [self.ATableView registerClass:[GLD_BMessageCell class] forCellReuseIdentifier:GLD_BMessageCellIdentifi];
    GLD_BMessageCell *cell = [self.ATableView dequeueReusableCellWithIdentifier:GLD_BMessageCellIdentifi];
    cell.CCdetailModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H(140);
}
- (UITableView *)ATableView{
    if (!_ATableView) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
//                table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _ATableView = table;
    _ATableView.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        [forumListArrM removeAllObjects];
        [self getContentDetailRequest];
    }];
        _ATableView.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [self getContentDetailRequest];
        }];
        
        [self.view addSubview:_ATableView];
    }
    return _ATableView;
}

@end
