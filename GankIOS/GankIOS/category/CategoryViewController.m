//
//  CategoryViewController.m
//  分类界面
//
//  Created by 周琼 on 2018/5/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryListViewController.h"
#import "CategoryWelfareViewController.h"

// 宽度(自定义)
#define PIC_WIDTH 120
// 高度(自定义)
#define PIC_HEIGHT 110
// 列数(自定义)
#define COL_COUNT 3

@interface CategoryViewController ()
@property(nonatomic,strong)NSArray *apps;
@end

@implementation CategoryViewController
NSArray<NSString *> *pictures;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBarItem];
    [self loadImage];
    [self addPictures];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//顶部导航栏
-(void) initBarItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];
    //设置导航栏的背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_nav_bg"] forBarMetrics:UIBarMetricsDefault];
    //修改标题的字体大小和颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
/** 加载图片(本地) */
- (void)loadImage {
    NSMutableArray *picArray = [NSMutableArray array];
    for (int i = 0; i < 16; i++) {
        NSString *imageName = [NSString stringWithFormat:@"category_%d",i];
        [picArray addObject:imageName];
    }
    pictures = picArray.copy;
}
//1.加载数据
- (NSArray *)apps{
    if (!_apps) {
        _apps=@[@"all",@"iOS",@"Android",@"前端",@"瞎推荐",@"拓展资源",@"App",@"休息视频",@"福利"];
    }
    return _apps;
}
/** 九宫格形式添加图片 */
- (void)addPictures {
    
    CGFloat margin=(self.view.frame.size.width-COL_COUNT*PIC_HEIGHT)/(COL_COUNT+1);
    NSUInteger count= self.apps.count;
    for (int i=0; i<count; i++) {
        int row=i/COL_COUNT;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%COL_COUNT;//列号
        // PointX
        CGFloat appviewx=margin+(margin+PIC_WIDTH)*loc;
         // PointY
        CGFloat appviewy=margin+(margin+PIC_HEIGHT)*row;
        
        
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx, appviewy+40, PIC_WIDTH, PIC_HEIGHT)];
        //[appview setBackgroundColor:[UIColor purpleColor]];
        appview.tag = i;
        [self.view addSubview:appview];
        
        
        //创建uiview控件中的子视图
        UIImageView *appimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 68)];
        UIImage *appimage=[UIImage imageNamed:pictures[i]];
        appimageview.image=appimage;
        [appimageview setContentMode:UIViewContentModeScaleAspectFit];
        [appview addSubview:appimageview];
        
        //创建文本标签
        UILabel *applable=[[UILabel alloc]initWithFrame:CGRectMake(0, 73, 90, 20)];
        [applable setText:self.apps[i]];
        [applable setTextAlignment:NSTextAlignmentCenter];
        [applable setFont:[UIFont systemFontOfSize:14.0]];
        [appview addSubview:applable];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickItem:)];
        [appview addGestureRecognizer:gesture];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)clickItem:(UITapGestureRecognizer *) gesture{
    NSString *title = _apps[gesture.view.tag];
    
    CategoryListViewController *cList = [[CategoryListViewController alloc] init];
    CategoryWelfareViewController *wList = [[CategoryWelfareViewController alloc]init];
    cList.mTitle = title;
    wList.mTitle  =title;
    if ([title isEqualToString:@"福利"]) {
        [self.navigationController pushViewController:wList animated:YES];
    }else{
        [self.navigationController pushViewController:cList animated:YES];
    }
}
-(void)selectRightAction:(id)sender{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"搜索正在开发中" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
}
@end
