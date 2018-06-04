//
//  SearchController.m
//  GankIOS
//
//  Created by 周琼 on 2018/6/4.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "SearchController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BaseVO.h"
#import "BookVO.h"
#import "CaneryCell.h"
#import "MJRefresh.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHight  [UIScreen mainScreen].bounds.size.height
static NSString* const cellID = @"cellID";
@interface SearchController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray  * bookArray;//数据存储
@property (nonatomic,strong) UISearchBar     * searchBar;
@property (nonatomic,strong) UIImageView     * imgView;//默认背景
@property (nonatomic,strong) NSString        * keyWord;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];
    [self addLeftButton];
    [self jumpToSearch];
    [self initView];
}
- (void)jumpToSearch{
    self.navigationItem.rightBarButtonItem=nil;
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.center = CGPointMake(kWidth/2, 84);
    _searchBar.frame = CGRectMake(10, 20,kWidth-20, 0);
    [_searchBar setContentMode:UIViewContentModeBottomLeft];
    _searchBar.delegate = self;
    _searchBar.backgroundColor=[UIColor clearColor];
    _searchBar.searchBarStyle=UISearchBarStyleDefault;
    _searchBar.showsCancelButton =YES;
    _searchBar.tag=1000;
    [self.navigationController.navigationBar addSubview:_searchBar];
    _searchBar.placeholder = @"搜索真的好了不骗你";
    //-------------------------------------------------------------------
    [_searchBar becomeFirstResponder];
}
- (void)backward{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) initView{
    self.page = 1;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[CaneryCell class] forCellReuseIdentifier:cellID];
    self.mainTableView.hidden = YES;
    [self.view addSubview:self.mainTableView];
    
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-50, 100, 100, 100)];
    _imgView.image = [UIImage imageNamed:@"gank_search"];
    [self.view addSubview:_imgView];
    
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNetworkData];
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

#pragma -mark 点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_searchBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark 监听输入
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText：%@",searchText);
    __weak typeof(self) WeakSelf = self;
    self.page = 1;
    if ([searchText isEqualToString:@""]) {
        [WeakSelf setTableViewVisibility:YES];
        return;
    }
    _keyWord = searchText;
    //设置url
    NSString * baseUrl = @"http://gank.io/api/search/query/";
    NSString * subUrl = @"/category/all/count/10/page/";

    NSString * urlStr = [NSString stringWithFormat:@"%@%@%@%ld", baseUrl,searchText,subUrl ,self.page];
    NSLog(@"我的URL:%@",urlStr);
    [super GetRequsetDataUrlString:urlStr Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        NSArray *response = [BaseVO mj_objectWithKeyValues:responseObject].results;
        if (response != nil && response.count >0) {
            [WeakSelf.bookArray removeAllObjects];
            WeakSelf.bookArray = [NSMutableArray arrayWithArray:response];
            [WeakSelf setTableViewVisibility:NO];
        }else{
            [WeakSelf setTableViewVisibility:YES];
        }
        //刷新数据
        [WeakSelf.mainTableView reloadData];
    };
}


//加载数据
-(void) getNetworkData{
     self.page++;
    NSString * baseUrl = @"http://gank.io/api/search/query/";
    NSString * subUrl = @"/category/all/count/10/page/";
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@%@%ld", baseUrl,_keyWord,subUrl ,self.page];
    NSLog(@"我的URL:%@",urlStr);
    __weak typeof(self) WeakSelf = self;
    [super GetRequsetDataUrlString:urlStr Parameters:nil];
    self.GetSuccess = ^(id responseObject) {
        [WeakSelf.mainTableView.mj_footer endRefreshing];
        
        [WeakSelf.bookArray addObjectsFromArray:[BaseVO mj_objectWithKeyValues:responseObject].results];
        //刷新数据
        [WeakSelf.mainTableView reloadData];
    };
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //取消字体变白
    UIButton *cancelButton;
    UIView *topView = _searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        NSLog(@"%@",NSStringFromCGRect(cancelButton.frame));
        //Set the new title of the cancel button
        [cancelButton setTitle:@"       " forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:212/255.0 green:158/255.0 blue:57/255.0 alpha:1] forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor= [UIColor colorWithRed:212/255.0 green:158/255.0 blue:57/255.0 alpha:1];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"Heiti SC" size:20];
        [cancelButton removeFromSuperview];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(-5, -5,40,40)];
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=@"取消";
        lable.textColor = [UIColor colorWithRed:212/255.0 green:158/255.0 blue:57/255.0 alpha:1];
        [cancelButton addSubview:lable];
        lable.font = [UIFont fontWithName:@"Heiti SC" size:18];
        [cancelButton addSubview:lable];
        
    }
    UIButton * button;
    [button setTintColor:  nil];
    
}

-(void)setTableViewVisibility:(BOOL) visibile{
    self.mainTableView.hidden = visibile;
    _imgView.hidden = !visibile;
}


@end
