//
//  MyZoomOutSegue.m
//  templateARC
//
//  Created by Mac Owner on 3/14/13.
//
//

#import "MyZoomOutSegue.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "MainMapZoomOutViewController.h"
#import "CombinedViewController.h"

@implementation MyZoomOutSegue
-(void)perform
{
    UIViewController *source = self.sourceViewController;
    __weak __block CombinedViewController *parentViewController=(CombinedViewController*)[self.sourceViewController parentViewController];
    MainMapZoomOutViewController *destination =self.destinationViewController;
    /*
    // Create a UIImage with the contents of the destination
    UIGraphicsBeginImageContext(destination.view.bounds.size);
    [destination.view.layer renderInContext:
     UIGraphicsGetCurrentContext()];
    UIImage *destinationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Add this image as a subview to the tab bar controller
    UIImageView *destinationImageView = [[UIImageView alloc]
                                         initWithImage:destinationImage];
    
    [source.view addSubview:destinationImageView];
    // Scale the image down and rotate it 180 degrees
    // (upside down)
     CGAffineTransform rotateTransform =
    source.view.transform;
    destinationImageView.transform =
    CGAffineTransformConcat(scaleTransform, rotateTransform);
    // Move the image outside the visible area
    destinationImageView.alpha=0.0f;
    CGPoint oldCenter = source.view.center;
        destinationImageView.center = oldCenter;
    // Start the animation
     */
    //destination.view.alpha=0.0;
    CGRect newFrame=destination.view.frame;
    newFrame.origin=CGPointMake(186.0f, -3.0f);
    destination.view.frame=newFrame;
    
    CGRect b=destination.view.bounds;
    b.origin=CGPointMake(b.origin.x-450.0f, b.origin.y-450.0f);
    b.size=CGSizeMake(b.size.width+900, b.size.height+900);
    destination.view.bounds=b;
 

    
    
}
@end
