//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFObjectMeta.h"

#define kInstanceIdPropertyName @"instanceId"

#define kInstanceDescriptionPropertyName @"instanceDescription"

@class JFObjectMeta;

@interface NSObject (JFObjectMapping)

+ (JFObjectMeta *)metaData;
- (JFObjectMeta *)metaData;

- (NSDictionary *)toDictionary;

+ (NSArray *)toDictionaryArray:(NSArray *)array;

- (NSData *)toJson;

+ (NSData *)toJsonArray:(NSArray *)array;

- (NSString *)toJsonString;

+ (NSString *)toJsonArrayString:(NSArray *)array;

+ (instancetype)fromDictionary:(NSDictionary *)dictionary;

+ (NSArray *)fromDictionaryArray:(NSArray *)dictionaryArray;

+ (instancetype)fromJson:(NSData *)data;

+ (NSArray *)fromJsonArray:(NSData *)data;

+ (instancetype)fromJsonString:(NSString *)string;

+ (NSArray *)fromJsonArrayString:(NSString *)string;

- (void)afterPropertiesSet;

@end