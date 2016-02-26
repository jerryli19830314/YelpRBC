//
//  YRSingleStoreViewController.m
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRSingleStoreViewController.h"
#import "YRSearchManager.h"
#import "YRReviewView.h"
#import "YRImageView.h"

@interface YRSingleStoreViewController ()

@end

static int const showReviewMax = 10;
static int const reviewPerPage = 2;
static int const showImageMax = 10;
static int const imagesperPage = 3;
static int const addressFontSize = 11;

@implementation YRSingleStoreViewController
@synthesize delegate;


-(void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    currentStoreID = nil;
    imageViewArray = [[NSMutableArray alloc] init];
    reviewViewArray = [[NSMutableArray alloc] init];
    
    toolBar = [[UIToolbar alloc] initWithFrame:
               CGRectMake(0,
                          0,
                          self.view.frame.size.width,
                          self.view.frame.size.height*0.12)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:toolBar];
    
    storeName = [[UILabel alloc] initWithFrame:
                 CGRectMake(toolBar.frame.size.width*0.25,
                            0,
                            toolBar.frame.size.width*0.5,
                            toolBar.frame.size.height)];
    storeName.backgroundColor = [UIColor clearColor];
    storeName.textColor = [UIColor whiteColor];
    storeName.textAlignment = NSTextAlignmentCenter;
    [toolBar addSubview:storeName];
    
    UIButton * modsLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, toolBar.frame.size.height*0.2,toolBar.frame.size.width*0.1, toolBar.frame.size.height*0.6)];
    [modsLabel setBackgroundImage:[UIImage imageNamed:@"back-icon"] forState:UIControlStateNormal];
    [modsLabel addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchDown];
    backButton= [[UIBarButtonItem alloc]initWithCustomView:modsLabel];
    
    NSArray *barItems = [NSArray arrayWithObjects:backButton,nil];
    [toolBar setItems:barItems animated:NO];
    
    imageScroll = [[UIScrollView alloc] initWithFrame:
                    CGRectMake(0,
                               toolBar.frame.origin.y + toolBar.frame.size.height,
                               self.view.frame.size.width,
                               100)];
    imageScroll.opaque = YES;
    imageScroll.pagingEnabled = YES;
    imageScroll.showsHorizontalScrollIndicator = YES;
    imageScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    imageScroll.showsVerticalScrollIndicator = NO;
    imageScroll.scrollsToTop = NO;
    imageScroll.clipsToBounds = YES;
    imageScroll.scrollEnabled = YES;
    imageScroll.directionalLockEnabled=YES;
    imageScroll.bouncesZoom = YES;
    imageScroll.delegate = self;
    imageScroll.bounces=YES;
    imageScroll.backgroundColor = [UIColor clearColor];
    imageScroll.contentSize = CGSizeMake(imageScroll.frame.size.width*2,
                                          imageScroll.frame.size.height);
    [self.view addSubview:imageScroll];
    
    double imagegap = imageScroll.frame.size.width/imagesperPage - imageScroll.frame.size.height;
    for(int i = 0; i < showImageMax ; i++){
        YRImageView * imageView = [[YRImageView alloc] initWithFrame:
                                 CGRectMake(imageScroll.frame.size.height*i + imagegap * i + imagegap * 0.5,
                                            0,
                                            imageScroll.frame.size.height,
                                            imageScroll.frame.size.height)];
        imageView.backgroundColor = [UIColor redColor];
        [imageScroll addSubview:imageView];
        [imageViewArray addObject:imageView];
        
    }
    
    
    storeInfoView = [[UIView alloc] initWithFrame:
                CGRectMake(0,
                           imageScroll.frame.origin.y + imageScroll.frame.size.height,
                           self.view.frame.size.width,
                           120)];
    storeInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:storeInfoView];
    
    storeAddressLabel = [[UILabel alloc] initWithFrame:
                                            CGRectMake(20,
                                                     0,
                                                     storeInfoView.frame.size.width-40,
                                                     storeInfoView.frame.size.height*0.7)];
    storeAddressLabel.numberOfLines = 6;
    storeAddressLabel.font = [UIFont systemFontOfSize:addressFontSize];
    storeAddressLabel.backgroundColor = [UIColor whiteColor];
    [storeInfoView addSubview:storeAddressLabel];
    
    storePhoneLabel = [[UILabel alloc] initWithFrame:
                 CGRectMake(storeAddressLabel.frame.origin.x,
                            storeAddressLabel.frame.origin.y + storeAddressLabel.frame.size.height,
                            storeAddressLabel.frame.size.width,
                            storeInfoView.frame.size.height - storeAddressLabel.frame.origin.y - storeAddressLabel.frame.size.height)];
    storePhoneLabel.font = [UIFont systemFontOfSize:addressFontSize];
    storePhoneLabel.backgroundColor = [UIColor whiteColor];
    storePhoneLabel.textColor = [UIColor blackColor];
    storePhoneLabel.textAlignment = NSTextAlignmentLeft;
    storePhoneLabel.numberOfLines = 2;
    storePhoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [storeInfoView addSubview:storePhoneLabel];
    
    reviewScroll = [[UIScrollView alloc] initWithFrame:
                        CGRectMake(0,
                                   storeInfoView.frame.origin.y + storeInfoView.frame.size.height,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height - storeInfoView.frame.origin.y - storeInfoView.frame.size.height)];
    reviewScroll.opaque = YES;
    reviewScroll.pagingEnabled = YES;
    reviewScroll.showsHorizontalScrollIndicator = NO;
    reviewScroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    reviewScroll.showsVerticalScrollIndicator = YES;
    reviewScroll.scrollsToTop = NO;
    reviewScroll.clipsToBounds = YES;
    reviewScroll.scrollEnabled = YES;
    reviewScroll.directionalLockEnabled=YES;
    reviewScroll.bouncesZoom = YES;
    reviewScroll.bounces=YES;
    reviewScroll.backgroundColor = [UIColor clearColor];
    reviewScroll.delegate = self;
    reviewScroll.contentSize = CGSizeMake(reviewScroll.frame.size.width,
                                        reviewScroll.frame.size.height);
    [self.view addSubview:reviewScroll];
    
    for(int i = 0; i < showReviewMax ; i++){
        YRReviewView * review = [[YRReviewView alloc] initWithFrame:
                                 CGRectMake(0,
                                            reviewScroll.frame.size.height*i/reviewPerPage,
                                            reviewScroll.frame.size.width,
                                            reviewScroll.frame.size.height/reviewPerPage)];
        review.tag = i;
        [reviewScroll addSubview:review];
        [reviewViewArray addObject:review];
        
    }
}

-(void)showWithUpdateData:(NSString *)storeID{
    if(!storeID || storeID.length == 0){
        return;
    }
    if(currentStoreID && storeID && storeID.length > 0 && [currentStoreID isEqualToString:storeID]){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.view.alpha = 1;
        [UIView commitAnimations];
        return;
    }
    
    if(self.delegate){
        [self.delegate didStartLoading];
    }
    
    [[YRSearchManager sharedInstance] queryBusinessInfoForBusinessId:storeID completionHandler:^(NSDictionary *dataDic, NSError *error){
        //NSLog(@"%@",dataDic);
        if(![NSThread isMainThread]){
            [self performSelectorOnMainThread:@selector(updateData:) withObject:dataDic waitUntilDone:NO];
            return ;
        }
        [self updateData:dataDic];
        
    }];
    
}

-(void)updateData:(NSDictionary *) dataDic{
    
    NSString * storeid = [dataDic objectForKey:@"id"];
    currentStoreID = storeid;
    storeName.text = [dataDic objectForKey:@"name"];
    
    NSDictionary * locationDic = [dataDic objectForKey:@"location"];
    if(locationDic && [locationDic valueForKey:@"display_address"]){
        NSArray * addressArray = [locationDic objectForKey:@"display_address"];
        if(addressArray){
            storeAddressLabel.text = @"Address:\n";
            for(int i = 0 ; i < addressArray.count;i++){
                storeAddressLabel.text = [storeAddressLabel.text stringByAppendingFormat:@"%@\n",[addressArray objectAtIndex:i]];
            }
        }
    }else{
        storeAddressLabel.text = @"";
    }
    NSString * display_phone = [dataDic objectForKey:@"display_phone"];
    if(display_phone && display_phone.length > 0){
        storePhoneLabel.text = [NSString stringWithFormat:@"Phone:\n%@",display_phone];
    }else{
        storePhoneLabel.text = @"";
    }
    
    
    NSString * review_count = [dataDic objectForKey:@"review_count"];
    int reviewCount = showReviewMax;
    if(review_count){
        reviewCount = review_count.intValue;
    }
    NSArray * reviews = [dataDic objectForKey:@"reviews"];
    
    
    NSMutableArray * reviewCopys = [reviews mutableCopy];
    
    // make review over 10, just for test. comment when building
    while (reviewCopys && reviewCopys.count < 10){
        [reviewCopys addObjectsFromArray:reviews];
    }
    // end test
    
    //sort by time created
    [reviewCopys sortUsingComparator:^(NSDictionary * obj1, NSDictionary * obj2){
        NSString * time_created1 = [obj1 objectForKey:@"time_created"];
        NSString * time_created2 = [obj2 objectForKey:@"time_created"];
        if(!time_created1){
            return (NSComparisonResult)NSOrderedDescending;
        }
        if(!time_created2){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if(time_created1.doubleValue >= time_created2.doubleValue){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
        
    }];
    reviews = reviewCopys;
    
    
    if(reviews){
        int i = 0;
        for( ; i < showReviewMax && i < reviews.count && i < reviewCount; i++){
            NSDictionary * review = [reviews objectAtIndex:i];
            YRReviewView * reviewView = [reviewViewArray objectAtIndex:i];
            [reviewView updateReview:review];
        }
        int reviewPages = (i+reviewPerPage-1)/reviewPerPage;
        reviewScroll.contentSize = CGSizeMake(reviewScroll.frame.size.width,
                                              reviewScroll.frame.size.height*reviewPages);
        for(;i < reviewViewArray.count;i++){
            YRReviewView * reviewView = [reviewViewArray objectAtIndex:i];
            [reviewView updateReview:nil];
        }
    }
    [reviewScroll scrollRectToVisible:
     CGRectMake(0,
                0,
                reviewScroll.frame.size.width,
                reviewScroll.frame.size.height)
                             animated:YES];
    
    NSString * imageURL = [dataDic objectForKey:@"image_url"];
    if(imageURL && imageURL.length > 0){
        int i = 0 ;
        
        // yelp api only return 1 iamge, for the better looking, show 10 images at same url
        // in future when yelp support multiple images, it need few changes
        for(; i < showImageMax && i < imageViewArray.count; i++){
            YRImageView * imageView = [imageViewArray objectAtIndex:i];
            [imageView updateImageFromURL:imageURL];
        }
        
        int imagePages = (showImageMax + imagesperPage -1)/imagesperPage;
        imageScroll.contentSize = CGSizeMake(imageScroll.frame.size.width * imagePages,
                                             imageScroll.frame.size.height);
        for(; i < imageViewArray.count; i++){
            YRImageView * imageView = [imageViewArray objectAtIndex:i];
            [imageView updateImageFromURL:nil];
        }
    }
    [imageScroll scrollRectToVisible:
     CGRectMake(0,
                0,
                imageScroll.frame.size.width,
                imageScroll.frame.size.height)
                            animated:YES];
    self.view.alpha = 1;
    if(self.delegate){
        [self.delegate didFinishLoading];
    }
    
}

-(void)pressBack{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)didFinishLoadingImage:(UIImage *)image{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
