//
//  BookVO.m
//  GankIOS
//
//  Created by 周琼 on 2018/5/15.
//  Copyright © 2018年 周琼. All rights reserved.
//

#import "BookVO.h"

@implementation BookVO

-(BOOL)isEqual:(id)object{
    if (self == object) return YES;
    if ([self class] != [object class]) return NO;
    
    BookVO *book = (BookVO*)object;
    if (![_url isEqualToString:book.url]) {
        return NO;
    }
    if (![_who isEqualToString:book.who]) {
        return NO;
    }
    if (![_desc isEqualToString:book.desc]) {
        return NO;
    }
    if (![_publishedAt isEqualToString:book.publishedAt]) {
        return NO;
    }
    if (![_createdAt isEqualToString:book.createdAt]) {
        return NO;
    }
    if (![_type isEqualToString:book.type]) {
        return NO;
    }
    return YES;
}

-(NSUInteger)hash
{
    NSUInteger url = [_url hash];
    NSUInteger who = [_who hash];
    NSUInteger desc = [_desc hash];
    NSUInteger publishedAt = [_publishedAt hash];
    NSUInteger createdAt = [_createdAt hash];
    NSUInteger type = [_type hash];

    return url^who^desc^publishedAt^createdAt^type;
}


@end
