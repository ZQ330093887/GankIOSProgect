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
#import "MBProgressHUD.h"

#import "STImageVIew.h"
#import "STPhotoBroswer.h"

@interface CategoryWelfareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *welfareArray;//数据存储


@end


static NSString* const cellID = @"cellID";
@implementation CategoryWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];
    [self addLeftButton];
    [self initView];
    //加载进度条
    [self showTextDialog:@"加载中..."];
    [self getNetworkData:YES];
    // Do any additional setup after loading the view.
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
    //添加到视图
    [self.view addSubview:self.collectionView];
    //设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [self.collectionView registerClass:[WelfareCollViewCell class] forCellWithReuseIdentifier:cellID];
    
    // 防止 block  循环 引用
    __weak typeof(self) WeakSelf = self;
    [self createCollRefresh];
    //刷新或者加载
    self.loadingData = ^(BOOL isRefresh) {
        if (isRefresh) {
            WeakSelf.page = 1;
        }
        [WeakSelf getNetworkData:isRefresh];
    };
    
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

//加载数据
-(void) getNetworkData:(BOOL)isRefresh{
    if (isRefresh) {
        self.page=1;
    }else{
        self.page++;
    }
    NSString * baseUrl = @"http://gank.io/api/data/福利/10";
    NSString * urlStr = [NSString stringWithFormat:@"%@/%ld", baseUrl ,self.page];
    NSLog(@"我的URL:%@",urlStr);
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    __weak typeof(self) WeakSelf = self;
    [super GetRequsetDataUrlString:urlStr Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        //成功获取数据之后停止刷新和加载
        [WeakSelf endCollRefresh];
        NSArray *response = [BaseVO mj_objectWithKeyValues:responseObject].results;
        if (response != nil && response.count > 0) {
            if (isRefresh) {//刷新
                //如果是刷新，向数组中添加数据之前清空数组
                [WeakSelf.welfareArray removeAllObjects];
                WeakSelf.welfareArray = [NSMutableArray arrayWithArray:response];
            }else{//上拉加载更多
                [WeakSelf.welfareArray addObjectsFromArray:response];
            }
        }else{
            //没有数据，显示空白界面
            NSLog(@"没有数据，显示空白界面");
        }
        //刷新数据
        [WeakSelf.collectionView reloadData];
    };
}

-(NSMutableArray *)welfareArray{
    if (!_welfareArray) {
        _welfareArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _welfareArray;
}

@end
