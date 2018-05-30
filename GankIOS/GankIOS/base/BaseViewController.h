//
//  BaseViewController.h
//  GankIOS
//
//  Created by 周琼 on 2018/5/29.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController


// 创建tabView  上拉 下拉 刷新
-(void)createTableViewRefresh;
//完成
-(void)endTableViewRefresh;

// 创建tabView  上拉 下拉 刷新
-(void)createCollRefresh;
//完成
-(void)endCollRefresh;


//网络请求的方法。  isRefresh:是刷新还是加载， true 刷新，false 加载
@property(nonatomic,copy)void(^loadingData)(BOOL isRefresh);
//页数
@property(nonatomic,assign) NSInteger page;

//toast提示
-(void)showAllTextDialog:(NSString *)sender;
//显示加载进度条
-(void)showTextDialog:(NSString *)sender;
//隐藏加载进度条
-(void)hideTextDialog;




//在这里面写入网络请求成功后的数据解析以及其它代码
@property(nonatomic,copy)void(^GetSuccess)(id GetData);
//  get 请求  数据
- (void)GetRequsetDataUrlString:(NSString *)url Parameters:(NSDictionary *)dic;



//   主  table
@property (nonatomic, strong) UITableView *mainTableView;


@property (nonatomic,strong) UICollectionView *collectionView;
//标题
@property(nonatomic,retain) NSString * mTitle ;

-(void) showTabBar;
-(void) hideTabBar;
-(void) addLeftButton;



/***********缓存暂时写这里********/
//删除缓存
- (void)deleteLocalCacheDataWithKey:(NSString *)key;
//读缓存
- (NSData *)readLocalCacheDataWithKey:(NSString *)key;
// 写缓存
- (void)writeLocalCacheData:(NSData *)data withKey:(NSString *)key;

@end
