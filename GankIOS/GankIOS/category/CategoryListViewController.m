//
//  CategoryListViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/14.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CommonTableViewCellView.h"
#import "WYWebController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "BaseVO.h"
#import "BookVO.h"
#import "CaneryCell.h"
#import "MJRefresh.h"

@interface CategoryListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *bookArray;//数据存储

@end

static NSString* const cellID = @"cellID";


@implementation CategoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];
    [self addLeftButton];
    [self initView];
    //加载进度条
    [self showTextDialog:@"加载中..."];
    //加载数据
    [self getNetworkData:YES];
}

-(void) initView{
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[CaneryCell class] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.mainTableView];
    
    // 防止 block  循环 引用
    __weak typeof(self) WeakSelf = self;
    [self createTableViewRefresh];
    //刷新或者加载
    self.loadingData = ^(BOOL isRefresh) {
        if (isRefresh) {
            WeakSelf.page = 1;
        }
        [WeakSelf getNetworkData:isRefresh];
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaneryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    NSUInteger index = indexPath.row;
    BookVO *book = (BookVO *)[self.bookArray objectAtIndex:index];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.book =book;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/**
 *点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger rowNo = indexPath.row;
    BookVO *book = (BookVO *)[self.bookArray objectAtIndex:rowNo];
    WYWebController *webVC = [WYWebController new];
    webVC.url = book.url;
    [self.navigationController pushViewController:webVC animated:YES];
    //item 按下抬起的时候返回正常背景
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

//加载数据
-(void) getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        self.page=1;
    }else{
        self.page++;
    }
    //设置url
    NSString * baseUrl = @"http://gank.io/api/data/";
    NSString * urlStr = [NSString stringWithFormat:@"%@%@/%d/%ld", baseUrl,self.mTitle ,10 ,self.page];
    NSLog(@"我的URL:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak typeof(self) WeakSelf = self;
    [super GetRequsetDataUrlString:urlStr Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        [WeakSelf endTableViewRefresh];
        NSArray *response = [BaseVO mj_objectWithKeyValues:responseObject].results;
        if (response != nil && response.count > 0) {
            if (isRefresh) {//刷新
                //如果是刷新，向数组中添加数据之前清空数组
                [WeakSelf.bookArray removeAllObjects];
                WeakSelf.bookArray = [NSMutableArray arrayWithArray:response];
            }else{//上拉加载更多
                //self.bookArray = [NSMutableArray arrayWithArray:response];
                [WeakSelf.bookArray addObjectsFromArray:response];
            }
        }else{
            //没有数据，显示空白界面
            NSLog(@"没有数据，显示空白界面");
        }
        //刷新数据
        [WeakSelf.mainTableView reloadData];
    };
}
-(NSMutableArray *)bookArray{
    if (!_bookArray) {
        _bookArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bookArray;
}

@end
