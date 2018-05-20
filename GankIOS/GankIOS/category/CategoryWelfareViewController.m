//
//  CategoryWelfareViewController.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/17.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CategoryWelfareViewController.h"
#import "WelfareCollViewCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BookVO.h"
#import "BaseVO.h"

#import "STImageVIew.h"
#import "STPhotoBroswer.h"

@interface CategoryWelfareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger _page;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *welfareArray;//数据存储
@end


static NSString* const cellID = @"cellID";
@implementation CategoryWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];
    [self addLeftButton];
    [self initView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getNetworkData:YES];
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

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15.f;
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 15*3)/2, 210);
    
        //创建UICollectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
        //添加到视图
        [self.view addSubview:_collectionView];
        _collectionView.scrollsToTop = NO;
        //开启分页
        _collectionView.pagingEnabled = YES;
        //不显示滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView.alwaysBounceVertical = YES;
        //弹簧效果设置
        _collectionView.bounces = YES;
        //设置代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册cell
        [_collectionView registerClass:[WelfareCollViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

//item 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    NSMutableArray *photoURLArray = [NSMutableArray array];
    for (BookVO *meizi in self.welfareArray) {
        [photoURLArray addObject:meizi.url];
    }
    
    STPhotoBroswer * broser = [[STPhotoBroswer alloc] initWithImageArray:photoURLArray currentIndex:indexPath.row];
    [broser show];
    
}

-(void) initView{
    //刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getNetworkData:YES];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //设置状态
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"数据加载中" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];

    self.collectionView.mj_header = header;
    //加载
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNetworkData:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _welfareArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WelfareCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSUInteger index = indexPath.row;
    BookVO *book = (BookVO *)[_welfareArray objectAtIndex:index];
    cell.picBook = book;
    return cell;
}
//停止刷新
- (void) endRefresh{
    if (_page ==1) {
        [self.collectionView.mj_header endRefreshing];
    }
    [self.collectionView.mj_footer endRefreshing];
}
//加载数据
-(void) getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        _page=1;
    }else{
        _page++;
    }
    NSString * baseUrl = @"http://gank.io/api/data/福利/10";
    NSString * urlStr = [NSString stringWithFormat:@"%@/%ld", baseUrl ,_page];
    NSLog(@"我的URL:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
                [self.welfareArray removeAllObjects];
                self.welfareArray = [NSMutableArray arrayWithArray:response];
            }else{//上拉加载更多
                [self.welfareArray addObjectsFromArray:response];
            }
        }else{
            //没有数据，显示空白界面
            NSLog(@"没有数据，显示空白界面");
        }
        //刷新数据
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了=%@",error);
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(NSMutableArray *)welfareArray{
    if (!_welfareArray) {
        _welfareArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _welfareArray;
}
@end
