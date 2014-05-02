//
// Created by Denis Jajčević on 26.04.2014..
//  Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import "JFTestObject.h"
#import "JFTestSubObject.h"
#import "JFObjectMetaRepository.h"
#import "JFIgnoreSerialization.h"


@implementation JFTestObject

+ (void)load
{
    [super load];
    JFObjectMeta *meta = [[JFObjectMetaRepository defaultRepository]
            registerClass:[self class]];
    [meta mapPropertyName:@"test_id" to:kInstanceIdPropertyName];

    JFIgnoreSerialization *ignoreSerialization = [[JFIgnoreSerialization alloc]
            initWithFieldName:@"testNumber" andTargetClass:[self class]];
    ignoreSerialization.mode = SERIALIZATION_ONLY;
    [meta addSerializationAnnotation:ignoreSerialization];
}

- (void)afterPropertiesSet
{
    NSLog(@"Object populated: %@", self);
}

@end