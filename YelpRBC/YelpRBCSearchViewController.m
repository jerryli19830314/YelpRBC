//
//  ViewController.m
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-23.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YelpRBCSearchViewController.h"
#import "YRSearchManager.h"
#import "YRSearchStoreView.h"

@interface YelpRBCSearchViewController ()

-(void)showSortList;

@end

static int labelFontSize = 12;

@implementation YelpRBCSearchViewController
@synthesize tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadView{
    [super loadView];
    tableData = nil;
    
    self.view.backgroundColor = [UIColor redColor];
    
    titleLabel = [[UILabel alloc] initWithFrame:
                  CGRectMake(0,
                            self.view.frame.size.height*0.01,
                            self.view.frame.size.width,
                            self.view.frame.size.height*0.05)];
    titleLabel.text = @"Yelp RBC";
    titleLabel.font = [UIFont boldSystemFontOfSize:titleLabel.frame.size.height/2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sortButton.frame = CGRectMake(0,
                                  titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                  self.view.frame.size.width*0.2,
                                  self.view.frame.size.height*0.06);
    [sortButton setTitle:@"Sort" forState:UIControlStateNormal];
    [sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sortButton.titleLabel.font = [UIFont systemFontOfSize:labelFontSize];
    [sortButton addTarget:self action:@selector(showSortList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortButton];
    
    
    mainSearchBar = [[UISearchBar alloc] initWithFrame:
                     CGRectMake(sortButton.frame.size.width,
                                titleLabel.frame.origin.y + titleLabel.frame.size.height,
                                self.view.frame.size.width - sortButton.frame.size.width,
                                self.view.frame.size.height*0.06)];
    mainSearchBar.delegate = self;
    mainSearchBar.barTintColor = [UIColor redColor];
    mainSearchBar.placeholder = @"eg.Cafe,delivery";
    [self.view addSubview:mainSearchBar];
    
    
    locationLabel = [[UILabel alloc] initWithFrame:
                  CGRectMake(0,
                             mainSearchBar.frame.origin.y + mainSearchBar.frame.size.height,
                             sortButton.frame.size.width,
                             mainSearchBar.frame.size.height)];
    locationLabel.text = @"Location";
    locationLabel.font = [UIFont systemFontOfSize:labelFontSize];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.backgroundColor = [UIColor redColor];
    
    
    locationSearchBar = [[UISearchBar alloc] initWithFrame:
                     CGRectMake(sortButton.frame.size.width,
                                mainSearchBar.frame.origin.y + mainSearchBar.frame.size.height,
                                mainSearchBar.frame.size.width,
                                mainSearchBar.frame.size.height)];
    locationSearchBar.delegate = self;
    locationSearchBar.barTintColor = [UIColor redColor];
    locationSearchBar.placeholder = @"eg. address,city,post code";
    
    
    resultScrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake(0,
                                  mainSearchBar.frame.origin.y + mainSearchBar.frame.size.height,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height*0.85)];
    resultScrollView.opaque = YES;
    resultScrollView.pagingEnabled = NO;
    resultScrollView.showsHorizontalScrollIndicator = NO;
    resultScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    resultScrollView.showsVerticalScrollIndicator = YES;
    resultScrollView.scrollsToTop = NO;
    resultScrollView.clipsToBounds = YES;
    resultScrollView.scrollEnabled = YES;
    resultScrollView.directionalLockEnabled=YES;
    resultScrollView.bouncesZoom = YES;
    resultScrollView.bounces=YES;
    resultScrollView.backgroundColor = [UIColor clearColor];
    resultScrollView.delegate = self;
    resultScrollView.contentSize = CGSizeMake(resultScrollView.frame.size.width,
                                              resultScrollView.frame.size.height*2);
    [self.view addSubview:resultScrollView];
    
    storeViewArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < 10; i++){
        YRSearchStoreView * storeView = [[YRSearchStoreView alloc] initWithFrame:
                                         CGRectMake(1,
                                                    i*resultScrollView.frame.size.height*0.2,
                                                    resultScrollView.frame.size.width,
                                                    resultScrollView.frame.size.height*0.2-2)];
        storeView.delegate = self;
        storeView.alpha = 0;
        [resultScrollView addSubview:storeView];
        [storeViewArray addObject:storeView];
    }
    
    [self.view addSubview:locationLabel];
    [self.view addSubview:locationSearchBar];
    
    singleStoreViewController = [[YRSingleStoreViewController alloc] initWithNibName:nil bundle:nil];
    singleStoreViewController.view.frame = self.view.frame;
    singleStoreViewController.delegate = self;
    singleStoreViewController.view.alpha = 0;
    [self.view addSubview:singleStoreViewController.view];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height)];
    loadingView.backgroundColor = [UIColor redColor];
    [self.view addSubview:loadingView];
    
    UILabel * loadingLabel = [[UILabel alloc] initWithFrame:
                                            CGRectMake(0,
                                                       loadingView.frame.size.height * 0.32,
                                                       loadingView.frame.size.width,
                                                       50)];
    loadingLabel.text = @"LOADING";
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:18];
    [loadingView addSubview:loadingLabel];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,
                                                                                  0,
                                                                                  50,
                                                                                  50)];
    activityIndicator.center = loadingView.center;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView addSubview:activityIndicator];
    
    sortAlert = [UIAlertController
                        alertControllerWithTitle:@"Sort"
                        message:@""
                        preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    UIAlertAction* sortByRatingAction = [UIAlertAction
                                   actionWithTitle:@"Sort By Rating"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self sortResultByType:@"RATING"];
                                   }];
 
    UIAlertAction* sortByDistanceAction = [UIAlertAction
                                         actionWithTitle:@"Sort By Distance"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                         [self sortResultByType:@"DISTANCE"];
                                         }];
    
    
    [sortAlert addAction:sortByRatingAction];
    [sortAlert addAction:sortByDistanceAction];
    [sortAlert addAction:cancelAction];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    locationLabel.alpha = 0;
    locationSearchBar.alpha = 0;
    loadingView.alpha = 0;
    singleStoreViewController.view.alpha = 0;
    
}




- (void)didStartLoading{
    loadingView.alpha = 1;
    [activityIndicator startAnimating];
}


- (void)didFinishLoading{
    [activityIndicator stopAnimating];
    loadingView.alpha = 0;
}



-(void)showSortList{
    [self presentViewController:sortAlert animated:YES completion:nil];
}

-(void)sortResultByType:(NSString *)type{
    if(!type){
        return;
    }
    if([type isEqualToString:@"RATING"]){
        [storeViewArray sortUsingComparator:^(YRSearchStoreView * obj1, YRSearchStoreView * obj2){
            if(obj1.rating >= obj2.rating){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedDescending;
            
        }];
    }else if ([type isEqualToString:@"DISTANCE"]){
        [storeViewArray sortUsingComparator:^(YRSearchStoreView * obj1, YRSearchStoreView * obj2){
            if(obj1.distance >= obj2.distance){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedDescending;
            
        }];
    }
    
    for(int i = 0; i < storeViewArray.count; i++){
        YRSearchStoreView * storeView = [storeViewArray objectAtIndex:i];
        storeView.frame = CGRectMake(1,
                                   i*resultScrollView.frame.size.height*0.2,
                                   resultScrollView.frame.size.width,
                                     resultScrollView.frame.size.height*0.2-2);
    }
    [resultScrollView scrollRectToVisible:CGRectMake(0,
                                                    0,
                                                    resultScrollView.frame.size.width,
                                                    resultScrollView.frame.size.height)
                                 animated:YES];
}


-(void)updateResult:(NSArray *)searchResult{
    if(!searchResult){
        NSLog(@"No results!");
        return;
    }
    for(int i = 0 ; i < 10; i++){
        YRSearchStoreView * storeView = [storeViewArray objectAtIndex:i];
        if(i < searchResult.count){
            [storeView updateData:[searchResult objectAtIndex:i]];
        }else{
            [storeView updateData:nil];
        }
    }
    [resultScrollView becomeFirstResponder];
    [self didFinishLoading];
}

#pragma mark -
#pragma mark YRSearchDelegate
#pragma mark

-(void)loadSingleStoreView:(NSString *)storeID{
    NSLog(@"StoreID %@ :OK",storeID);
    [singleStoreViewController showWithUpdateData:storeID];
    
}

#pragma mark -
#pragma mark UISearchBarDelegate
#pragma mark
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self didStartLoading];
    [searchBar resignFirstResponder];
    locationLabel.alpha = 0;
    locationSearchBar.alpha = 0;
    
    NSString * term = mainSearchBar.text;
    if(!term || [term stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        term = @"Cafe";
    }
    
    NSString * location = locationSearchBar.text;
    if(!location || [location stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        NSString * cll = [[YRSearchManager sharedInstance] getCurrentLocation];
        if(cll && [cll containsString:@","]){
            [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term cll:cll completionHandler:^(NSArray *searchResult, NSError * error){
                if(error){
                    NSLog(@"queryTopBusinessInfoForTerm: %@",error.description);
                }
                if(![NSThread isMainThread]){
                    [self performSelectorOnMainThread:@selector(updateResult:) withObject:searchResult waitUntilDone:NO];
                    return ;
                }
                [self updateResult:searchResult];
                
            }];
            return;
        }
        
        location = @"Toronto";
    }
    [[YRSearchManager sharedInstance] queryTopBusinessInfoForTerm:term location: location completionHandler:^(NSArray *searchResult, NSError * error){
        if(error){
            NSLog(@"queryTopBusinessInfoForTerm: %@",error.description);
        }
        if(![NSThread isMainThread]){
            [self performSelectorOnMainThread:@selector(updateResult:) withObject:searchResult waitUntilDone:NO];
            return ;
        }
        [self updateResult:searchResult];

    }];

}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if(searchBar == mainSearchBar){
        locationLabel.alpha = 1;
        locationSearchBar.alpha = 1;
    }
    return YES;
}



@end
