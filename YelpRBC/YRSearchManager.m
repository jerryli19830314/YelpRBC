//
//  YRSearchManager.m
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRSearchManager.h"
#import "TDOAuth.h"
#import "NSURLRequest+OAuth.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


static YRSearchManager *myManager = nil;
static CLLocationManager *locationManager = nil;

static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"10";
static int const maxImages = 100;

@implementation YRSearchManager


#pragma mark -
#pragma mark location service
#pragma mark


-(void)startLocationService{
    if(!locationManager){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        locationManager.delegate = self;
        [locationManager requestWhenInUseAuthorization];
        //[locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

}

-(NSString *) getCurrentLocation{
    if(!locationManager.locationServicesEnabled){
        return nil;
    }
    [locationManager requestLocation];

    NSString * result = [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return result;
}

-(NSString *)getAddressFromCll:(NSString *)cll{
    if(cll && [cll containsString:@","]){

        // use google map API to get address
        NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&sensor=false",cll];
        NSError* error = nil;
 
        NSDictionary *locationDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]] options:0 error:&error];
        if(locationDic){
            NSArray * resultArray = [locationDic objectForKey:@"results"];
            if(resultArray && resultArray.count > 0){
                NSDictionary * standardAddress = [resultArray objectAtIndex:0];
                if(standardAddress){
                    NSString * formatted_address = [standardAddress objectForKey:@"formatted_address"];
                    if(formatted_address){
                        return formatted_address;
                    }
                }
            }
        }
    }
    return @"Toronto";
    
}

#pragma mark -
#pragma mark API and image downlaod
#pragma mark

-(void)downloadImageWithNSURLSession:(NSString *)urlString delegate:(id<YRSearchManagerDelegate>)delegate{
    if(!delegate){
        return;
    }
    if(delegate){
        [delegate didFinishLoadingImage:nil];
    }
    
    //search local first
    UIImage * queueImage = [imageDic objectForKey:urlString];
    if(queueImage ){
        [delegate didFinishLoadingImage:queueImage];
        return;
    }
    //
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        if(downloadedImage){
            // cache some images
            if(imageQueue.count >= maxImages){
                NSString * key = [imageQueue objectAtIndex:0];
                [imageDic removeObjectForKey:key];
                [imageQueue removeObjectAtIndex:0];
            }
            [imageQueue addObject:urlString];
            [imageDic setObject:downloadedImage forKey:urlString];
        }
        if(delegate){
            [delegate didFinishLoadingImage:downloadedImage];
        }
    }];
    [downloadPhotoTask resume];
}

//modified the sample code from yelp
- (void)queryTopBusinessInfoForTerm:(NSString *)term cll:(NSString *)cll completionHandler:(void (^)(NSArray * resultArray, NSError *error))completionHandler {
    NSString * location = [self getAddressFromCll:cll];
    NSLog(@"Querying the Search API with term \'%@\' ,location \'%@\'and cll \'%@'", term, location,cll);
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            NSLog(@"%@",businessArray);
            if ([businessArray count] > 0) {
                completionHandler(businessArray, error);
                //NSDictionary *firstBusiness = [businessArray firstObject];
                // NSString *firstBusinessID = firstBusiness[@"id"];
                NSLog(@"%lu businesses found", [businessArray count]);
                
                // [self queryBusinessInfoForBusinessId:firstBusinessID completionHandler:completionHandler];
            } else {
                completionHandler(nil, error); // No business was found
            }
        } else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}


//modified the sample code from yelp
- (void)queryTopBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(NSArray * resultArray, NSError *error))completionHandler {
    
    if(!term || term.length == 0){
        return;
    }
    if(!location || location.length == 0){
        return;
    }
    NSLog(@"Querying the Search API with term \'%@\' and location \'%@'", term, location);
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            NSLog(@"%@",businessArray);
            if ([businessArray count] > 0) {
                completionHandler(businessArray, error);
                //NSDictionary *firstBusiness = [businessArray firstObject];
               // NSString *firstBusinessID = firstBusiness[@"id"];
                NSLog(@"%lu businesses found", [businessArray count]);
                
               // [self queryBusinessInfoForBusinessId:firstBusinessID completionHandler:completionHandler];
            } else {
                completionHandler(nil, error); // No business was found
            }
        } else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

//modified sample code from yelp
- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler {
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
    [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            completionHandler(businessResponseJSON, error);
        } else {
            completionHandler(nil, error);
        }
    }] resume];
    
}


#pragma mark -
#pragma mark API Request Builders
#pragma mark

/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA
 
 @return The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

// may use in future;

- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term cll:(NSString *)cll location:(NSString *)location {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"cll": cll,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/**
 Builds a request to hit the business endpoint with the given business ID.
 
 @param businessID The id of the business for which we request informations
 
 @return The NSURLRequest needed to query the business info
 */
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {
    
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}



#pragma mark -
#pragma mark Singleton
#pragma mark

+ (YRSearchManager *)sharedInstance
{
    static YRSearchManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YRSearchManager alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if(self = [super init]){
        imageDic = [[NSMutableDictionary alloc] init];
        imageQueue = [[NSMutableArray alloc] init];
        supportLocation = NO;

    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (myManager == nil) {
            myManager = [super allocWithZone:zone];
            return myManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
