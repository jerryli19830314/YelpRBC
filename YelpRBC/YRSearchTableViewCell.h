//
//  YRSearchTableViewCell.h
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YRSearchTableViewCellView;

@interface YRSearchTableViewCell : UITableViewCell{
    YRSearchTableViewCellView * cellView;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
-(void)updateData:(NSMutableDictionary *)dataDic;

@end
