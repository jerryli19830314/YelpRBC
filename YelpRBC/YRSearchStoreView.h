//
//  YRSearchTableViewCellView.h
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSearchManager.h"

@protocol YRSearchDelegate <NSObject>

-(void)loadSingleStoreView:(NSString *)storeID;

@end

@interface YRSearchStoreView : UIView<YRSearchManagerDelegate>{
    NSString * storeID;
    UIImageView * storeImageView;
    UILabel * storeName;
    UILabel * ratingLabel;
    UILabel * distanceLabel;
    UILabel * reviewLabel;
}

@property(nonatomic,weak) id<YRSearchDelegate> delegate;
@property(readonly) double rating;
@property(readonly) double distance;


-(void)updateData:(NSMutableDictionary *)dataDic;

@end
