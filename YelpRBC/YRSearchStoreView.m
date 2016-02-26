//
//  YRSearchTableViewCellView.m
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRSearchStoreView.h"
#import <UIKit/UIKit.h>
#import "YRSearchManager.h"

@interface YRSearchStoreView ()


@end

@implementation YRSearchStoreView

@synthesize delegate;
@synthesize rating;
@synthesize distance;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        storeID = nil;
        storeImageView = [[UIImageView alloc] initWithFrame:
                          CGRectMake(0,
                                     5,
                                     self.frame.size.width*0.32,
                                     self.frame.size.height-10)];
        [self addSubview:storeImageView];
        
        storeName = [[UILabel alloc] initWithFrame:
                     CGRectMake(storeImageView.frame.size.width+2,
                                1,
                                self.frame.size.width - storeImageView.frame.size.width-4,
                                self.frame.size.height*0.25-2)];
        storeName.textAlignment = NSTextAlignmentLeft;
        storeName.textColor = [UIColor blackColor];
        storeName.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:storeName];
        
        ratingLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(storeImageView.frame.size.width+2,
                                storeName.frame.origin.y + storeName.frame.size.height + 2,
                                (self.frame.size.width - storeImageView.frame.size.width)*0.5-4,
                                self.frame.size.height*0.25-2)];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        ratingLabel.textColor = [UIColor blackColor];
        ratingLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:ratingLabel];
        
        distanceLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(ratingLabel.frame.origin.x + ratingLabel.frame.size.width+2,
                                storeName.frame.origin.y + storeName.frame.size.height + 2,
                                (self.frame.size.width - storeImageView.frame.size.width)*0.5-4,
                                self.frame.size.height*0.25-2)];
        distanceLabel.textAlignment = NSTextAlignmentLeft;
        distanceLabel.textColor = [UIColor blackColor];
        distanceLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:distanceLabel];
        
        reviewLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(storeImageView.frame.size.width+2,
                                ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 2,
                                self.frame.size.width - storeImageView.frame.size.width-4,
                                self.frame.size.height*0.5-2)];
        reviewLabel.textAlignment = NSTextAlignmentLeft;
        reviewLabel.textColor = [UIColor blackColor];
        reviewLabel.lineBreakMode = NSLineBreakByWordWrapping;
        reviewLabel.numberOfLines = 3;
        reviewLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:reviewLabel];
        
        
        
        rating = 0;
        distance = 0;
        
        
    }
    return self;
}


-(void)updateData:(NSMutableDictionary *)dataDic{

    if(!dataDic){
        self.alpha = 0;
        return;
    }
    storeID = [dataDic objectForKey:@"id"];
    if(!storeID || storeID.length == 0){
        self.alpha = 0;
        return;
    }
    self.alpha = 1;
    NSString * nameString = [dataDic objectForKey:@"name"];
    if(nameString && nameString.length > 0){
        storeName.text = nameString;
    }else{
        storeName.text = @"Unknown";
    }
    storeImageView.alpha = 0;
    
    NSString * ratingString = [dataDic valueForKey:@"rating"];
    if(ratingString){
        rating = ratingString.doubleValue;
        ratingLabel.text = [NSString stringWithFormat:@"Rating: %.1f",self.rating];
    }
    
    
    NSDictionary * locationDic = [dataDic objectForKey:@"location"];
    if(locationDic && [locationDic valueForKey:@"geo_accuracy"]){
        NSString * accuracyString = [locationDic valueForKey:@"geo_accuracy"];
        if(accuracyString){
            distance = accuracyString.doubleValue;
            distanceLabel.text = [NSString stringWithFormat:@"Distance: %.1f",distance];
        }
    }
    
    NSString * snippet_text = [dataDic valueForKey:@"snippet_text"];
    if(snippet_text && snippet_text.length > 0){
        reviewLabel.text = snippet_text;
    }
    
    
    NSString * imageURL = [dataDic objectForKey:@"image_url"];
    if(imageURL){
        [[YRSearchManager sharedInstance]  downloadImageWithNSURLSession:imageURL delegate:self];
        
    }
    
}

-(void)didFinishLoadingImage:(UIImage *)image{
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        return;
    }
    [self updateImage:image];
    
    
}

-(void)updateImage:(UIImage *)image{
    [storeImageView setImage:image];
    storeImageView.alpha = 1;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(delegate){
        [delegate loadSingleStoreView:storeID];
    }
}


@end
