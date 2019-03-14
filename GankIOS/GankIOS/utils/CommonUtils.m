//
//  CommonUtils.m
//  GankIOS
//  刚学些iOS，目前没有成规定的utils，自己遇到一个就写一个
//  画以后多了，可以考虑归类整理
//  Created by 周琼 on 2019/3/14.
//  Copyright © 2019年 周琼. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils


+(NSString *)getDataString:(NSString *)stringData{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:stringData];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    
    return dateString;
}

+ (NSString *)getDataToday{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy/MM/dd"];//这里设置自己想要的时间
    NSString *dateStr = [forMatter stringFromDate:date];
    
    NSLog(@"当前年月日%@",dateStr);
    return dateStr;
}


+ (NSString *)getMonthAndDay:(NSString *)timeStr :(NSInteger)type{
    NSString * time =@"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSCalendar *caldendar = [NSCalendar currentCalendar];// 获取日历
    if (date !=nil) {
        NSInteger month = [caldendar component:NSCalendarUnitMonth fromDate:date];
        NSInteger day = [caldendar component:NSCalendarUnitDay fromDate:date];
        NSArray *monthArr = [NSArray arrayWithArray:caldendar.shortMonthSymbols];  // 获取日历月数组
        if (type==0) {//返回月
            time =  monthArr[month - 1];
        }else if (type ==1){//返回日
            time =  [NSString stringWithFormat:@"%ld",day];;
        }
    }
    return time;
}
@end
