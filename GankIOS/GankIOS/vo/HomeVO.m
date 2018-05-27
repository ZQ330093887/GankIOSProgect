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
             @"App"    : @"BookVO",
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


-(BOOL)isEqual:(id)object{
    if (self == object) return YES;
    if ([self class] != [object class]) return NO;
    HomeVO *home = (HomeVO*)object;
    if (![_iOS isEqual:home.iOS]) {
        return NO;
    }
    if (![_Android isEqual:home.Android]) {
        return NO;
    }
    if (![_html isEqual:home.html]) {
        return NO;
    }
    if (![_audio isEqual:home.audio]) {
        return NO;
    }
    if (![_resouse isEqual:home.resouse]) {
        return NO;
    }
    if (![_wetify isEqual:home.wetify]) {
        return NO;
    }
    if (![_App isEqual:home.App]) {
        return NO;
    }
    if (![_recommend isEqual:home.recommend]) {
        return NO;
    }
    return YES;
}

-(NSUInteger)hash{
    NSUInteger ios = [_iOS hash];
    NSUInteger android = [_Android hash];
    NSUInteger html = [_html hash];
    NSUInteger audio = [_audio hash];
    NSUInteger resouse = [_resouse hash];
    NSUInteger wetify = [_wetify hash];
    NSUInteger app = [_App hash];
    NSUInteger recommend = [_recommend hash];
    return ios^android^html^audio^resouse^wetify^app^recommend;
}
@end
