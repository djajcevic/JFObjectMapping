//
// Created by Denis Jajčević on 26.04.2014..
//  Copyright (c) 2014 JF. All rights reserved.
//

#import "JFTestSubObject.h"
#import "JFObjectMetaRepository.h"
#import "JFDateMapping.h"


@implementation JFTestSubObject

+ (void)load
{
    [super load];
    JFObjectMeta *meta = [[JFObjectMetaRepository defaultRepository]
            registerClass:[self class]];

    JFDateMapping *dateMapping = [[JFDateMapping alloc]
            initWithFieldName:@"date" andTargetClass:[self class]];
    [meta addSerializationAnnotation:dateMapping];
}

@end