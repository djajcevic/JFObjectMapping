//
// Created by Denis Jajčević on 02.05.2014..
// Copyright (c) 2014 JF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFAnnotation : NSObject

@property(nonatomic, readonly, strong) NSString *fieldName;
@property(nonatomic, readonly, strong) Class    targetClass;

- (id)initWithFieldName:(NSString *)fieldName andTargetClass:(Class)clazz;
@end