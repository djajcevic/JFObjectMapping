//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JFObjectMeta;


@interface JFObjectMetaRepository : NSObject

@property(nonatomic, readonly) NSDictionary *repository;

+ (JFObjectMetaRepository *)defaultRepository;

- (JFObjectMeta *) registerClass:(Class) pClass;
- (JFObjectMeta *)metaDataForClass:(Class)pClass;

@end