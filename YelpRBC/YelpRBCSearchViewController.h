//
//  ViewController.h
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-23.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSearchStoreView.h"
#import "YRSingleStoreViewController.h"



@interface YelpRBCSearchViewController : UIViewController<UISearchBarDelegate,UIScrollViewDelegate,YRSearchDelegate,YRSingleStoreDelegate>{
    UILabel * titleLabel;
    
    UIButton * sortButton;
    UISearchBar * mainSearchBar;
    
    UILabel * locationLabel;
    UISearchBar * locationSearchBar;
    
    UIScrollView * resultScrollView;
    NSMutableArray * storeViewArray;
    
    YRSingleStoreViewController * singleStoreViewController;
    
    UIView * loadingView;
    UIActivityIndicatorView * activityIndicator;
    
    UIAlertController* sortAlert;
    
    
}

@property(nonatomic,strong) NSArray * tableData;


@end

