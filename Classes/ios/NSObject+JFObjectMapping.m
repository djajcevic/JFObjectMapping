//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "NSObject+JFObjectMapping.h"
#import "JFObjectMeta.h"
#import "JFObjectMetaRepository.h"
#import "JFSerializationAnnotation.h"
#import "JFIgnoreSerialization.h"


@implementation NSObject (JFObjectMapping)

+ (JFObjectMeta *)metaData
{
    JFObjectMetaRepository *repository = [JFObjectMetaRepository defaultRepository];
    JFObjectMeta           *meta       = [repository
            metaDataForClass:(Class)
                    [self class]];
    return meta;
}

- (JFObjectMeta *)metaData
{
    return [self.class metaData];
}


- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    JFObjectMeta *meta = [[self class]
            metaData];

    NSArray *propertyNames = meta.propertyNames;

    NSMutableDictionary *propertyAttributes      = meta.propertyAttributes;
    NSDictionary        *propertyMapping         = propertyAttributes[kSerializationPropertyMappingKey];
    BOOL                propertyMappingAvailable = propertyMapping != nil;

    for (NSString *property in propertyNames) {
        id value = [self valueForKeyPath:property];
        JFSerializationAnnotation *annotation = [meta serializationAnnotationForField:property];

        if ([annotation isKindOfClass:[JFIgnoreSerialization class]]) {
            JFIgnoreSerialization *ignoreSerialization = (JFIgnoreSerialization *) annotation;
            if (!ignoreSerialization.shouldSerialize) {
                continue;
            }
        }

        // do custom reverse annotation
        if (annotation) {
            value = annotation.mappingBlock(value, YES);
        }
        
        if (value == nil) {
            continue;
        }
        Class valueClass = [value class];

        NSString *valueKey = [self getValueKey:meta propertyMappingAvailable:propertyMappingAvailable
                property:property];
        if ([valueClass metaData] != nil) {
            [dict setValue:[value toDictionary] forKey:valueKey];
        }
        else if ([valueClass isSubclassOfClass:[NSArray class]]) {
            [dict setValue:[[self class]
                    toDictionaryArray:value] forKey:valueKey];
        }
        else {
            [dict setValue:value forKey:valueKey];
        }
    }

    return [dict copy];
}

+ (NSArray *)toDictionaryArray:(NSArray *)array
{
    if (!array) {
        return nil;
    }

    NSMutableArray *result = [NSMutableArray array];

    if ([array count] == 0) {
        return result;
    }

    for (NSObject *object in array) {
        [result addObject:[object toDictionary]];
    }

    return result;
}

- (NSData *)toJson
{
    return [NSJSONSerialization dataWithJSONObject:self.toDictionary options:0 error:nil];
}

+ (NSData *)toJsonArray:(NSArray *)array
{
    if (!array || [array count] == 0) {
        return nil;
    }

    NSArray *resultArray = [self toDictionaryArray:array];
    if (!resultArray || [resultArray count] == 0) {
        return nil;
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:resultArray options:0 error:nil];
    return data;
}

- (NSString *)toJsonString
{
    return [[NSString alloc]
            initWithData:self.toJson encoding:NSUTF8StringEncoding];
}

+ (NSString *)toJsonArrayString:(NSArray *)array
{
    if (!array || [array count] == 0) {
        return nil;
    }
    NSData *data = [self toJsonArray:array];

    if (data) {
        return [[NSString alloc]
                initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (instancetype)fromDictionary:(NSDictionary *)dictionary
{
    id           instance            = [[self class]
            new];
    JFObjectMeta *meta               = [self metaData];
    NSDictionary *propertyAttributes = [[instance metaData]
            propertyAttributes];

    NSDictionary *propertyArrayItemClasses;
    if (propertyAttributes) {
        propertyArrayItemClasses = propertyAttributes[kSerializationPropertyArrayItemsClassKey];
    }

    NSDictionary *propertyMapping         = propertyAttributes[kSerializationPropertyMappingKey];
    BOOL         propertyMappingAvailable = propertyMapping != nil;

    NSMutableArray *propertyNames = [[instance metaData].propertyNames mutableCopy];

    for (NSString *property in  propertyNames) {

        id value = nil;

        NSString *propertyName = property;
        JFSerializationAnnotation *annotation = [meta serializationAnnotationForField:property];

        if ([annotation isKindOfClass:[JFIgnoreSerialization class]]) {
            JFIgnoreSerialization *ignoreSerialization = (JFIgnoreSerialization *) annotation;
            if (!ignoreSerialization.shouldDeserialize) {
                continue;
            }
        }

        NSString *valueKey     = [self getValueKey:meta propertyMappingAvailable:propertyMappingAvailable
                property:property];

        Class propertyClass = [[self metaData]
                classForPropertyNamed:propertyName];

        if ([valueKey isEqualToString:kInstanceIdPropertyName]) {
            value = dictionary[@"id"];
            if (value == nil) {
                value = dictionary[kInstanceIdPropertyName];
            }
        }
        else if ([valueKey isEqualToString:kInstanceDescriptionPropertyName]) {
            value = dictionary[@"description"];
            if (value == nil) {
                value = dictionary[kInstanceDescriptionPropertyName];
            }
        }
        else {
            value = dictionary[valueKey];
        }

        if (annotation) {
            value = annotation.mappingBlock(value, NO);
        }

        if (value != nil) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                if ([propertyClass metaData] != nil) {
                    id instanceValue = [propertyClass fromDictionary:value];
                    if (instanceValue) {
                        [instance setValue:instanceValue forKeyPath:propertyName];
                    }
                }
                else {
                    [instance setValue:value forKeyPath:propertyName];
                }
            }

            else if ([value isKindOfClass:[NSArray class]]) {
                if (propertyArrayItemClasses) {
                    Class arrayItemsClass = propertyArrayItemClasses[propertyName];
                    if (arrayItemsClass && [arrayItemsClass metaData] != nil) {
                        id instanceValues = [arrayItemsClass fromDictionaryArray:value];
                        [instance setValue:instanceValues forKey:propertyName];
                    }
                }
                else {
                    // TODO: logg message
                }
            }
            else {
                [instance setValue:value forKeyPath:propertyName];
            }
        }
    }
    if ([instance respondsToSelector:@selector(afterPropertiesSet)]) {
        [instance afterPropertiesSet];
    }
    return instance;
}

+ (NSString *)getValueKey:(JFObjectMeta *)meta propertyMappingAvailable:(BOOL)propertyMappingAvailable
                 property:(NSString *)property
{
    NSString *valueKey = nil;
    if (propertyMappingAvailable) {
        JFSerializationAnnotation *annotation = [meta serializationAnnotationForField:property];
        valueKey = annotation.mapsTo;
    }
    if ([valueKey length] == 0) {
        valueKey = property;
    }
    return valueKey;
}

- (NSString *)getValueKey:(JFObjectMeta *)meta propertyMappingAvailable:(BOOL)propertyMappingAvailable
                 property:(NSString *)property
{
    return [self.class getValueKey:meta propertyMappingAvailable:propertyMappingAvailable
            property:property];
}

+ (NSArray *)fromDictionaryArray:(NSArray *)dictionaryArray
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *dictionary in dictionaryArray) {
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            return dictionaryArray;
        }
        [array addObject:[self fromDictionary:dictionary]];
    }

    return array;
}

+ (instancetype)fromJson:(NSData *)data
{
    id instanceData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (instanceData) {
        if ([instanceData isKindOfClass:[NSDictionary class]]) {
            return [self fromDictionary:instanceData];
        }
    }
    return nil;
}

+ (NSArray *)fromJsonArray:(NSData *)data
{
    id instanceData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (instanceData) {
        if ([instanceData isKindOfClass:[NSArray class]]) {
            return [self fromDictionaryArray:instanceData];
        }
    }
    return nil;
}

+ (instancetype)fromJsonString:(NSString *)string
{
    if (!string) {
        return nil;
    }

    NSData *dataFromString = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!dataFromString) {
        return nil;
    }

    return [self fromJson:dataFromString];
}

+ (NSArray *)fromJsonArrayString:(NSString *)string
{
    if (!string) {
        return nil;
    }

    NSData *dataFromString = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!dataFromString) {
        return nil;
    }

    id instanceData = [NSJSONSerialization JSONObjectWithData:dataFromString options:0 error:nil];
    if (instanceData) {
        if ([instanceData isKindOfClass:[NSArray class]]) {
            return [self fromDictionaryArray:instanceData];
        }
    }
    return nil;
}

@end