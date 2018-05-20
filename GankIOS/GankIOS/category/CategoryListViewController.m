//
//  CategoryListViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/14.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CategoryListViewController.h"
#import "CommonTableViewCellView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "BaseVO.h"
#import "BookVO.h"
#import "CaneryCell.h"
#import "MJRefresh.h"

@interface CategoryListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSInteger _page;
}

@property (nonatomic,strong) NSMutableArray *bookArray;//数据存储
@property (nonnull,strong) MBProgressHUD* HUD;//加载进度条

//加载进度条
- (IBAction)showTextDialog:(NSString *)sender;
//toast提示
- (IBAction)showAllTextDialog:(NSString *)sender;

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
    self.view.backgroundColor = [UIColor whiteColor];
 
    // Do any additional setup after loading the view.
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    }
    self.tabBarController.tabBar.hidden = YES;
}

- (void) addLeftButton{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _mTitle;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
}

- (void)selectRightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
       
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CaneryCell class] forCellReuseIdentifier:cellID];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


-(void) initView{
    //刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         _page = 1;
        [self getNetworkData:YES];
    }];
    //加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNetworkData:NO];
    }];
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
    BookVO *Book = (BookVO *)[self.bookArray objectAtIndex:rowNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Book.url]];
    //item 按下抬起的时候返回正常背景
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

//停止刷新
- (void) endRefresh{
    if (_page ==1) {
        [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
    [self.HUD hideAnimated:YES];
}
//加载数据
-(void) getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _page=1;
    }else{
        _page++;
    }
    //设置url
    NSString * baseUrl = @"http://gank.io/api/data/";
    NSString * urlStr = [NSString stringWithFormat:@"%@%@/%d/%ld", baseUrl,_mTitle ,10 ,_page];
    NSLog(@"我的URL:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"当前进去");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功数据=%@",responseObject);
        //成功获取数据之后停止刷新和加载
        [self endRefresh];
        NSArray *response = [BaseVO mj_objectWithKeyValues:responseObject].results;
        if (response != nil && response.count > 0) {
            if (isRefresh) {//刷新
                //如果是刷新，向数组中添加数据之前清空数组
                [self.bookArray removeAllObjects];
                self.bookArray = [NSMutableArray arrayWithArray:response];
            }else{//上拉加载更多
                //self.bookArray = [NSMutableArray arrayWithArray:response];
                [self.bookArray addObjectsFromArray:response];
            }
        }else{
            //没有数据，显示空白界面
            NSLog(@"没有数据，显示空白界面");
        }
        //刷新数据
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了=%@",error);
        //[self.HUD hideAnimated:YES];
        [self showAllTextDialog:@"数据加载失败"];
        [self.tableView.mj_header endRefreshing];
    }];
}
-(NSMutableArray *)bookArray{
    if (!_bookArray) {
        _bookArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _bookArray;
}

-(void)showAllTextDialog:(NSString *)sender{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeText;
    _HUD.label.text = sender;
    _HUD.bezelView.color = [UIColor blackColor];
    _HUD.label.textColor = [UIColor whiteColor];
    _HUD.minSize = CGSizeMake(130, 20);
    [_HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [_HUD removeFromSuperview];
        _HUD = nil;
    }];
}

//显示进度条
-(void)showTextDialog:(NSString *)sender{
    _HUD = [[MBProgressHUD alloc] init];
    [self.view addSubview:_HUD];
    _HUD.bezelView.color = [UIColor blackColor];
    _HUD.bezelView.color = [_HUD.bezelView.color colorWithAlphaComponent:1];
    //3,设置背景框的圆角值，默认是10
    _HUD.bezelView.layer.cornerRadius = 10.0;
    //6，设置菊花颜色  只能设置菊花的颜色
    _HUD.activityIndicatorColor = [UIColor whiteColor];
    _HUD.margin = 15;
    _HUD.label.text = sender;
    _HUD.label.textColor = [UIColor whiteColor];
    //11，背景框的最小大小
    _HUD.minSize = CGSizeMake(100, 100);
    //13,是否强制背景框宽高相等
    _HUD.square = YES;
    //14,设置显示和隐藏动画类型  有三种动画效果，如下
    _HUD.animationType = MBProgressHUDAnimationZoomOut; //HUD的整个view后退 然后逐渐的后退
    _HUD.removeFromSuperViewOnHide = NO;
    [_HUD showAnimated:YES];
}

@end
