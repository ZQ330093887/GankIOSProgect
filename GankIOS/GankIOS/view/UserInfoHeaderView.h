//
//  UserInfoHeaderView.h
//  GankIOS
//
//  Created by 周琼 on 2018/11/9.
//  Copyright © 2018年 周琼. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH_RATIO (SCREEN_WIDTH / 320)
#define kHeaderViewHeight 210 * SCREEN_WIDTH_RATIO
@interface UserInfoHeaderView : UIView

@property (nonatomic,assign) BOOL updateUserInfo;

@property (nonatomic,copy) void(^checkUserInfomationBlock)();

- (void)alphaWithHeight:(CGFloat)height orignHeight:(CGFloat)orignHeight;

@end
