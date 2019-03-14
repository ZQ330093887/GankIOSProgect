//
//  DateFormatUtil.m
//  GankIOS
//
//  Created by 周琼 on 2019/3/14.
//  Copyright © 2019年 周琼. All rights reserved.
//

#import "DateFormatUtil.h"

@implementation DateFormatUtil


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
@end
