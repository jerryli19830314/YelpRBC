//
//  YRImageView.m
//  YelpRBC
//
//  Created by Ruilin Li on 2016-02-25.
//  Copyright © 2016 Ruilin Li. All rights reserved.
//

#import "YRImageView.h"

@implementation YRImageView


-(void)updateImageFromURL:(NSString *)url{
    if(!url){
        self.alpha = 0;
        return;
    }
    [[YRSearchManager sharedInstance] downloadImageWithNSURLSession:url delegate:self];
}

-(void)didFinishLoadingImage:(UIImage *)image{
    if(![NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];
        return;
    }
    [self updateImage:image];
    
    
}

-(void)updateImage:(UIImage *)image{
    [self setImage:image];
    self.alpha = 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
