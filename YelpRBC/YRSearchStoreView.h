//
//  YRSearchTableViewCellView.h
//  YelpRBC
//
//  Created by Jerry Li on 2016-02-24.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRSearchStoreView : UIView{
    UIImageView * storeImageView;
    UILabel * storeName;
}

-(void)updateData:(NSMutableDictionary *)dataDic;

@end
