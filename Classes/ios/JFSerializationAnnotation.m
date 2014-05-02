//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFSerializationAnnotation.h"


@implementation JFSerializationAnnotation

- (id)initWithFieldName:(NSString *)fieldName andTargetClass:(Class)clazz
{
    self = [super initWithFieldName:fieldName andTargetClass:clazz];
    if (self) {
        self.mappingBlock = ^id(id value, BOOL inverse) {
            return value;
        };
    }

    return self;
}


- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@, mapsTo:%@", super.description, self.mapsTo];

    return description;
}

@end