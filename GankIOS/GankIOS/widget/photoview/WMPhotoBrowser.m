//
//  WMPhotoBrowser.m
//  GankIOS
//
//  Created by 周琼 on 2018/11/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "WMPhotoBrowser.h"
#import "WMPhotoBrowserCell.h"
#import "WMCollectionViewFlowLayout.h"
#import "UIViewController+WMExtension.h"
#import "ToastUtils.h"


@interface WMPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    
}
@property(nonatomic,assign)BOOL isHideNaviBar;
@property(nonatomic,strong) UICollectionView *collectionView;
@end

@implementation WMPhotoBrowser
- (BOOL)fullScreenGestureShouldBegin{
    return NO;
}
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(ios 11.0,*)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
        }else{
            if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
                self.automaticallyAdjustsScrollViewInsets=NO;
            }
        }
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)deleteTheImage:(UIBarButtonItem *)sender{
    if (self.dataSource.count==1) {
        [self.dataSource removeObjectAtIndex:self.currentPhotoIndex];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.dataSource removeObjectAtIndex:self.currentPhotoIndex];
        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
        [self.collectionView reloadData];
    }
    
    if (self.deleteBlock) {
        self.deleteBlock(self.dataSource,self.currentPhotoIndex,self.collectionView);
    }
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        WMCollectionViewFlowLayout *layout = [[WMCollectionViewFlowLayout alloc] init];
        layout.imgaeGap = 20;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[WMPhotoBrowserCell class] forCellWithReuseIdentifier:@"WMPhotoBrowserCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentOffset = CGPointMake(0, 0);
        _collectionView.contentSize = CGSizeMake(self.view.frame.size.width * self.dataSource.count, self.view.frame.size.height);
    }
    return _collectionView;
}
// 如果实现了iOS8以后的方法, 则旧版方法会覆盖

//视图发生了大小改变的时候会调用此方法   大小改变 == 横竖切换
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"size; %@", NSStringFromCGSize(size));
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横屏");
        self.collectionView.frame = CGRectMake(0, 0,size.width,size.height);
    }else{
        self.collectionView.frame = CGRectMake(0, 0,size.width,size.height);
    }
    
}
#pragma mark
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideTabBar];
    if (self.downLoadNeeded) {
        UIButton *_saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveImageBtn.frame = CGRectMake(0, 0, 40, 40);
        _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_saveImageBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [_saveImageBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateHighlighted];
        [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_saveImageBtn];
    }else if(self.deleteNeeded){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTheImage:)];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.title?self.title:[NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ic_nav_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(selectRightAction:)];

    self.isHideNaviBar = NO;
    [self.view addSubview:self.collectionView];
    if (self.dataSource.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.currentPhotoIndex) inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

//返回按钮点击事件
- (void)selectRightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WMPhotoBrowserCell *currentCell = (WMPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath:indexPath];
            UIImageWriteToSavedPhotosAlbum(currentCell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [ToastUtils showToast:@"保存失败" location:@"bottom" showTime:3.0];
    } else {
        [ToastUtils showToast:@"保存成功" location:@"bottom" showTime:3.0];
    }
    if (self.downLoadBlock) {
        self.downLoadBlock(self.dataSource,image,error);
    }
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (self.currentPhotoIndex==0) {
    //        scrollView.bounces = NO;
    //    }else{
    //        scrollView.bounces = YES;
    //    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.title isEqualToString:@"图片预览"]) {
        
    }else{
        CGPoint offSet = scrollView.contentOffset;
        self.currentPhotoIndex = offSet.x / self.view.width;
        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    }
}

#pragma mark - UICollectionViewDataSource && Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WMPhotoBrowserCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        cell.singleTapGestureBlock = ^(){
            if (weakSelf.isHideNaviBar==YES) {
                [weakSelf.navigationController setNavigationBarHidden:NO animated:YES];
            }else{
                [weakSelf.navigationController setNavigationBarHidden:YES animated:YES];
            }
            weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
    }
    
    
    if (!cell.longPressGestureBlock) {
        cell.longPressGestureBlock = ^(WMPhotoBrowserCell *cell) {
            
            UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertAction addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImageWriteToSavedPhotosAlbum(cell.imageView.image, weakSelf,
                                               @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }]];
            
            [alertAction addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }]];
            [weakSelf presentViewController:alertAction animated:YES completion:^{
                
            }];
        };
    }
    cell.currentIndexPath = indexPath;
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentPhotoIndex+1,self.dataSource.count];
    return cell;
}
- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

