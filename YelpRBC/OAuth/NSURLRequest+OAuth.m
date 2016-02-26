//
//  NSURLRequest+OAuth.m
//  YelpAPISample
//
//  Created by Thibaud Robelain on 7/2/14.
//  Copyright (c) 2014 Yelp Inc. All rights reserved.


//  Modified by Jerry Li on 2016/02/23

#import "NSURLRequest+OAuth.h"

#import "TDOAuth.h"

/**
 OAuth credential placeholders that must be filled by each user in regards to
 http://www.yelp.com/developers/getting_started/api_access
 */

#pragma mark - Fill in the API keys below with your developer v2 keys.
static NSString * const kConsumerKey       = @"G3iBmzpprkYSKw2FF1pWlQ";
static NSString * const kConsumerSecret    = @"6XJeb-cy_cyDVodM3qmicpD1B9g";
static NSString * const kToken             = @"ztjqub6bFoLc9B-0iuut1NKlnl6jKkym";
static NSString * const kTokenSecret       = @"2dui90Mx9U3hbyTZ1K_GMMYkxio";


@implementation NSURLRequest (OAuth)

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path {
  return [self requestWithHost:host path:path params:nil];
}

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
  if ([kConsumerKey length] == 0 || [kConsumerSecret length] == 0 || [kToken length] == 0 || [kTokenSecret length] == 0) {
    NSLog(@"WARNING: Please enter your api v2 credentials before attempting any API request. You can do so in NSURLRequest+OAuth.m");
  }

  return [TDOAuth URLRequestForPath:path
                      GETParameters:params
                             scheme:@"https"
                               host:host
                        consumerKey:kConsumerKey
                     consumerSecret:kConsumerSecret
                        accessToken:kToken
                        tokenSecret:kTokenSecret];
}

@end
