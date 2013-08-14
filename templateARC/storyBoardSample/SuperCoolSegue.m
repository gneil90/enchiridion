//
//  SuperCoolSegue.m
//  templateARC
//
//  Created by Mac Owner on 2/12/13.
//
//
#import <CoreGraphics/CoreGraphics.h>
#import "SuperCoolSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation SuperCoolSegue
//iOS 5 by Tutorials Chapter 5: Intermediate Storyboards
//raywenderlich.com Page 199
//The trick is to make a snapshot of the new view controller’s view hierarchy before
//starting the animation, which gives you a UIImage with the contents of the screen,
//and then animate that UIImage. It’s possible to do the animation directly on the
//actual views but that may be slower and it doesn’t always give the results you
//would expect. Built-in controllers such as the navigation controller don’t lend
//themselves very well to these kinds of manipulations.
//You add that UIImage as a temporary subview to the Tab Bar Controller, so that it
//will be drawn on top of everything else. The initial state of the image view is scaled,
//rotated, and outside of the visible screen, so that it will appear to tumble into view
//when the animation starts.
//After the animation is done, you remove the image view again and properly present
//the view controller. This transition from the image to the actual view is seamless
//and unnoticeable to the user because they both contain the same contents.
//Give it a whirl. If you don’t think this animation is cool enough, then have a go at it
//yourself. See what kind of effects you can come up with... It can be a lot of fun to
//play with this stuff. If you also want to animate the source view controller to make
//it fly out of the screen, then I suggest you make a UIImage for that view as well.
//When you close the Ranking screen, it still uses the regular sink-to-the-bottom
//animation. It’s perfectly possible to perform a custom animation there as well, but
//remember that this transition is not a segue. The delegate is responsible for
//handling this, but the same principles apply. Set the animated flag to NO and do your
//own animation instead.

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
    CGAffineTransform scaleTransform =
    CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform rotateTransform =
    CGAffineTransformMakeRotation(M_PI);
    destinationImageView.transform =
    CGAffineTransformConcat(scaleTransform, rotateTransform);
    // Move the image outside the visible area
    CGPoint oldCenter = destinationImageView.center;
    CGPoint newCenter = CGPointMake(oldCenter.x - destinationImageView.bounds.size.width, oldCenter.y);
    destinationImageView.center = newCenter;
    // Start the animation
    [UIView animateWithDuration:0.5f delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void)
    {
        destinationImageView.transform =
        CGAffineTransformIdentity;
        destinationImageView.center = oldCenter;
    }
                     completion: ^(BOOL done)
    {
        // Remove the image as we no longer need it
        [destinationImageView removeFromSuperview];
        // Properly present the new screen
        [source addChildViewController:destination];
        [source.view addSubview:destination.view];
        //[source presentViewController:destination
                             //animated:NO completion:nil];
    }];
}
@end
