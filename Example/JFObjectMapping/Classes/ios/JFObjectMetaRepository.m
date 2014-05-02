//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFObjectMetaRepository.h"
#import "JFObjectMeta.h"

@interface JFObjectMetaRepository ()

@property(nonatomic, retain) NSMutableDictionary *metaRepository;

@end

@implementation JFObjectMetaRepository

+ (JFObjectMetaRepository *)defaultRepository
{
    static JFObjectMetaRepository *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc]
                    init];
        }
    }

    return _instance;
}

- (JFObjectMeta *)registerClass:(Class)pClass
{
    NSString *className = NSStringFromClass(pClass);
    JFObjectMeta *objectMeta = [[JFObjectMeta alloc]
            initWithClass:pClass];
    if (className && objectMeta) {
        _metaRepository[className] = objectMeta;
        NSLog(@"Registered %@ class", className);
        return objectMeta;
    }
    else {
        return nil;
    }
}


- (id)init
{
    self = [super init];
    if (self) {
        _metaRepository = [NSMutableDictionary new];
    }

    return self;
}

- (NSDictionary *)repository
{
    return [_metaRepository copy];
}

- (JFObjectMeta *)metaDataForClass:(Class)pClass
{
    assert(pClass);
    return [_metaRepository objectForKey:NSStringFromClass(pClass)];
}

@end