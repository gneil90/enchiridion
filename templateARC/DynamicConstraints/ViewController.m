//
//  ViewController.m
//  DynamicConstraints
//
//  Created by Mac Owner on 2/26/13.
//
//

#import "ViewController.h"

@interface UIWindow (AutoLayoutDebug)
+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
	// Do any additional setup after loading the view, typically from a nib.
    leftButton = [UIButton buttonWithType:
                  UIButtonTypeRoundedRect];
    leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [leftButton setTitle:@"Left" forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    centerButton = [UIButton buttonWithType:
                    UIButtonTypeRoundedRect];
    centerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [centerButton setTitle:@"Center"
                  forState:UIControlStateNormal];
    [self.view addSubview:centerButton];
    rightButton = [UIButton buttonWithType:
                   UIButtonTypeRoundedRect];
    rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [rightButton setTitle:@"Right"
                 forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    [self.view setNeedsUpdateConstraints];
    
    [leftButton addTarget:self
                   action:@selector(leftButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonPressed
{
    if (centerButton.superview != nil)
        [centerButton removeFromSuperview];
    else
        [self.view addSubview:centerButton];
        [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    NSLog(@"updateViewConstraints");
    [super updateViewConstraints];
    [self.view removeConstraints:self.view.constraints];
    if (centerButton.superview != nil)
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:centerButton
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:0.0f];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint
                      constraintWithItem:centerButton
                      attribute:NSLayoutAttributeCenterY
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeCenterY
                      multiplier:1.0f
                      constant:0.0f];
        [self.view addConstraint:constraint];
        NSDictionary *viewsDictionary =
        NSDictionaryOfVariableBindings(
                                       leftButton, centerButton, rightButton);
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"[leftButton]-[centerButton]-[rightButton]"
                                options:NSLayoutFormatAlignAllBaseline
                                metrics:nil
                                views:viewsDictionary];
        [self.view addConstraints:constraints];
    }
    else
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:leftButton
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0f
                                          constant:-10.0f];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint
                      constraintWithItem:leftButton
                      attribute:NSLayoutAttributeCenterY
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeCenterY
                      multiplier:1.0f
                      constant:0.0f];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint
                      constraintWithItem:rightButton
                      attribute:NSLayoutAttributeLeading
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeCenterX
                      multiplier:1.0f
                      constant:10.0f];
        [self.view addConstraint:constraint];
        constraint = [NSLayoutConstraint
                      constraintWithItem:rightButton
                      attribute:NSLayoutAttributeCenterY
                      relatedBy:NSLayoutRelationEqual
                      toItem:self.view
                      attribute:NSLayoutAttributeCenterY
                      multiplier:1.0f
                      constant:0.0f];
        [self.view addConstraint:constraint];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:
     fromInterfaceOrientation];
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}
@end
