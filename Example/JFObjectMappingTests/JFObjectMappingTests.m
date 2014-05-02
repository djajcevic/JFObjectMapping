//
//  JFObjectMappingTests.m
//  JFObjectMappingTests
//
//  Created by Denis Jajčević on 26.04.2014..
//  Copyright (c) 2014 Denis Jajčević. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JFTestObject.h"
#import "JFTestSubObject.h"


@interface JFObjectMappingTests : XCTestCase

@end

@implementation JFObjectMappingTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString     *propertyName            = @"test_id";
    NSNumber     *propertyValue           = @3;
    NSString     *testStringPropertyName  = @"testString";
    NSString     *testStringPropertyValue = @"test";
    NSString     *testNumberPropertyName = @"testNumber";
    NSNumber     *testNumberPropertyValue = @7;
    NSDate *date = [NSDate date];
    NSTimeInterval dateLong = CACurrentMediaTime() * 1000;
    JFTestSubObject *subObject = [JFTestSubObject fromDictionary:@{@"title" : @"test sub object", @"date":@(dateLong)}];

    JFTestObject *object                  = [JFTestObject fromDictionary:@{propertyName : propertyValue, testStringPropertyName : testStringPropertyValue, @"description" : @"test description", @"testSubObject" : subObject, testNumberPropertyName:testNumberPropertyValue}];

    NSDictionary *dict                    = [object toDictionary];
    XCTAssertEqualObjects(propertyValue, dict[propertyName]);
    XCTAssertEqualObjects(testStringPropertyValue, dict[testStringPropertyName]);

}

@end
