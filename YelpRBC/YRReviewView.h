//
//  YRReviewView.h
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-25.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRReviewView : UIView{
    UILabel * userLabel;
    UILabel * dateLabel;
    UILabel * ratingLabel;
    UILabel * reviewLabel;
}

@property(readonly)double rating;
@property(readonly)double time_create;

-(void)updateReview:(NSDictionary *)dataDic;

@end
