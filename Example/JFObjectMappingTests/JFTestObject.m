//
// Created by Denis Jajčević on 26.04.2014..
//  Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import "JFTestObject.h"
#import "JFTestSubObject.h"


@implementation JFTestObject

+ (void)load
{
    [super load];
    [[self metaData]
            mapPropertyName:@"test_id" to:kInstanceIdPropertyName];
}

- (void)afterPropertiesSet
{
    [super afterPropertiesSet];
    NSLog(@"Object populated: %@", self);
}

@end