//
// Created by Denis Jajčević on 26.04.2014..
// Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import "NSDictionary+JFObjectMapping.h"


@implementation NSDictionary (JFObjectMapping)

- (void)mapToInstance:(id)instance
{
    for (NSString *propertyName in self) {
        id value = [self objectForKey:propertyName];
        if (![value isKindOfClass:[NSDictionary class]]) {
            [instance setValue:value forKeyPath:propertyName];
        }
    }
}

@end