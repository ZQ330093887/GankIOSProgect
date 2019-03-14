//
//  CommonUtils.h
//  GankIOS
//
//  Created by 周琼 on 2019/3/14.
//  Copyright © 2019年 周琼. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonUtils : NSObject
//格式化时间
+(NSString *) getDataString:(NSString *)stringData;

//获取当天时间
+(NSString *) getDataToday;


+(NSString *) getMonthAndDay: (NSString*)timeStr :(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
