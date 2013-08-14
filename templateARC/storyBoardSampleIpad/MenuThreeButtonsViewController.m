//
//  MenuThreeButtonsViewController.m
//  templateARC
//
//  Created by Mac Owner on 6/15/13.
//
//

#import "MenuThreeButtonsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CombinedViewController.h"

@interface MenuThreeButtonsViewController ()

@end

@implementation MenuThreeButtonsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonMainMapZoomOutTapped:(id)sender
{
    if (!self.isButtonMainMapZoomOutDragged) {
        NSLog(@"buttonMainMapZoomOut Tapped");
        __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
        [weakParent backToMainMapZoomOutViewControllerFromMenuThreeButtons:nil];
               
    }
    else
    {
        NSLog(@"Let's go home button, you're drunk:)");
        [UIView animateWithDuration:0.4f animations:^{
            self.buttonMainMapZoomOut.center=self.homePointForButtonMainMapZoomOut;
        }];
        self.isButtonMainMapZoomOutDragged=NO;
    }
}

-(void)setupButtonMainMapZoomOutTransformScale:(BOOL)scaleEnabled image:(UIImage*)image 
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    if (scaleEnabled)
    {
        button.clipsToBounds=YES;
        button.layer.cornerRadius=363;
        button.transform = CGAffineTransformMakeScale(0.3212, 0.3212f);
    }
    else
    {
        button.transform = CGAffineTransformMakeScale(0.584f, 0.584f);
        
    }
    button.center = CGPointMake(564.50f,460.0f);
    button.alpha=0.0f;
    self.buttonMainMapZoomOut = button;
    [self.buttonMainMapZoomOut addTarget:self action:@selector(buttonMainMapZoomOutTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonMainMapZoomOut addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.buttonMainMapZoomOut addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    self.homePointForButtonMainMapZoomOut=CGPointMake(564.50f,460.0f);
    [self.view addSubview:button];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
        self.isButtonMainMapZoomOutDragged=YES;
        [self.view bringSubviewToFront:sender];
        CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        
        UIControl *control = sender;
        control.center = point;
}
@end
