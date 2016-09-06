//
//  SQLD.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/25.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "SQLD.h"

@implementation SQLD
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_Sname forKey:@"name"];
    [aCoder encodeObject:_Spinyin forKey:@"pinyin"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.Sname = [aDecoder decodeObjectForKey:@"name"];
        self.Spinyin= [aDecoder decodeObjectForKey:@"pinyin"];
    }
    return self;
}
@end
