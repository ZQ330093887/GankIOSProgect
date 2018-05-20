//
//  HomeVO.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/19.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "HomeVO.h"
#import "MJExtension.h"

@implementation HomeVO

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"Android"  : @"BookVO",
             @"iOS"      : @"BookVO",
             @"html"      : @"BookVO",
             @"audio"    : @"BookVO",
             @"resouse"    : @"BookVO",
             @"wetify"    : @"BookVO",
             @"recommend"   :@"BookVO"
             };
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"audio":@"休息视频",
             @"resouse":@"拓展资源",
             @"recommend":@"瞎推荐",
             @"wetify":@"福利",
             @"html":@"前端"
             };
}
@end
