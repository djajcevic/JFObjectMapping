//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import "JFAnnotation.h"

@interface JFAnnotation ()

@property(nonatomic, readwrite, strong) NSString *fieldName;
@property(nonatomic, readwrite, strong) Class    targetClass;

@end

@implementation JFAnnotation

- (id)initWithFieldName:(NSString*) fieldName andTargetClass:(Class) clazz
{
    self = [super init];
    if (self) {
        self.fieldName = fieldName;
        self.targetClass = clazz;
    }

    return self;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@: targetClass:%@, targetProperty:%@", NSStringFromClass([self class]), NSStringFromClass([self targetClass]), self.fieldName];

    return description;
}


@end