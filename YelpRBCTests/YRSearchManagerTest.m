//
//  YRSearchManagerTest.m
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-25.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YRSearchManager.h"

@interface YRSearchManagerTest : XCTestCase
@end

@implementation YRSearchManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1 {
    
    NSString * term = @"cafe";
    NSString * location = @"Toronto";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term location: location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(error, @"error should be nil");
            if(error){
                NSLog(@"queryTopBusinessInfoForTerm: %@",error.description);
            }

            XCTAssertNotNil(searchResult, @"searchResult should not be nil");
            
        }];
    }];
}

- (void)test2 {
    NSString * term = @"";
    NSString * location = @"Toronto";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term location: location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(searchResult, @"searchResult should be nil");
            
        }];
    }];
}

- (void)test3 {
    NSString * term = nil;
    NSString * location = @"Toronto";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term location: location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(searchResult, @"searchResult should be nil");
            
        }];
    }];
}


- (void)test4 {
    
    NSString * term = @"cafe";
    NSString * location = @"35.1234,-145.2345";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term cll:location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(error, @"error should be nil");
            if(error){
                NSLog(@"queryTopBusinessInfoForTerm: %@",error.description);
            }
            XCTAssertNil(searchResult, @"searchResult should be nil");
            
        }];
    }];
}

- (void)test5 {
    NSString * term = @"cafe";
    NSString * location = @"0,0";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term cll:location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(searchResult, @"searchResult should be nil");
            
        }];
    }];
}

- (void)test6 {
    NSString * term = @"cafe";
    NSString * location = nil;
    // automatically change to toronto
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term location: location completionHandler:^(NSArray *searchResult, NSError * error){
            XCTAssertNil(error, @"searchResult should be nil");
            if(error){
                NSLog(@"queryTopBusinessInfoForTerm: %@",error.description);
            }
            NSUInteger count = searchResult.count;
            XCTAssertEqual(count, 10, @"search should be 10 stores");
            
        }];
    }];
}


- (void)test7 {
    NSString * storeID = @"chromatic-coffee-santa-clara";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryBusinessInfoForBusinessId:storeID completionHandler:^(NSDictionary *dataDic, NSError *error){
            XCTAssertNil(error, @"error should be nil");
            XCTAssertNotNil(dataDic, @"dataDic should not be nil");
        }];
    }];
}

- (void)test8 {
    NSString * storeID = @"makeup";
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryBusinessInfoForBusinessId:storeID completionHandler:^(NSDictionary *dataDic, NSError *error){
            XCTAssertNotNil(error, @"error should not be nil");
            XCTAssertNil(dataDic, @"dataDic should be nil");
        }];
    }];
}

- (void)test9 {
    NSString * storeID = nil;
    [self measureBlock:^{
        [[YRSearchManager sharedInstance] queryBusinessInfoForBusinessId:storeID completionHandler:^(NSDictionary *dataDic, NSError *error){
            XCTAssertNotNil(error, @"error should not be nil");
            XCTAssertNil(dataDic, @"dataDic should be nil");
        }];
    }];
}

@end
