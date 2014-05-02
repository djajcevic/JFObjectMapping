//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFIgnoreSerialization.h"


@implementation JFIgnoreSerialization

- (id)initWithFieldName:(NSString *)fieldName andTargetClass:(Class)clazz
{
    self = [super initWithFieldName:fieldName andTargetClass:clazz];
    if (self) {
        self.mode = ALWAYS;
    }
    return self;
}

- (BOOL)shouldSerialize
{
    switch (_mode) {
        case ALWAYS:
        case DESERIALIZATION_ONLY:
            return YES;
        case SERIALIZATION_ONLY:
        default:
            return NO;
    }
}

- (BOOL)shouldDeserialize
{
    switch (_mode) {
        case ALWAYS:
        case SERIALIZATION_ONLY:
            return YES;
        case DESERIALIZATION_ONLY:
        default:
            return NO;
    }
}


@end