//
//  YRReviewView.m
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-25.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRReviewView.h"

static int const userFontSize = 12;
@implementation YRReviewView

@synthesize rating;
@synthesize time_create;

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        userLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(10,
                                      2,
                                      self.frame.size.width*0.5 -10,
                                      self.frame.size.height*0.2)];
        userLabel.font = [UIFont systemFontOfSize:userFontSize];
        userLabel.backgroundColor = [UIColor clearColor];
        userLabel.textColor = [UIColor blackColor];
        userLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:userLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:
                           CGRectMake(userLabel.frame.origin.x + userLabel.frame.size.width,
                                      userLabel.frame.origin.y,
                                      self.frame.size.width - userLabel.frame.size.width-userLabel.frame.origin.x*2,
                                      userLabel.frame.size.height)];
        dateLabel.font = [UIFont systemFontOfSize:userFontSize];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dateLabel];
        
        ratingLabel = [[UILabel alloc] initWithFrame:
                     CGRectMake(userLabel.frame.origin.x ,
                                userLabel.frame.origin.y + userLabel.frame.size.height,
                                self.frame.size.width - userLabel.frame.origin.x*2,
                                userLabel.frame.size.height)];
        ratingLabel.font = [UIFont systemFontOfSize:userFontSize];
        ratingLabel.backgroundColor = [UIColor clearColor];
        ratingLabel.textColor = [UIColor blackColor];
        ratingLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:ratingLabel];
        
        reviewLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(ratingLabel.frame.origin.x ,
                                  ratingLabel.frame.origin.y + ratingLabel.frame.size.height,
                                  self.frame.size.width - userLabel.frame.origin.x*2,
                                  self.frame.size.height - ratingLabel.frame.origin.y - ratingLabel.frame.size.height)];
        reviewLabel.font = [UIFont systemFontOfSize:userFontSize];
        reviewLabel.backgroundColor = [UIColor clearColor];
        reviewLabel.textColor = [UIColor blackColor];
        reviewLabel.textAlignment = NSTextAlignmentLeft;
        reviewLabel.numberOfLines = 6;
        [self addSubview:reviewLabel];
        
        
    }
    return self;
}

-(void)updateReview:(NSDictionary *)dataDic{
    if(!dataDic){
        userLabel.text = @"";
        dateLabel.text = @"";
        ratingLabel.text = @"";
        reviewLabel.text = @"";
        rating = 0;
        time_create = 0;
        return;
    }
    
    NSDictionary * userInfo = [dataDic objectForKey:@"user"];
    if(userInfo && userInfo.count > 0){
        NSString * user = [userInfo objectForKey:@"name"];
        if(user){
            userLabel.text = [NSString stringWithFormat:@"%d. %@",(int)self.tag+1, user];
        }else{
            userLabel.text = @"";
        }
        
    }else{
        userLabel.text = @"";
    }
    
    NSString * dateString = [dataDic valueForKey:@"time_created"];
    if(dateString){
        time_create = dateString.doubleValue;
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:time_create];
        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateLabel.text = [dateFormat stringFromDate:date];
    }else{
        dateLabel.text = @"";
    }

    
    NSString * ratingstring = [dataDic valueForKey:@"rating"];
    if(ratingstring){
        rating = ratingstring.doubleValue;
        ratingLabel.text = [NSString stringWithFormat:@"Rate: %@",ratingstring];
    }else{
        ratingLabel.text = @"";
    }
    
    NSString * excerpt = [dataDic objectForKey:@"excerpt"];
    if(excerpt){
        reviewLabel.text = [NSString stringWithFormat:@"Review:\n%@",excerpt];
    }else{
        reviewLabel.text = @"";
    }
    
}

@end
