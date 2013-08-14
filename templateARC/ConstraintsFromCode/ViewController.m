//
//  ViewController.m
//  ConstraintsFromCode
//
//  Created by Mac Owner on 2/24/13.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Button 1" forState:UIControlStateNormal];
    [button1 sizeToFit];
    //отключение размерной маски. Обязательно, если программно задавать ограничения
    button1.translatesAutoresizingMaskIntoConstraints = NO;
    //добавление ограничения
    //NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      //constraintWithItem:button1
                                      //attribute:NSLayoutAttributeRight
                                      //relatedBy:NSLayoutRelationEqual
                                      //toItem:self.view
                                      //attribute:NSLayoutAttributeRight
                                      //multiplier:1.0f
                                      //constant:-20.0f];
    //[self.view addConstraint:constraint];
    
    //предыщий метод можно вызвать следующим методом
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:button1
                                      attribute:NSLayoutAttributeCenterX //правый край
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeCenterX //правый край
                                      multiplier:1.0f
                                      constant:0.0f];
    [self.view addConstraint:constraint];
    
                        constraint = [NSLayoutConstraint
                                      constraintWithItem:button1
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:-20.0f];
    [self.view addConstraint:constraint];
    
    //ограничение на фиксированную ширину кнопки 
                       // constraint = [NSLayoutConstraint
                                      //constraintWithItem:button1
                                      //attribute:NSLayoutAttributeWidth
                                      //relatedBy:NSLayoutRelationEqual
                                      //toItem:nil
                                      //attribute:NSLayoutAttributeNotAnAttribute
                                      //multiplier:1.0f
                                      //constant:200.0f];
    //[button1 addConstraint:constraint];
    
    //Implementing 200 points width in portrait, 300 points in landscape.
    //But both constraints are satisfied perfectly when the width is exactly 200
    //points, so Auto Layout sees no reason to make the button wider when it doesn’t
    //need to.
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeWidth
                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                  toItem:nil
                  attribute:NSLayoutAttributeNotAnAttribute
                  multiplier:1.0f
                  constant:200.0f];
    [button1 addConstraint:constraint];
    
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeWidth
                  relatedBy:NSLayoutRelationEqual
                  toItem:nil
                  attribute:NSLayoutAttributeNotAnAttribute
                  multiplier:1.0f
                  constant:300.0f];
    constraint.priority = 999;
    [button1 addConstraint:constraint];
    
    //One way to solve this problem is to put leading and trailing spaces between the
    //button and the edges of the screen. In portrait mode, the screen is 320 points wide,
    //so that leaves (320 - 200)/2 = 60 points on either side.
    
    //This setup works fine in portrait, but not in landscape. Try it out. Auto Layout gives
    //an "Unable to simultaneously satisfy constraints" error when you flip to landscape.
    //That makes sense, because if the button should be 300 points wide in landscape,
    //then the margins should be (480 - 300) / 2 = 90 points, not 60.
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeLeading
                  relatedBy:NSLayoutRelationGreaterThanOrEqual     //button1.leading = self.view.leading*1.0f + 60.0f
                  toItem:self.view
                  attribute:NSLayoutAttributeLeading
                  multiplier:1.0f
                  constant:60.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeTrailing
                  relatedBy:NSLayoutRelationLessThanOrEqual    //button1.trailing = self.view.trailing*1.0f - 60.0f
                  toItem:self.view
                  attribute:NSLayoutAttributeTrailing
                  multiplier:1.0f
                  constant:-60.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeHeight
                  relatedBy:NSLayoutRelationLessThanOrEqual
                  toItem:nil
                  attribute:NSLayoutAttributeNotAnAttribute
                  multiplier:1.0f
                  constant:260.0f];
    [button1 addConstraint:constraint];
    
    //ограничение на ширину и высоту
    //button1.width = button1.height
    constraint = [NSLayoutConstraint
                  constraintWithItem:button1
                  attribute:NSLayoutAttributeHeight
                  relatedBy:NSLayoutRelationEqual
                  toItem:button1
                  attribute:NSLayoutAttributeWidth
                  multiplier:1.0f
                  constant:0.0f];
    constraint.priority = 998;
    [button1 addConstraint:constraint];
    
    
    [self.view addSubview:button1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
