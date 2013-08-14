//
//  CirceMonthView.m
//  templateARC
//
//  Created by Mac Owner on 3/24/13.
//
//

#import "CirceMonthView.h"

#import <QuartzCore/QuartzCore.h>

@implementation CirceMonthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.imageCircle=[self createImage];
    }
    return self;
}

-(UIImage*)createImage
{
    CGSize size=self.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    self.brush=0.6;
    
    CGRect frameOfCircle=CGRectMake(self.brush/2,self.brush/2, self.frame.size.width-self.brush-1.0f, self.frame.size.height-self.brush);
    // Draw a circle (border only)
    CGContextSetLineWidth(contextRef, self.brush);
    CGFloat mainColor[4]={23.0f/255.0f, 12.0f/255.0f, 0.0f, 0.5};
    CGContextSetStrokeColor(contextRef, mainColor);
    CGContextStrokeEllipseInRect(contextRef, frameOfCircle);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    

    return image;
    
}



@end

