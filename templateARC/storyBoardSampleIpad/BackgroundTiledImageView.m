//
//  BackgroundTiledImageView.m
//  templateARC
//
//  Created by Mac Owner on 3/30/13.
//
//

#import "BackgroundTiledImageView.h"

@implementation BackgroundTiledImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (self.tileImage) {
        
        //Since we are retaining the image, we append with ret_ref.  this reminds us to release at a later date.
        CGImageRef image_to_tile_ret_ref = CGImageRetain(self.tileImage.CGImage);
        
        CGRect image_rect;
        image_rect.size = self.tileImage.size;  //This sets the tile to the native size of the image.  Change this value to adjust the size of an indivitual "tile."
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetBlendMode(context, kCGBlendModeCopy);

        
        CGContextDrawTiledImage(context, image_rect, image_to_tile_ret_ref);
        

        
        CGImageRelease(image_to_tile_ret_ref);
    }
}

@end
