//
//  BaseVO.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BaseVO.h"
#import "MJExtension.h"
#import "BuildInfoVO.h"

@implementation BaseVO
+(NSDictionary *)mj_objectClassInArray{
    return @{
              @"results" : @"BookVO",
              @"updateInfo" : @"BuildInfoVO"
             };
}
@end
