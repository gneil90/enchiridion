//
//  TranslationLeftToRight.m
//  templateARC
//
//  Created by Mac Owner on 2/13/13.
//
//

#import "TranslationLeftToRightSegue.h"
#import <QuartzCore/QuartzCore.h>
@implementation TranslationLeftToRightSegue

-(void)perform
{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination =
    self.destinationViewController;
    // Create a UIImage with the contents of the destination
    UIGraphicsBeginImageContext(destination.view.bounds.size);
    [destination.view.layer renderInContext:
     UIGraphicsGetCurrentContext()];
    UIImage *destinationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Add this image as a subview to the tab bar controller
    UIImageView *destinationImageView = [[UIImageView alloc]
                                         initWithImage:destinationImage];
    
    [source.parentViewController.view addSubview:destinationImageView];
    // Scale the image down and rotate it 180 degrees
    // (upside down)
    
    // Move the image outside the visible area
    CGPoint oldCenter = destinationImageView.center;
    CGPoint newCenter = CGPointMake(oldCenter.x - destinationImageView.bounds.size.width, oldCenter.y);
    destinationImageView.center = newCenter;
    // Start the animation
    [UIView animateWithDuration:0.5f delay:0
                        options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void)
     {
         //destinationImageView.transform =
         //CGAffineTransformIdentity;
         destinationImageView.center = oldCenter;
     }
                     completion: ^(BOOL done)
     {
         // Remove the image as we no longer need it
         [destinationImageView removeFromSuperview];
         // Properly present the new screen
         [source presentViewController:destination
                              animated:NO completion:nil];
     }];
}

@end
