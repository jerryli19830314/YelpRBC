//
//  YRSearchManager.h
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol YRSearchManagerDelegate <NSObject>

-(void)didFinishLoadingImage:(UIImage *)image;

@end

@interface YRSearchManager : NSObject<CLLocationManagerDelegate>{
    NSMutableArray * imageQueue;
    NSMutableDictionary * imageDic;
    
    BOOL supportLocation;
    
}






+ (YRSearchManager *)sharedInstance;

- (void)queryTopBusinessInfoForTerm:(NSString *)term cll:(NSString *)cll completionHandler:(void (^)(NSArray * resultArray, NSError *error))completionHandler;

- (void)queryTopBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(NSArray * resultArray, NSError *error))completionHandler;

- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler;

- (void)downloadImageWithNSURLSession:(NSString *)urlString delegate:(id<YRSearchManagerDelegate>)delegate;

- (NSString *) getCurrentLocation;
- (void)startLocationService;

@end
