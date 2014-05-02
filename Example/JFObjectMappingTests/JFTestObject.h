//
// Created by Denis Jajčević on 26.04.2014..
//  Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+JFObjectMapping.h"

@class JFTestSubObject;


@interface JFTestObject : NSObject

@property(nonatomic, retain) NSNumber        *instanceId;
@property(nonatomic, retain) NSString        *instanceDescription;
@property(nonatomic, retain) NSString        *testString;
@property(nonatomic, retain) NSNumber        *testNumber;
@property(nonatomic, retain) NSDictionary    *testDictionary;
@property(nonatomic, retain) NSArray         *testArray;
@property(nonatomic, retain) NSSet           *testSet;
@property(nonatomic, retain) JFTestSubObject *testSubObject;

@end