//
//  JFObjectMeta.m
//  JFObjectMapping
//
//  Created by Denis Jajčević on 16.9.2013..
//  Copyright (c) 2012 JF. All rights reserved.
//

#import "JFObjectMeta.h"

@implementation JFObjectMeta

- (NSMutableDictionary *)propertyAttributes
{
    if (_propertyAttributes == nil) {
        _propertyAttributes = [NSMutableDictionary new];
    }
    return _propertyAttributes;
}

- (id)initWithClass:(Class)clazz
{
    self = [self initWithClass:clazz ignoreFields:nil];
    if (self) {
    }
    return self;
}

- (id)initWithClass:(Class)clazz ignoreFields:(NSArray *)fieldsToIgnore
{
    self = [super init];
    if (self) {
        self.clazz = clazz;

        NSMutableArray *propertyArray   = [NSMutableArray array];
        NSMutableArray *propertyClasses = [NSMutableArray array];
        Class          currentClass     = clazz;
        while ([self validClass:currentClass]) {
            [self populatePropertyNames:propertyArray andPropertyClasses:propertyClasses forClass:currentClass
                    andIgnoreProperties:fieldsToIgnore];
            currentClass = [currentClass superclass];
        }
        self.propertyNames   = propertyArray;
        self.propertyClasses = [JFObjectMeta itemClasses:propertyClasses];
    }
    return self;
}

- (void)populatePropertyNames:(NSMutableArray *)propertyArray andPropertyClasses:(NSMutableArray *)propertyClasses
                     forClass:(Class)clazz andIgnoreProperties:(NSArray *)ignoredProperties
{
    u_int count;

    objc_property_t *properties = class_copyPropertyList(clazz, &count);
    for (int        i           = 0; i < count; i++) {
        const char *propertyName       = property_getName(properties[i]);
        NSString   *propertyNameString = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        if ([ignoredProperties containsObject:propertyNameString]) {
            continue;
        }
        const char *className       = property_copyAttributeValue(properties[i], "T");
        NSString   *classNameString = [[NSString alloc]
                initWithCString:className encoding:NSUTF8StringEncoding];
        if ([classNameString isEqualToString:@"c"]) {
            classNameString = @"NSNumber";
        }
        else if ([classNameString length] == 1) {
            classNameString = nil;
        }
        else {
            classNameString = [classNameString substringWithRange:(NSRange) {2, classNameString.length - 3}];
        }

        if (className != nil) {
            [propertyArray addObject:propertyNameString];
            [propertyClasses addObject:classNameString];
        }

    }
    free(properties);
}

- (BOOL)validClass:(Class)clazz
{
    return clazz != nil && clazz != [NSObject class] && ![clazz isSubclassOfClass:[NSNumber class]] && ![clazz isSubclassOfClass:[NSArray class]]
            && ![clazz isSubclassOfClass:[NSDictionary class]] && ![clazz isSubclassOfClass:[NSString class]] && ![clazz isSubclassOfClass:[NSSet class]];
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];

    int           index = 0;
    for (NSString *propertyName in self.propertyNames) {
        [desc appendFormat:@"\n\t%@ : %@", propertyName, self.propertyClasses[index]];
        index++;
    }

    return desc;
}

- (Class)classForPropertyNamed:(NSString *)propertyName
{
    int index = [self.propertyNames indexOfObject:propertyName];
    if (index != NSNotFound) {
        return self.propertyClasses[index];
    } else {
        return nil;
    }
}

+ (NSArray *)itemClasses:(NSArray *)array
{
    NSMutableArray *classes = [NSMutableArray arrayWithCapacity:array.count];

    if (array.count) {
        if ([array[0] isKindOfClass:[NSString class]]) {
            for (NSString *item in array) {
                [classes addObject:NSClassFromString(item)];
            }
        }
        else {
            for (NSObject *item in array) {
                [classes addObject:[item class]];
            }
        }
    }
    return classes;
}

- (void)mapPropertyName:(NSString *)instancePropertyName to:(NSString *)propertyName
{
    NSMutableDictionary *propertyAttributesMap = [self propertyAttributes];
    NSMutableDictionary *propertyMapping       = propertyAttributesMap[kSerializationPropertyMappingKey];
    if (propertyMapping == nil) {
        propertyMapping = [NSMutableDictionary new];
        propertyAttributesMap[kSerializationPropertyMappingKey] = propertyMapping;
    }
    propertyMapping[propertyName]              = instancePropertyName;
}

@end
