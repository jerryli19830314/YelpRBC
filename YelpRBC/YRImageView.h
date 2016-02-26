//
//  YRImageView.h
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-25.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSearchManager.h"

@interface YRImageView : UIImageView<YRSearchManagerDelegate>

-(void)updateImageFromURL:(NSString *)url;

@end
