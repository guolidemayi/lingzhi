//
//  GLD_BusnessCommentController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/8/1.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BusnessCommentController.h"
#import "GLD_CommentCell.h"
#import "GLD_CommentBottomView.h"
#import "InputKeyboardView.h"
#import "YXLiveingHotModel.h"
#import "GLD_BusinessCell.h"
#import "GLD_BusnessModel.h"
#import "GLD_Button.h"

@interface GLD_BusnessCommentController ()<UITableViewDelegate,UITableViewDataSource,keyboardDelegate,GLD_CommentBottomViewDelegate>{
    YXCommentListModel *commentListModel;
    NSInteger pageNo;    //页数
}
@property (nonatomic, weak)UITableView *detailTable;
@property (nonatomic, strong) InputKeyboardView *keyView;

@property (nonatomic, weak)GLD_CommentBottomView *commentView;
@property(nonatomic,strong) NSMutableArray *commentArrM;//评论数据源
@end

@implementation GLD_BusnessCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentArrM = [NSMutableArray array];
    self.keyView = [[InputKeyboardView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.keyView.delegate = self;
    [self commentView];
    [self getCommentList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.commentArrM.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [self getBusinessCell:indexPath];
        case 1:
            return [self setQuestionCell:tableView andIndexPath:indexPath];
        default:
            break;
    }
    return [[UITableViewCell alloc]init];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.detailTable dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.busnessModel;
    return cell;
}

- (UITableViewCell *)setQuestionCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    [tableView registerClass:[GLD_CommentCell class] forCellReuseIdentifier:@"GLD_CommentCell"];
    GLD_CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_CommentCell" forIndexPath:indexPath];
    cell.commentIndexPath = indexPath;
    if(IsExist_Array(_commentArrM))
        cell.commentModel = _commentArrM[indexPath.row];
    cell.likeBut.hidden = YES;
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: {
            return W(100);
        }break;
        case 1:
        {
            CGFloat cellHeight = 0;
            if (_commentArrM.count > 0) {
                YXCommentContent2Model *commentModel = _commentArrM[indexPath.row];
                cellHeight = 60 + commentModel.replyHieght + commentModel.beReplyHieght;
            }
            return H(cellHeight);
        }break;
    }
    return 0.01;
}

- (void)getCommentList{
    __weak typeof(self) weakSelf = self;
    //    if (weakSelf.cid.length == 0) {
    //        return;
    //    }
    NSInteger fid = 0;//条数id
    
    //    [self showNoDataViewOrLoadView:nil];
    if (_commentArrM.count == 0) {
        fid = 0;
        pageNo = 1;
    }else{
        YXCommentContent2Model *model = (YXCommentContent2Model*)[_commentArrM lastObject];
        fid = model.fid;
        pageNo++;
    }
    
    NSInteger offset = _commentArrM.count;
    
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = getCommentListRequest;
    
    config.requestParameters = @{@"limit":@"10",
                                 @"offset":[NSString stringWithFormat:@"%zd",offset],
                                 @"id":GetString(self.busnessModel.industryId),
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            //            [CAToast showWithText:@"认证成功"];
            YXCommentContent1Model *commentModel = [[YXCommentContent1Model alloc]initWithDictionary:result error:nil];
            [weakSelf handleCommentList:commentModel.data.copy];
            
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        
        [weakSelf.detailTable.mj_footer endRefreshing];
        [weakSelf.detailTable.mj_header endRefreshing];
        
    }];
    
}

- (void)handleCommentList: (NSArray *)commentArr {
    
    for (YXCommentContent2Model *model in commentArr) {
        
        if (model.beReplyUserNickName) {
            
            if (model.beReplyDelFlag == 1) {
                model.beReplyHieght = 60;
                if (model.replyMediaId) {
                    model.replyHieght = 40;
                }else{
                    model.replyHieght = [YXUniversal calculateCellHeight:0 width:270 text:[NSString stringWithFormat:@"回复@%@ : %@",model.beReplyUserNickName,model.replyContent] font:15] +10;
                }
            }else{
                if(model.beReplyMediaId){
                    model.beReplyHieght = 60;
                }else if(model.beReplyContent){
                    model.beReplyHieght = [YXUniversal calculateCellHeight:0 width:260 text:[NSString stringWithFormat:@"@%@ : %@",model.beReplyUserNickName,model.beReplyContent] font:15] + 40;
                }
                if (model.replyMediaId) {
                    model.replyHieght = 40;
                }else{
                    model.replyHieght = [YXUniversal calculateCellHeight:0 width:270 text:[NSString stringWithFormat:@"回复@%@ : %@",model.beReplyUserNickName,model.replyContent] font:15] +10;
                }
            }
        }else{
            if (model.replyMediaId) {
                model.replyHieght = 40;
            }else if(model.replyContent){
                model.replyHieght =  [YXUniversal calculateCellHeight:0 width:270 text:model.replyContent font:15]+10;
            }
        }
        
        [_commentArrM addObject:model];
    }
    
    [self.detailTable reloadData];
}
#pragma mark -- keyboradDelegate

//显示键盘占位符 text
- (void)showKeyBoard: (NSString *)text{
    
    [self.keyView showKeyboardView:text isHideStatus:NO];
    [self.view addSubview:self.keyView];
}

-(void)closeKeyborad:(NSString *)text
{
    //    self.replyString = text;
    self.commentView.textFeild.text = text;
    [self.keyView removeFromSuperview];
}

-(void)sendKeyboard:(NSString *)text
{
    [self.keyView removeFromSuperview];
    
    //    if(!self.livingInfoModel){
    //        return;
    //    }
    if (text.length == 0) {
        
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict addEntriesFromDictionary:@{@"id":GetString(self.busnessModel.industryId)}];
    [dict addEntriesFromDictionary:@{@"userId":GetString([AppDelegate shareDelegate].userModel.userId)}];
    [dict addEntriesFromDictionary:@{@"content":text}];
    __weak typeof(self) weakSelf = self;
    
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = sendCommentRequest;
    
    config.requestParameters = dict;
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [weakSelf.commentArrM removeAllObjects];
            [weakSelf getCommentList];
            [CAToast showWithText:@"发送成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
        
    }];
}
//懒加载
- (UITableView *)detailTable{
    if (!_detailTable) {
        
        WS(weakSelf);
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTable = table;
        table.delegate = self;
        table.dataSource = self;
        if (@available(iOS 11.0, *)) {
            table.estimatedRowHeight = 0;
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [table registerClass:[GLD_CommentCell class] forCellReuseIdentifier:@"GLD_CommentCell"];
        [table registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getCommentList];
        }];
        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.commentArrM removeAllObjects];
            [weakSelf getCommentList];
        }];
        [self.view addSubview:table];
    }
    return _detailTable;
}
- (GLD_CommentBottomView *)commentView{
    if (_commentView == nil) {
        GLD_CommentBottomView *commenView = [[GLD_CommentBottomView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-H(45)-64-(iPhoneXBottomHeight ? (34 + 20):0), DEVICE_WIDTH, H(45)+iPhoneXBottomHeight)];
        _commentView = commenView;
        commenView.delegate = self;
        [self.view addSubview:commenView];
        WS(weakSelf);
        [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view);
            make.right.left.equalTo(weakSelf.view);
            make.bottom.equalTo(commenView.mas_top);
        }];
        _commentView.title = self.busnessModel.name;
        
    }
    return _commentView;
    
}
- (void)content{
    [self showKeyBoard:@"说点什么"];
}
@end
