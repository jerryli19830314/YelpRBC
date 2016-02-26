//
//  YRSingleStoreViewController.h
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSearchManager.h"

@protocol YRSingleStoreDelegate <NSObject>

- (void)didStartLoading;
- (void)didFinishLoading;

@end

@interface YRSingleStoreViewController : UIViewController<YRSearchManagerDelegate,UIScrollViewDelegate>{
    UIToolbar * toolBar;
    UIBarButtonItem * backButton;
    UILabel * storeName;
    
    UIScrollView * imageScroll;
    NSMutableArray * imageViewArray;
    
    UIView * storeInfoView;
    UILabel * storeAddressLabel;
    UILabel * storePhoneLabel;
    
    UIScrollView * reviewScroll;
    NSMutableArray * reviewViewArray;
    
    NSString * currentStoreID;
}

@property(nonatomic,weak)id<YRSingleStoreDelegate>delegate;

-(void)showWithUpdateData:(NSString *)storeIDs;

@end
