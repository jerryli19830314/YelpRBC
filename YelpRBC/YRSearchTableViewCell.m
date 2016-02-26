//
//  YRSearchTableViewCell.m
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRSearchTableViewCell.h"

#import <UIKit/UIKit.h>
#import "YRSearchTableViewCellView.h"

@implementation YRSearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.contentView.opaque = YES;
        cellView = [[YRSearchTableViewCellView alloc] initWithFrame:frame];
        [self.contentView addSubview:cellView];

    }
    
    return self;
}

-(void)updateData:(NSMutableDictionary *)dataDic{

    [cellView updateData:dataDic];
}

@end
