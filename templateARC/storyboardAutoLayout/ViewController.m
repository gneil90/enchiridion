//
//  ViewController.m
//  storyboardAutoLayout
//
//  Created by Mac Owner on 2/23/13.
//
//

#import "ViewController.h"

@interface UIWindow (AutoLayoutDebug)
+ (UIWindow *)keyWindow;
- (NSString *)_autolayoutTrace;
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"%@", [[UIWindow keyWindow] _autolayoutTrace]);
}

@end
