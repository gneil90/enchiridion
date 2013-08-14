//
//  MainMapViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

#import "MainMapViewController.h"
#import "macros.h"
#import "AppDelegate.h"
#import "CircleView.h"
#import "CoordinatesController.h"
#import <QuartzCore/QuartzCore.h>
#import "pLifeButton.h"
#import "HealthButton.h"
#import "FinanceButton.h"
#import "CombinedViewController.h"
#import "MainMapZoomOutViewController.h"
#import "Fugitive.h"
#import "Subobjective.h"
#import "UIImage+ImmediateLoading.h"
#import "UIView+AnchorPoint.h"
#import "OneFingerRotateGestureRecognizer.h"

#define PI 3.14159265

@interface MainMapViewController ()
{
    CGPoint m_locationBegan;
    float m_currentAngle;
    int flagAngle;
    BOOL isMainAnimationCenterAlreadyCalled;
    BOOL isGlitterAnimationFired;
    int numberOfCreatedFinanceButtons;
    int numberOfCreatedHealthButtons;
    int numberOfCreatedPrivateLifeButtons;
    int bufferTag;
    int newButtonTagValue;
    NSMutableArray *_arrayOfHealthTags;
    NSMutableArray *_arrayOfPrivateLifeTags;
    NSMutableArray *_arrayOfFinanceTags;
    
    CGRect _mainMapView2Frame;
    CGAffineTransform _mainMapView2AffineTransform;
    CGAffineTransform _mainMapViewTransformIdentity;
    
    BOOL _isPanning, _isPinch;
    
    CGFloat _lastScalePinch;

}

//animations
@property (strong,nonatomic,readwrite) NSMutableArray *animationMainCenterFinanceImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationMainCenterPrivateLifeImages;

@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearanceHealthImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearanceHealthImages2;

@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterHealthImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterHealthImages2;

@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearancePrivateLifeImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearancePrivateLifeImages2;

@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterPrivateLifeImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterPrivateLifeImages2;

@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearanceFinanceImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationAppearanceFinanceImages2;

@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterFinanceImages;
@property (strong,nonatomic,readwrite) NSMutableArray *animationGlitterFinanceImages2;

-(void)reDrawNewButton:(UIButton*)button;

-(UIImage*)imageFromUIColor;

-(void)addButtonItem:(UIButton*)button;

-(void)createFinanceButtonAt:(CircleView*)circle withTag:(int)newButtonTagValue animated:(BOOL)animated toDoAssignment:(Fugitive*)assignment;

-(void)createHealthButtonAt:(CircleView*)circle withTag:(int)newButtonTagValue animated:(BOOL)animated  toDoAssignment:(Fugitive*)assignment;

-(void)createPrivateLifeButtonAt:(CircleView*)circle withTag:(int)newButtonTagValue animated:(BOOL)animated  toDoAssignment:(Fugitive*)assignment;

- (float) updateRotation:(CGPoint)_location;


@end

@implementation MainMapViewController

@synthesize finance=_finance;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        // Do something
    }
    return self;
}





#pragma mark- imageScale
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(UIImage*)imageFromUIColor
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f] CGColor]);
    //[[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark- view lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // -----------------------------
    // Two finger pinch
    // -----------------------------
    OneFingerRotateGestureRecognizer *rotateGesture = [[OneFingerRotateGestureRecognizer alloc]init];
    rotateGesture.delegate=self;
    [[self view] addGestureRecognizer:rotateGesture];
    rotateGesture.viewToRotate=self.view2;
    self.rotateGestureRecognizer=rotateGesture;

    UIPinchGestureRecognizer *twoFingerPinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutPinch:)];
    [[self view2] addGestureRecognizer:twoFingerPinch];
    //twoFingerPinch.delegate=gestureDelegate;
    self.pinchGestureRecognizer=twoFingerPinch;
    
    [self.pinchGestureRecognizer requireGestureRecognizerToFail:rotateGesture];
    
    
    
    [self.swipeGestureRecognizer requireGestureRecognizerToFail:self.panGestureRecognizer];
    
    NSMutableArray *arrayOfTags=[NSMutableArray new];
    _arrayOfFinanceTags=arrayOfTags;
    
    newButtonTagValue=3;
    __weak MainMapViewController *weakSelf=self;
    
    numberOfCreatedFinanceButtons=0;
    numberOfCreatedHealthButtons=0;
    numberOfCreatedPrivateLifeButtons=0;
   
    @autoreleasepool
    {
        [weakSelf createAnimationIfNeeded];
    }
    isGlitterAnimationFired=NO;
    _isDetailViewOn=NO;
    _touchSwallowRotationEnabled=YES;
    
    bufferTag=0;
    
  //[_finance setImage:[parentWeakVC.animationMainCenterFinanceImages lastObject] forState:UIControlStateSelected];

    [_finance addTarget:self action:@selector(addButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _finance.tag=kFinanceTypeButton;
    
    [health addTarget:self action:@selector(addButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    health.tag=9999;
    
    [privateLife addTarget:self action:@selector(addButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    privateLife.tag=kPrivateLifeButton;
    
    //[self.view setNeedsUpdateConstraints];
    
  
    mainCommas.tag=998;

	// Do any additional setup after loading the view.
    /*
    if (self.animationGlitterFinanceImages==nil)
    {
        @autoreleasepool
        {
            Animations *animationGlitterFinance=[[Animations alloc]init];

            animationGlitterFinance.animationForButtonType=kFinanceTypeButton;
            animationGlitterFinance.animationType=kGlitterAnimationFinance;
            [weakSelf recreateGlitterAnimation:animationGlitterFinance];
        }
        
    }
    if (self.animationGlitterFinanceImages2==nil)
    {
        @autoreleasepool
        {

            Animations *animationGlitterFinance2=[[Animations alloc]init];
            
            animationGlitterFinance2.animationForButtonType=kFinanceTypeButton;
            animationGlitterFinance2.animationType=kGlitterAnimationFinance2;
            [weakSelf recreateGlitterAnimation:animationGlitterFinance2];
            
        }
        
    }
    
    if (self.animationGlitterHealthImages==nil)
    {
        @autoreleasepool
        {

            Animations *animationGlitterHealth=[[Animations alloc]init];
            
            animationGlitterHealth.animationForButtonType=kHealthTypeButton;
            animationGlitterHealth.animationType=kGlitterAnimationHealth;
            [weakSelf recreateGlitterAnimation:animationGlitterHealth];
        }
        
    }
    if (self.animationGlitterHealthImages2==nil)
    {
        @autoreleasepool
        {

            Animations *animationGlitterHealth2=[[Animations alloc]init];
            
            animationGlitterHealth2.animationForButtonType=kHealthTypeButton;
            animationGlitterHealth2.animationType=kGlitterAnimationHealth2;
            [weakSelf recreateGlitterAnimation:animationGlitterHealth2];
        }
        
    }
    
    if (self.animationGlitterPrivateLifeImages==nil)
    {
        @autoreleasepool
        {

            Animations *animationGlitterPrivateLife=[[Animations alloc]init];
            
            animationGlitterPrivateLife.animationForButtonType=kPrivateLifeButton;
            animationGlitterPrivateLife.animationType=kGlitterAnimationPrivateLife;
            [weakSelf recreateGlitterAnimation:animationGlitterPrivateLife];
        }
        
    }
    if (self.animationGlitterPrivateLifeImages2==nil)
    {
        @autoreleasepool
        {

            Animations *animationGlitterPrivateLife2=[[Animations alloc]init];
            
            animationGlitterPrivateLife2.animationForButtonType=kPrivateLifeButton;
            animationGlitterPrivateLife2.animationType=kGlitterAnimationPrivateLife2;
            [weakSelf recreateGlitterAnimation:animationGlitterPrivateLife2];
        }
     
    }
     */
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)loadView
{
    [super loadView];
    self.showAssignmentsWithDelay=YES;

}

-(void)viewWillLayoutSubviews
{
    
    if ((self.graphView==nil)&&(self.graphView2==nil))
    {
        if (self.date==nil)
        {
            NSDate *dateToday=[NSDate date];
            self.date=dateToday;
        }

        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
       
            if (orientation==UIInterfaceOrientationLandscapeLeft)
            {
            
                NSLog(@"MainMapOrientation is Landscape.");
            }
        
        CGRect b=self.view2.bounds;
        b.origin=CGPointMake(b.origin.x-450.0f, b.origin.y-450.0f);
        b.size=CGSizeMake(b.size.width+900, b.size.height+900);
        self.view2.bounds=b;
            
        [self initCircleViewWithRadius:100 withBrush:10 tag:1000 alphaParam:0.35f needToCreateArray:NO needToCreateArrayForSubobjective:NO];
        
        [self initCircleViewWithRadius:185 withBrush:50 tag:1001 alphaParam:0.35f needToCreateArray:YES needToCreateArrayForSubobjective:NO];
        
        self.graphView=(CircleView*)[self.view2 viewWithTag:1001];
        
        self.graphView.date=self.date;
        
        [self initCircleViewWithRadius:360 withBrush:80 tag:1002 alphaParam:0.35f needToCreateArray:YES needToCreateArrayForSubobjective:YES];
        
        self.graphView2=(CircleView*)[self.view2 viewWithTag:1002 ];
        
        self.graphView2.date=[MainMapViewController getNextDayOf:self.date];
        
        if (self.showAssignmentsWithDelay)
        {
        [self performSelector:@selector(showAllAssignments) withObject:nil afterDelay:0.1f];
        }

    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory warning received...");

}

-(void)showDetailView:(id)sender
{

    _isDetailViewOn=YES;
    __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
    [parentVC setNewFrames:sender];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _mainMapViewTransformIdentity=self.view2.transform;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Gesture Segue invoke");
    if([segue.identifier isEqualToString:@"ZoomOutSegue"])
    {
        
    }
}



#pragma mark- buttonsMethods

-(void)disableAllButtonsExcept:(UIButton*)button
{
    
    __weak UIButton *weakButtonPrivate=privateLife;
    __weak UIButton *weakButtonHealth=health;
    __weak UIButton *weakButtonFinance=_finance;


    [UIView animateWithDuration:0.4f animations:
     ^{
    switch (button.tag) {
          
        case kFinanceTypeButton:
            [weakButtonPrivate setUserInteractionEnabled:NO];
            [weakButtonPrivate setAlpha:0.65f];
            [weakButtonHealth setUserInteractionEnabled:NO];
            [weakButtonHealth setAlpha:0.65f];
            break;
            
        case 9999:
            [weakButtonPrivate setUserInteractionEnabled:NO];
            [weakButtonPrivate setAlpha:0.65f];
            [weakButtonFinance setUserInteractionEnabled:NO];
            [weakButtonFinance setAlpha:0.65f];
            break;
        case kPrivateLifeButton:
            [weakButtonHealth setUserInteractionEnabled:NO];
            [weakButtonHealth setAlpha:0.65f];
            [weakButtonFinance setUserInteractionEnabled:NO];
            [weakButtonFinance setAlpha:0.65f];
            break;
        default:
            NSLog(@"Error. Unknown tag of button.");
            break;
                        }
     }];
}

-(void)enableAllButtons
{
    __weak UIButton *weakButtonPrivate=privateLife;
    __weak UIButton *weakButtonHealth=health;
    __weak UIButton *weakButtonFinance=_finance;
    [UIView animateWithDuration:0.5f animations:
     ^{
    
    [weakButtonPrivate setUserInteractionEnabled:YES];
    [weakButtonPrivate setAlpha:1.0f];
    [weakButtonFinance setUserInteractionEnabled:YES];
    [weakButtonFinance setAlpha:1.0f];
    [weakButtonHealth setUserInteractionEnabled:YES];
    [weakButtonHealth setAlpha:1.0f];
         
       }];
   
}

-(void)addButtonItem:(UIButton*)button

{
    
        button.selected=YES;
        
        [self disableAllButtonsExcept:button];
        
        if (!self.mapDetailsViewController.delegate)
            self.mapDetailsViewController.delegate=self;
        self.mapDetailsViewController.buttonToCreateSubObjective.alpha=0.0f;
        self.mapDetailsViewController.numberOfSubojectives.alpha=0.0f;
        self.mapDetailsViewController.circle1.alpha=1.0f;
        self.mapDetailsViewController.name.alpha=0.0f;
        self.mapDetailsViewController.objectiveNameTitle.alpha=0.0f;
        [[self.mapDetailsViewController.view viewWithTag:kViewSubobjectiveNames]removeFromSuperview];
        CGRect frame = self.mapDetailsViewController.buttonToCreateSubObjective.frame;
        frame.origin = CGPointMake(frame.origin.x, self.mapDetailsViewController.numberOfSubojectives.frame.origin.y+40.0f);
        [UIView animateWithDuration:0.4f animations:^{self.mapDetailsViewController.buttonToCreateSubObjective.frame=frame;}];



    
        self.mapDetailsViewController.buttonTypeToCreate=nil;
        
        self.mapDetailsViewController.datePicker.date=self.date;
        [self.mapDetailsViewController.datePicker setMinimumDate:self.date];
        [self.mapDetailsViewController.datePicker setMaximumDate:[MainMapViewController getNextDayOf:self.date]];
        
        if (button.tag==kFinanceTypeButton) {
            @autoreleasepool
            {
            [self.animationAppearanceFinanceImages removeAllObjects];
            self.animationAppearanceFinanceImages=nil;
                
            [self.animationAppearanceFinanceImages2 removeAllObjects];
            self.animationAppearanceFinanceImages2=nil;
                
                [self.animationAppearancePrivateLifeImages removeAllObjects];
                [self.animationAppearancePrivateLifeImages2 removeAllObjects];
                
                self.animationAppearancePrivateLifeImages=nil;
                self.animationAppearancePrivateLifeImages2=nil;
                
                [self.animationAppearanceHealthImages removeAllObjects];
                [self.animationAppearanceHealthImages2 removeAllObjects];
                
                self.animationAppearanceHealthImages=nil;
                self.animationAppearanceHealthImages2=nil;

            }

            if (numberOfCreatedFinanceButtons%2==0) {
                if (self.animationAppearanceFinanceImages==nil)
                {
                    
                    @autoreleasepool
                    {
                        
                        Animations *animation2=[[Animations alloc]init];
                        
                        animation2.animationForButtonType=kFinanceTypeButton;
                        animation2.animationType=kAppearanceAnimationFinance;
                        NSOperationQueue *queue2=[NSOperationQueue new];
                        NSInvocationOperation *operation2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation2];
                        
                        [queue2 addOperation:operation2];
                        operation2=nil;
                        animation2=nil;
                        queue2=nil;
                        
                    }
                }
               
            }
            else
            {
                if (self.animationAppearanceFinanceImages==nil)
                {
                    
                    @autoreleasepool
                    {
                        
                        Animations *animation2=[[Animations alloc]init];
                        
                        animation2.animationForButtonType=kFinanceTypeButton;
                        animation2.animationType=kAppearanceAnimationFinance2;
                        NSOperationQueue *queue2=[NSOperationQueue new];
                        NSInvocationOperation *operation2=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation2];
                        
                        [queue2 addOperation:operation2];
                        operation2=nil;
                        animation2=nil;
                        queue2=nil;
                        
                    }
                }

            }
            
            CGRect frame=_finance.frame;
            frame.origin=CGPointMake(0.0f, 0.0f);
            UIImageView *buttonView=[[UIImageView alloc]initWithFrame:frame];
            buttonView.tag=10;
            
            buttonView.layer.shouldRasterize=YES;
            
            buttonView.animationDuration=1.0;
            buttonView.animationImages=self.animationMainCenterFinanceImages;
            buttonView.animationRepeatCount=1;
            [_finance addSubview:buttonView];
            
            [buttonView startAnimating];
            
            
            self.mapDetailsViewController.buttonTypeToCreate=nil;
            self.mapDetailsViewController.buttonTypeToCreate=kFinanceTypeButton;
        }
        else if (button.tag==9999)
        {
            if (numberOfCreatedHealthButtons%2==0) {
                if (self.animationAppearanceHealthImages==nil)
                {
                @autoreleasepool {
                    Animations *animation=[[Animations alloc]init];
                    
                    
                        animation.animationForButtonType=kHealthTypeButton;
                        animation.animationType=kAppearanceAnimationHealth;
                        NSOperationQueue *queue=[NSOperationQueue new];
                        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation];
                        
                        [queue addOperation:operation];
                        operation=nil;
                        animation=nil;
                        queue=nil;
                        
                    }

                }
            }
                else
                {
                    @autoreleasepool {
                        if (self.animationAppearanceHealthImages2==nil)
                        {
                        Animations *animation3=[[Animations alloc]init];

                        
                            
                            animation3.animationForButtonType=kHealthTypeButton;
                            animation3.animationType=kAppearanceAnimationHealth2;
                            NSOperationQueue *queue3=[NSOperationQueue new];
                            NSInvocationOperation *operation3=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation3];
                            
                            [queue3 addOperation:operation3];
                            operation3=nil;
                            animation3=nil;
                            queue3=nil;
                            
                        }

                    }
                    

                }
            
            
            
            [self setAnchorPoint:CGPointMake(51.0f/89.0f, 33.0f/89.0f) forView:health];
            
            [self runSpinAnimationWithDuration:1.0 forView:health];
            
            self.mapDetailsViewController.buttonTypeToCreate=kHealthTypeButton;
        }
        else if (button.tag==kPrivateLifeButton)
        {
            if (numberOfCreatedPrivateLifeButtons%2==0) {
                if (self.animationAppearancePrivateLifeImages==nil)
                {
                @autoreleasepool {
                    
                   
                        Animations *animation4=[[Animations alloc]init];
                        animation4.animationForButtonType=kPrivateLifeButton;
                        animation4.animationType=kAppearanceAnimationPrivateLife;
                        NSOperationQueue *queue4=[NSOperationQueue new];
                        NSInvocationOperation *operation4=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation4];
                        
                        [queue4 addOperation:operation4];
                        animation4=nil;
                        operation4=nil;
                        queue4=nil;
                    }

                }
            }
            else
            {
                
                    if (self.animationAppearancePrivateLifeImages2==nil)
                    {
                
                    @autoreleasepool {
                            Animations *animation5=[[Animations alloc]init];
                            animation5.animationForButtonType=kPrivateLifeButton;
                            animation5.animationType=kAppearanceAnimationPrivateLife2;
                            NSOperationQueue *queue5=[NSOperationQueue new];
                            NSInvocationOperation *operation5=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animation5];
                            
                            [queue5 addOperation:operation5];
                            animation5=nil;
                            operation5=nil;
                            queue5=nil;
                        }
                    }
                    
                }
            //heart beat animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationRepeatCount:3];
            
            button.transform=CGAffineTransformScale(button.transform, 1.15f, 1.15f);
            button.transform=CGAffineTransformIdentity;
            
            [UIView commitAnimations];
            self.mapDetailsViewController.buttonTypeToCreate=kPrivateLifeButton;
        }
    if (_touchSwallowRotationEnabled)
    {
        [self showDetailView:button];
        self.mapDetailFrame=self.mapDetailsViewController.view.frame;
        _mainMapView2Frame=self.view2.frame;
        _mainMapView2AffineTransform=self.view2.transform;

    }
        [button setUserInteractionEnabled:NO];

}


- (void) runSpinAnimationWithDuration:(CGFloat) duration forView:(UIView*)myView
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    CGFloat rotations=1;
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ *rotations * duration ];
    rotationAnimation.duration = 1.0f*duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [myView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)updateViewConstraints
{
    NSLog(@"updateViewConstraints");
    [super updateViewConstraints];
    /*NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:_finance
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:80.0f];
    [_finance addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                                      constraintWithItem:_finance
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1.0f
                                      constant:80.0f];
    [_finance addConstraint:constraint];*/
    
    /*[self.view removeConstraints:self.view.constraints];
    if (_isDetailViewOn==NO) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:_finance
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeLeading
                                          multiplier:1.0f
                                          constant:400.0f];
        [self.view addConstraint:constraint];
        
        constraint=[NSLayoutConstraint
                    constraintWithItem:_finance
                    attribute:NSLayoutAttributeTop
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.view
                    attribute:NSLayoutAttributeTop
                    multiplier:1.0f
                    constant:8.0f];
        [self.view addConstraint:constraint];
        
        NSDictionary *viewsDictionary =
        NSDictionaryOfVariableBindings(_finance,health,privateLife);
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"[_finance]-[health]-[privateLife]"
                                options:NSLayoutFormatAlignAllBaseline
                                metrics:nil
                                views:viewsDictionary];
        [self.view addConstraints:constraints];
    }
    else
    {
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem:_finance
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.view
                                      attribute:NSLayoutAttributeLeading
                                      multiplier:1.0f
                                      constant:8.0f];
    [self.view addConstraint:constraint];
    
    constraint=[NSLayoutConstraint
                constraintWithItem:_finance
                attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual
                toItem:self.view
                attribute:NSLayoutAttributeTop
                multiplier:1.0f
                constant:8.0f];
    [self.view addConstraint:constraint];
    
    NSDictionary *viewsDictionary =
    NSDictionaryOfVariableBindings(_finance,health,privateLife);
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:
                            @"[_finance]-[health]-[privateLife]"
                            options:NSLayoutFormatAlignAllBaseline
                            metrics:nil
                            views:viewsDictionary];
    [self.view addConstraints:constraints];
    }*/

    
}
#pragma mark-Convert Coordinate method

-(void)convertViewtoMainMapCoordinates:(CoordinatesController*)coordinate fromCircle:(CircleView*)circle
{
    CGPoint startPointOfCoordinateSystem=CGPointMake(circle.frame.origin.x,circle.frame.origin.y);
   
        coordinate.pointToDrawButton=CGPointMake(coordinate.pointToDrawButton.x+startPointOfCoordinateSystem.x,startPointOfCoordinateSystem.y+coordinate.pointToDrawButton.y);
        coordinate.isPointConverted=YES;
    
    
}

-(void)initCircleViewWithRadius:(CGFloat)radiusOfCircle withBrush:(CGFloat)brush tag:(int)tag alphaParam:(CGFloat)alphaParam needToCreateArray:(BOOL)needToCreateArray needToCreateArrayForSubobjective:(BOOL)needToCreateArrayForSubobjective
{
    
    CGFloat width=2*(radiusOfCircle)+brush;
    CGRect frame= CGRectMake(0.0f, 0.0f, width, width);
    CircleView *circleView=[[CircleView alloc]initWithFrame:frame];
    circleView.center=mainCommas.center;
    circleView.brush=brush;
    circleView.isVisible=YES;
    circleView.tag=tag;
    circleView.alphaParam=alphaParam;
    circleView.needToCreateArray=needToCreateArray;
    circleView.needToCreateArrayForSubobjectives=needToCreateArrayForSubobjective;
    [circleView createArraysWithCoordinatesForAllButtonTypes];
    [self.view2 insertSubview:circleView belowSubview:mainCommas];
    
}

#pragma mark- MapDetailVC Delegate Methods
-(void)setImageButton:(ButtonObjectClass *)button ForState:(ButtonStates)buttonState
{
    NSLog(@"Updating button's background image according on having subobjectives");
    __weak __block ButtonObjectClass *weakButton = button;
    switch (buttonState)
    {
        case kButtonStateHasSubobjectives:
            [weakButton setBackgroundImage:nil forState:UIControlStateNormal];
            [weakButton setBackgroundImage:weakButton.imageWithSubobjective forState:UIControlStateNormal];
            
            if (button.subbuttonType==kHealthSubButtonType)
            {
                [self setAnchorPoint:CGPointMake(button.layer.anchorPoint.x+0.05f,button.layer.anchorPoint.y) forView:weakButton];
                //UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
                //button.titleEdgeInsets = titleInsets;
                //button.cont
                [button sizeToFit];


            }
            else if (button.subbuttonType==kFinanceSubButtonType)
            {
                [self setAnchorPoint:CGPointMake(button.layer.anchorPoint.x,button.layer.anchorPoint.y+0.09f) forView:weakButton];
                //button.backgroundColor = [UIColor redColor];
               // UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, -100.0, 0.0, 0.0);
                //button.titleEdgeInsets = titleInsets;
                //button.titleLabel.center=CGPointMake(100,100);

 
            }
            else if (button.subbuttonType==kPrivateLifeSubButtonType)
            {
                [self setAnchorPoint:CGPointMake(button.layer.anchorPoint.x+0.05f,button.layer.anchorPoint.y) forView:weakButton];

            }
            [weakButton setCenter:weakButton.homePoint];
            [weakButton setButtonState:kButtonStateHasSubobjectives];
            [button sizeToFit];

         
            break;
            
         case kButtonStateNoSubobjective:
            [button setImage:button.imageWithNoSubobjective forState:UIControlStateNormal];
            [button setButtonState:kButtonStateNoSubobjective];

            break;
            
        default:
            NSLog(@"Unknown state updated. Error.");
            break;
    }
    //[button sizeToFit];
}

-(void)createButton:(ButtonTypes) buttonType  atCircleWithDate:(NSDate *)date
{
    __weak MainMapViewController *weakSelf=self;
    
    NSInteger day=[MainMapViewController getDayIntegerFromDate:date];
    NSInteger dayToCompare=[MainMapViewController getDayIntegerFromDate:self.date];
    
    if (day==dayToCompare)

    {
        if (buttonType==kFinanceTypeButton) {
            
            [weakSelf createFinanceButtonAt:weakSelf.graphView withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
            
        }
        else if (buttonType==kHealthTypeButton)
        {
            [weakSelf createHealthButtonAt:weakSelf.graphView withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
            
        }
        
        else if (buttonType==kPrivateLifeButton)
            
        {
            [weakSelf createPrivateLifeButtonAt:weakSelf.graphView withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
        }
    
    }
    else
    {
        if (buttonType==kFinanceTypeButton)
        {
        [weakSelf createFinanceButtonAt:weakSelf.graphView2 withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
        }
        else if (buttonType==kHealthTypeButton)
        {
            [weakSelf createHealthButtonAt:weakSelf.graphView2 withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
        }
        else if (buttonType==kPrivateLifeButton)
        {
            [weakSelf createPrivateLifeButtonAt:weakSelf.graphView2 withTag:newButtonTagValue%1000 animated:YES toDoAssignment:nil];
        }
    }
    _touchSwallowRotationEnabled=YES;
    newButtonTagValue++;
}

-(void)startingGlitterAnimation:(ButtonObjectClass*)button
{
    isGlitterAnimationFired=YES;
    __weak MainMapViewController *weakSelf=self;
    UIImageView *imgGlitterView;
    UIImageView *imgGlitterMaskView;
    CGFloat delay;
    switch (button.glitterType) {
        case kGlitterFinance:
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+2000];
                imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterFinanceImages objectAtIndex:0]];
            
            
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterFinanceImages animationDuration:1.0f withAnchorPoint:CGPointMake(180.0f/217.0f,39.0f/72.0f) andTag:kGlitterMaskFinance];
            delay=1.2f;
            
            break;
            
        case kGlitterFinance2:
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+2000];
            imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterFinanceImages2 objectAtIndex:0]];
            
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterFinanceImages2 animationDuration:1.0f withAnchorPoint:CGPointMake(180.0f/217.0f,39.0f/72.0f) andTag:kGlitterMaskFinance2];
            delay=1.2f;
            
            break;
            
        case kGlitterHealth:
            
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+3000];
            imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterHealthImages objectAtIndex:0]];
            
            
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterHealthImages animationDuration:1.1f withAnchorPoint:CGPointMake(62.0f/436.0f,67.0f/146.0f) andTag:kGlitterMaskHealth];
            
            delay=1.3f;
            break;
            
        case kGlitterHealth2:
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+3000];
            imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterHealthImages2 objectAtIndex:0]];
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterHealthImages2 animationDuration:1.1f withAnchorPoint:CGPointMake(62.0f/436.0f,67.0f/146.0f) andTag:kGlitterMaskHealth2];
            delay=1.3f;
            
            
            break;
            
        case kGlitterPrivateLife:
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+4000];
            imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterPrivateLifeImages objectAtIndex:0]];
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterPrivateLifeImages animationDuration:0.8f withAnchorPoint:CGPointMake(170.0f/214.0f, 90.4f/166.0f) andTag:kGlitterMaskPrivateLife];
            delay=1.0f;
            break;
            
        case kGlitterPrivateLife2:
            
            imgGlitterView=(UIImageView*)[weakSelf.view2 viewWithTag:button.tag+4000];
            imgGlitterMaskView=[[UIImageView alloc]initWithImage:[weakSelf.animationGlitterPrivateLifeImages2 objectAtIndex:0]];
            [weakSelf customizeGlitterMaskView:imgGlitterMaskView transformMaskImageViewAsParentView:imgGlitterView withArrayOfAnimation:weakSelf.animationGlitterPrivateLifeImages2 animationDuration:0.8f withAnchorPoint:CGPointMake(170.0f/214.0f, 90.1f/166.0f) andTag:kGlitterMaskPrivateLife2];
            delay=0.9f;
            
            break;
            
        default:
            delay=0.0f;
            NSLog(@"Unknown type of glitter! Error");
            break;
    }
    
    bufferTag=imgGlitterView.tag;
    imgGlitterMaskView.animationRepeatCount=1;
    [imgGlitterMaskView startAnimating];
    [weakSelf performSelector:@selector(stopAnimationAndRemoveMask:) withObject:imgGlitterMaskView afterDelay:delay];
}
//------------
//метод, который настраивает необходимый детальный вид, при нажатии на цель
//------------
-(void)customizeDetailViewForButton:(ButtonObjectClass*)button
{
    self.mapDetailsViewController.delegate=nil;
    self.mapDetailsViewController.delegate=self;
    self.mapDetailsViewController.toDoAssignment=button.toDoAssignment;
    if (self.mapDetailsViewController.selectedButton)
    {
        self.mapDetailsViewController.selectedButton=nil;
    }
    self.mapDetailsViewController.selectedButton = button;

    self.mapDetailsViewController.buttonToCreateSubObjective.alpha=1.0f;
    self.mapDetailsViewController.numberOfSubojectives.alpha=1.0f;
    self.mapDetailsViewController.name.alpha=1.0f;
    self.mapDetailsViewController.name.text=button.toDoAssignment.name;
    [self.mapDetailsViewController.name sizeToFit];
    self.mapDetailsViewController.objectiveNameTitle.alpha=1.0f;
    if ([button.toDoAssignment.numberOfSubobj intValue]>=7)
    {
        self.mapDetailsViewController.buttonToCreateSubObjective.enabled=NO;
        self.mapDetailsViewController.buttonToCreateSubObjective.alpha=.7f;
    }
    else
    {
        self.mapDetailsViewController.buttonToCreateSubObjective.enabled=YES;
        self.mapDetailsViewController.buttonToCreateSubObjective.alpha=1.0f;
    }
    self.mapDetailsViewController.numberOfSubojectives.text=[NSString stringWithFormat:@"Number of sub-objectives: %d",[button.toDoAssignment.numberOfSubobj intValue]];
    [[self.mapDetailsViewController.view viewWithTag:kViewSubobjectiveNames]removeFromSuperview];

    if([button.toDoAssignment.numberOfSubobj intValue])
    {
        NSArray *arrayOfSubobjective=[button.toDoAssignment.subObjective allObjects];
        NSString *titleString=[NSString stringWithFormat:@"Your objective %@ has %d sub-objectives. Here is the list:",button.toDoAssignment.name,[button.toDoAssignment.numberOfSubobj intValue]];
        NSString *finalList=@"";
        u_int count=0;
        CGFloat delay=.0f;
        for (Subobjective *subobjective in arrayOfSubobjective)
        {
            [self.mapDetailsViewController showSubobjectivesName:subobjective delay:delay];
            NSString *subobjectiveString=[NSString stringWithFormat:@"\r\nParent Objective:%@\nParent's type:%@\nSubobjective's Name:%@\nSuobjetive's Description:%@",subobjective.parentObj.name,subobjective.parentObj.type,subobjective.name,subobjective.desc];
            if (count==0) {
                finalList=[titleString stringByAppendingString:subobjectiveString];
            }
            else
            {
                finalList=[finalList stringByAppendingString:subobjectiveString];
            }
            count++;
            delay+=.1f;
        }
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frameButton = self.mapDetailsViewController.buttonToCreateSubObjective.frame;
            frameButton.origin=CGPointMake(frameButton.origin.x, [self.mapDetailsViewController.view viewWithTag:kViewSubobjectiveNames].frame.size.height+[self.mapDetailsViewController.view viewWithTag:kViewSubobjectiveNames].frame.origin.y+10.0f);
            
            self.mapDetailsViewController.buttonToCreateSubObjective.frame = frameButton;}];
        NSLog(@"%@",finalList);
    }
    else
    {
        CGRect frame = self.mapDetailsViewController.buttonToCreateSubObjective.frame;
        frame.origin = CGPointMake(frame.origin.x, self.mapDetailsViewController.numberOfSubojectives.frame.origin.y+40.0f);
        [UIView animateWithDuration:0.4f animations:^{self.mapDetailsViewController.buttonToCreateSubObjective.frame=frame;}];
    }
    [self.mapDetailsViewController.numberOfSubojectives sizeToFit];
    [self.mapDetailsViewController.objectiveNameTitle sizeToFit];
    self.mapDetailsViewController.circle1.alpha=0.0f;
    
    if (!self.isDetailViewOn)
    {
        [self showDetailView:button];
    }
    _touchSwallowRotationEnabled=NO;
}

//method that fires when button's touch is ended. 
-(void)startGlitter:(ButtonObjectClass*)button
{
    //if button is not being dragged - fire glitter animation and show detail view
    //if needed
    if (!button.isDragging) {
        if (!isGlitterAnimationFired) {
            [self startingGlitterAnimation:button];
        }
        [self customizeDetailViewForButton:button];
        self.mapDetailFrame=self.mapDetailsViewController.view.frame;
        _mainMapView2Frame=self.view2.frame;
        _mainMapView2AffineTransform=self.view2.transform;

        //[button setUserInteractionEnabled:NO];
    }
    //case if the button is being dragged
    else
    {
        //checking intersection with parent button
        //if no button goes to home point
        if (!button.isIntersectingWithParentButton) {
            NSLog(@"intersection is not detected yet!");
            button.isDragging=NO;
            [UIView animateWithDuration:0.5f animations:^{
                button.center=button.homePoint;}];
        }
        //otherwise customizing subobjective view fires
        //and parent view controller implements the transition controllers from
        //mainMapVC to mainMapZoomInVC
        else
        {
            NSLog(@"intersection detected!");
            _touchSwallowRotationEnabled=NO;
           __weak CombinedViewController *weakParent=(CombinedViewController*)self.parentViewController;
            [button removeTarget:self action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            [button removeTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [button removeTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
           
            [weakParent transitionToZoomInViewControllerWithCirclePosition:button];
           
        }
    }

}
//method that customizes mask view for glitter animation
-(void)customizeGlitterMaskView:(UIImageView*)imgGlitterMaskView transformMaskImageViewAsParentView:(UIImageView*)imgGlitterView withArrayOfAnimation:(NSMutableArray*)arrayOfAnimation animationDuration:(CGFloat)animationDuration withAnchorPoint:(CGPoint)anchorPoint andTag:(GlitterMaskType)glitterMaskTag
{
    if (arrayOfAnimation) {
        __weak MainMapViewController *weakSelf=self;
        
        [weakSelf setAnchorPoint:anchorPoint forView:imgGlitterMaskView];
        imgGlitterMaskView.transform=imgGlitterView.transform;
        imgGlitterMaskView.center=imgGlitterView.center;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        {
            // Retina display
            imgGlitterMaskView.transform=CGAffineTransformScale(imgGlitterMaskView.transform, 0.5f, 0.5f);
        }
        imgGlitterMaskView.tag=glitterMaskTag;
        imgGlitterView.alpha=0.0f;
        [weakSelf.view2 insertSubview:imgGlitterMaskView belowSubview:mainCommas];
        
        imgGlitterMaskView.animationImages=nil;
        imgGlitterMaskView.animationImages=arrayOfAnimation;
        imgGlitterMaskView.animationDuration=animationDuration;
    }
    else
    {
        @autoreleasepool
        {
            __weak __block MainMapViewController * weakSelf = self;
            
            Animations *animationGlitter=[[Animations alloc]init];
            switch (glitterMaskTag) {
                case kGlitterMaskFinance:
                    
                    [weakSelf.animationGlitterFinanceImages removeAllObjects];
                    weakSelf.animationGlitterFinanceImages=nil;
                    animationGlitter.animationForButtonType=kFinanceTypeButton;
                    animationGlitter.animationType=kGlitterAnimationFinance;
                    break;
                    
                case kGlitterMaskFinance2:
                    [weakSelf.animationGlitterFinanceImages2 removeAllObjects];
                    weakSelf.animationGlitterFinanceImages2=nil;
                    animationGlitter.animationForButtonType=kFinanceTypeButton;
                    animationGlitter.animationType=kGlitterAnimationFinance2;
                    break;
                    
                case kGlitterMaskHealth:
                    [weakSelf.animationGlitterHealthImages removeAllObjects];
                    weakSelf.animationGlitterHealthImages=nil;
                    animationGlitter.animationForButtonType=kHealthTypeButton;
                    animationGlitter.animationType=kGlitterAnimationHealth;
                    
                    break;
                    
                case kGlitterMaskHealth2:
                    [weakSelf.animationGlitterHealthImages2 removeAllObjects];
                    weakSelf.animationGlitterHealthImages2=nil;
                    animationGlitter.animationForButtonType=kHealthTypeButton;
                    animationGlitter.animationType=kGlitterAnimationHealth2;
                    break;
                    
                case kGlitterMaskPrivateLife:
                    [weakSelf.animationGlitterPrivateLifeImages removeAllObjects];
                    weakSelf.animationGlitterPrivateLifeImages=nil;
                    animationGlitter.animationForButtonType=kPrivateLifeButton;
                    animationGlitter.animationType=kGlitterAnimationPrivateLife;
                    
                    break;
                    
                case kGlitterMaskPrivateLife2:
                    [weakSelf.animationGlitterPrivateLifeImages2 removeAllObjects];
                    weakSelf.animationGlitterPrivateLifeImages2=nil;
                    animationGlitter.animationForButtonType=kPrivateLifeButton;
                    animationGlitter.animationType=kGlitterAnimationPrivateLife2;
                    
                    break;
                    
                default:
                    NSLog(@"imageMaskView is not recognized. Error!");
                    break;
            }
            

            
            [weakSelf recreateGlitterAnimation:animationGlitter];
        }
    }
    
}

#pragma mark - removing AnimationImages from memory methods

-(void)stopAnimationAndRemoveMask:(UIImageView*)imgv
{
    @autoreleasepool {
        __weak MainMapViewController *weakSelf=self;
        Animations *animationGlitter=[[Animations alloc]init];
        switch (imgv.tag) {
            case kGlitterMaskFinance:
                
                [weakSelf.animationGlitterFinanceImages removeAllObjects];
                weakSelf.animationGlitterFinanceImages=nil;
                animationGlitter.animationForButtonType=kFinanceTypeButton;
                animationGlitter.animationType=kGlitterAnimationFinance;
                break;
                
            case kGlitterMaskFinance2:
                [weakSelf.animationGlitterFinanceImages2 removeAllObjects];
                weakSelf.animationGlitterFinanceImages2=nil;
                animationGlitter.animationForButtonType=kFinanceTypeButton;
                animationGlitter.animationType=kGlitterAnimationFinance2;
                break;
                
            case kGlitterMaskHealth:
                [weakSelf.animationGlitterHealthImages removeAllObjects];
                weakSelf.animationGlitterHealthImages=nil;
                animationGlitter.animationForButtonType=kHealthTypeButton;
                animationGlitter.animationType=kGlitterAnimationHealth;

                break;
                
            case kGlitterMaskHealth2:
                [weakSelf.animationGlitterHealthImages2 removeAllObjects];
                weakSelf.animationGlitterHealthImages2=nil;
                animationGlitter.animationForButtonType=kHealthTypeButton;
                animationGlitter.animationType=kGlitterAnimationHealth2;
                break;
                
                case kGlitterMaskPrivateLife:
                [weakSelf.animationGlitterPrivateLifeImages removeAllObjects];
                weakSelf.animationGlitterPrivateLifeImages=nil;
                animationGlitter.animationForButtonType=kPrivateLifeButton;
                animationGlitter.animationType=kGlitterAnimationPrivateLife;

                break;
                
                case kGlitterMaskPrivateLife2:
                [weakSelf.animationGlitterPrivateLifeImages2 removeAllObjects];
                weakSelf.animationGlitterPrivateLifeImages2=nil;
                animationGlitter.animationForButtonType=kPrivateLifeButton;
                animationGlitter.animationType=kGlitterAnimationPrivateLife2;

                break;
                
            default:
                NSLog(@"imageMaskView is not recognized. Error!");
                break;
        }
        
        __weak UIImageView * imgvParent=(UIImageView*)[weakSelf.view2 viewWithTag:bufferTag];
        imgvParent.alpha=1.0f;
        imgv.animationImages=nil;
        [imgv removeFromSuperview];
        imgv=nil;
        
        
        {
            @autoreleasepool {
                [weakSelf recreateGlitterAnimation:animationGlitter];
            }
            
        }
        animationGlitter=nil;
        isGlitterAnimationFired=NO;
        
    }
    
}
-(void)recreateGlitterAnimation:(Animations*)animationGlitter
{
    NSOperationQueue *queueGlitter=[NSOperationQueue new];
    NSInvocationOperation *operationGlitter=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(createAnimationOnAnotherThread:) object:animationGlitter];
    
    [queueGlitter addOperation:operationGlitter];
}

#pragma mark - creating Buttons methods
-(void)showAllAssignments
{
    NSInteger dayOfDateAssignment;
    NSInteger monthOfDateAssignment;
    NSInteger dayOfCircle1=[MainMapViewController getDayIntegerFromDate:self.graphView.date];
    NSInteger dayOfCircle2=[MainMapViewController getDayIntegerFromDate:self.graphView2.date];
    NSInteger monthOfCircle1=[MainMapViewController getMonthIntegerFromDate:self.graphView.date];
    NSInteger monthOfCircle2=[MainMapViewController getMonthIntegerFromDate:self.graphView2.date];


    NSDate *dateOfAssignment;
    __weak CombinedViewController *parentVC=(CombinedViewController*)self.parentViewController;
    for (Fugitive *assignment in parentVC.toDoList)
    {
        dateOfAssignment=assignment.date;
        dayOfDateAssignment=[MainMapViewController getDayIntegerFromDate:dateOfAssignment];
        monthOfDateAssignment=[MainMapViewController getMonthIntegerFromDate:dateOfAssignment];
        
            if ((dayOfDateAssignment==dayOfCircle1)&&(monthOfCircle1==monthOfDateAssignment)) {
                
                if ([assignment.type isEqualToString:@"Health"]) {
                    
                    [self createHealthButtonAt:self.graphView withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                    newButtonTagValue++;
                }
                else if ([assignment.type isEqualToString:@"Finance"])
                {

                    [self createFinanceButtonAt:self.graphView withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                    newButtonTagValue++;
                }
                else if ([assignment.type isEqualToString:@"Private Life"])
                {

                    
                    [self createPrivateLifeButtonAt:self.graphView withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                    newButtonTagValue++;
                }
            }
            else if ((dayOfDateAssignment==dayOfCircle2)&&(monthOfCircle2==monthOfDateAssignment)){
                
                if ([assignment.type isEqualToString:@"Health"])
                {
    
                    
                [self createHealthButtonAt:self.graphView2 withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                newButtonTagValue++;
                }
                else if ([assignment.type isEqualToString:@"Finance"])
                {

                    [self createFinanceButtonAt:self.graphView2 withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                    newButtonTagValue++;
                }
                else if ([assignment.type isEqualToString:@"Private Life"])
                {

                    
                    [self createPrivateLifeButtonAt:self.graphView2 withTag:newButtonTagValue animated:NO toDoAssignment:assignment];
                    newButtonTagValue++;

                }
            }
           
        
    }

}

-(void)createFinanceButtonAt:(CircleView*)circle withTag:(int)buttonTagValue animated:(BOOL)animated toDoAssignment:(Fugitive*)assignment
{
    
    NSString *titleButton=[NSString stringWithFormat:@"Finance %d",buttonTagValue-2];
    
   __weak CombinedViewController *parentVC=(CombinedViewController*)self.parentViewController;
   __weak __block MainMapViewController *weakSelf=self;
   __weak __block CoordinatesController *weakCoordinate;
    __weak UIImage *weakImage;
    
    for (CoordinatesController *d in circle.arrayFinanceCoordinatesToDrawButton) {
        if (d.pointIsEmpty)
        {
            if (d.isPointConverted==NO) {
                [weakSelf convertViewtoMainMapCoordinates:d fromCircle:circle];
            }
            [_arrayOfFinanceTags addObject:[NSNumber numberWithInt:buttonTagValue]];

            weakCoordinate=d;
            FinanceButton *newButton=[[FinanceButton alloc]init];
           
            UIImageView *imgv;
            UIImageView *imgvMask;
            UIImage *image;
            CGFloat animationDuration=1.1f;
            
            if(numberOfCreatedFinanceButtons%2==0)
            {
                image=[UIImage imageNamed:@"lastImageAppearance_f"];
                imgv=[[UIImageView alloc]initWithImage:image];

                if ([weakSelf.animationAppearanceFinanceImages count]==46)
                {

                    if (animated) {
                        imgvMask=[[UIImageView alloc]initWithImage:image];

                        imgvMask.animationImages=weakSelf.animationAppearanceFinanceImages;
                    }
                    newButton.glitterType=kGlitterFinance;
                }
            }
            else
            {
                image=[UIImage imageNamed:@"lastImageAppearance_f2"];
                
                imgv=[[UIImageView alloc]initWithImage:image];
                if (animated) {
                    imgvMask=[[UIImageView alloc]initWithImage:image];

                    imgvMask.animationImages=weakSelf.animationAppearanceFinanceImages2;
                }
                newButton.glitterType=kGlitterFinance2;

            }
            if (!animated) {
                imgvMask.alpha=0.0f;
                animationDuration=0.45f;
            }
            if (imgvMask.animationImages==nil) {
                imgvMask.alpha=0.0f;
            }
            weakImage=image;
            if (animated) {
                [imgv setAlpha:0.0f];
            }

            [weakSelf appropriateTransformForUIImageView:imgv putItOnCoordinate:d needToScale:NO isFlip:NO withAnchorPoint:CGPointMake(180.0f/217.0f,39.0f/72.0f)];
            if (animated)
            {
            [weakSelf appropriateTransformForUIImageView:imgvMask putItOnCoordinate:d needToScale:NO isFlip:NO withAnchorPoint:CGPointMake(180.0f/217.0f,39.0f/72.0f)];
            
            imgvMask.animationDuration=1.1f;
            imgvMask.animationRepeatCount=1;
            [imgvMask startAnimating];
            }
            imgv.tag=buttonTagValue+2000;
            
            newButton.titleLabel.shadowOffset=CGSizeMake(-2.0, 2.0);
            [newButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
            [newButton setTitle:titleButton forState:UIControlStateNormal];
            
            UIEdgeInsets titleInsets = UIEdgeInsetsMake(-50.0, -150.0, 0.0, 0.0);
            newButton.titleEdgeInsets = titleInsets;

            
            newButton.center=d.pointToDrawButton;

            
            [newButton addTarget:weakSelf action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            [newButton addTarget:weakSelf action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [newButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];

            
            [newButton setDate:circle.date];
            //[self setAnchorPoint:CGPointMake(0.5f,0.5f) forView:star];
            
            d.pointIsEmpty=NO;
            newButton.tag=buttonTagValue;
            newButton.alpha=0.0;
            __weak __block ButtonObjectClass* weakButton=newButton;
            __weak __block UIImageView *weakImgvMask=imgvMask;
            __weak __block UIImageView *weakImgv=imgv;
            __weak CoordinatesController *weakD=d;
            
            [UIView animateWithDuration:animationDuration animations:
             ^{
             weakButton.alpha=1.0f;
             weakButton.transform=CGAffineTransformRotate(weakButton.transform, weakD.degreeValue*PI/180);
             } completion:^(BOOL finished){
                 @autoreleasepool {
                     if (weakImgvMask.animationImages==nil) {
                         [UIView animateWithDuration:1.4f animations:^{                 weakImgv.alpha=1.0f;
                         }];
                     }
                     else
                     {
                         if (animated) {
                             weakImgv.alpha=1.0f;
                         }
                     }
                     weakButton.degreeRotationValue=weakD.degreeValue;
                     weakButton.homePoint=weakButton.center;

                     [weakImgvMask stopAnimating];
                     weakImgvMask.animationImages=nil;
                     [weakImgvMask removeFromSuperview];
                     weakImgvMask=nil;
                     if(weakSelf.animationAppearanceFinanceImages)
                     {
                     [weakSelf.animationAppearanceFinanceImages removeAllObjects];
                     weakSelf.animationAppearanceFinanceImages=nil;
                     }
                     if (weakSelf.animationAppearanceFinanceImages2)
                     {
                     [weakSelf.animationAppearanceFinanceImages2 removeAllObjects];
                     weakSelf.animationAppearanceFinanceImages2=nil;
                     }

                 }
                 
                 }];
            NSLog(@"-----New Button Finance-----");

            //случай, когда необходимо создать новую запись в БД
            if (animated)
            {
            [parentVC dissmissMapDetailViewController:nil];

            AppDelegate *pAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:[pAppDelegate managedObjectContext]];
            
            Fugitive *toDoAssignment = [[Fugitive alloc] initWithEntity:entity insertIntoManagedObjectContext:[pAppDelegate managedObjectContext]];
            
            
            toDoAssignment.type=@"Finance";
            toDoAssignment.date = circle.date;
            toDoAssignment.desc=@"find some money";
            toDoAssignment.isEnchiridion = [NSNumber numberWithBool:YES];
            toDoAssignment.isShown=[NSNumber numberWithBool:NO];
                toDoAssignment.name=[NSString stringWithFormat:@"carrier%d",buttonTagValue];
            toDoAssignment.bounty = [NSDecimalNumber decimalNumberWithDecimal:
                                     [[NSNumber numberWithFloat:2.75f] decimalValue]];
            toDoAssignment.fugitiveID=[NSNumber numberWithInt:10];
            toDoAssignment.numberOfSubobj=[NSNumber numberWithInt:0];
            toDoAssignment.isReached = [NSNumber numberWithBool:NO];

                newButton.toDoAssignment=toDoAssignment;
            
            }
            //если в базе данных уже присутствует данная цель
            else
            {
               //задаем свойство кнопки fugitive
                newButton.toDoAssignment=assignment;
            }
            
                UIImage *imageSubobjective = [UIImage imageNamed:@"f1_main_subobjective.png"];
                newButton.imageWithSubobjective=imageSubobjective;
                UIImage *image2 = [UIImage imageNamed:@"f.png"];
                newButton.imageWithNoSubobjective=image2;
                
                if ([newButton.toDoAssignment.numberOfSubobj intValue]>0)
                {
                    [newButton setBackgroundImage:newButton.imageWithSubobjective forState:UIControlStateNormal];
                    [self setAnchorPoint:CGPointMake(0.5f, 0.57f) forView:newButton];
                    [newButton setButtonState:kButtonStateHasSubobjectives];
                }
                else
                {
                    [newButton setBackgroundImage:newButton.imageWithNoSubobjective forState:UIControlStateNormal];
                    [newButton setButtonState:kButtonStateNoSubobjective];

                }
            
            //[newButton setBackgroundColor:[UIColor blackColor]];
            [newButton sizeToFit];

            [weakSelf.view2 addSubview:newButton];

            
            numberOfCreatedFinanceButtons++;

            
            break;
        }
        
        
    }
    if (numberOfCreatedFinanceButtons>=[self.graphView.arrayFinanceCoordinatesToDrawButton count]+[self.graphView2.arrayFinanceCoordinatesToDrawButton count]) {
    [[[UIAlertView alloc]initWithTitle:nil message:@"Нет больше мест для денег" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    }
    [_finance setSelected:NO];
    
    
    
  
}
- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    if (_touchSwallowRotationEnabled)
    {
    ButtonObjectClass *button=(ButtonObjectClass*)sender;
    [self.view2 bringSubviewToFront:button];
    button.isDragging=YES;
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view2];
    
    UIControl *control = sender;
    control.center = point;
    ButtonObjectClass *parentButton;
    switch (button.subbuttonType)
        {
        case kFinanceSubButtonType:
            parentButton=(ButtonObjectClass*)_finance;
            break;
        case kHealthSubButtonType:
            parentButton=(ButtonObjectClass*)health;
            break;
        case kPrivateLifeSubButtonType:
            parentButton=(ButtonObjectClass*)privateLife;
            break;
            
        default:
            NSLog(@"Unknown subbutton type. ParentView is not recognized");
            break;
        }
    if ([self viewIntersectsWithAnotherView:button inView:parentButton])
            {
                if ((button.center.x>parentButton.center.x-95.0f/2.0f)&&(button.center.x<parentButton.center.x+95.0f/2.0f)&&(button.center.y>parentButton.center.y-95.0f/2.0f)&&(button.center.y<parentButton.center.y+95.0f/2.0f))
                    {
                        parentButton.selected=YES;
                        [self disableAllButtonsExcept:parentButton];
            
                        button.isIntersectingWithParentButton=YES;

                    }
            }
    else
            {
                parentButton.selected=NO;
                [self enableAllButtons];
                button.isIntersectingWithParentButton=NO;
            }
    }
}

-(void)createHealthButtonAt:(CircleView*)circle withTag:(int)buttonTagValue animated:(BOOL)animated  toDoAssignment:(Fugitive*)assignment
{
    
    __weak CombinedViewController *parentVC=(CombinedViewController*)self.parentViewController;
    __weak __block MainMapViewController *weakSelf=self;
    __weak __block CoordinatesController *weakCoordinate;


    NSString *titleButton=[NSString stringWithFormat:@"Health %d",buttonTagValue-2];
    for (CoordinatesController *d in circle.arrayHealthCoordinatesToDrawButton) {

        if (d.pointIsEmpty)
        {
            NSMutableArray *arrayOfTags=[NSMutableArray new];
            [arrayOfTags addObject:[NSNumber numberWithInt:buttonTagValue]];
            _arrayOfHealthTags=arrayOfTags;
            if (d.isPointConverted==NO) {
                [weakSelf convertViewtoMainMapCoordinates:d fromCircle:circle];
            }
            weakCoordinate=d;
            UIImageView *imgvHealth;
            UIImageView *imgvMask;
            UIImage *image;
            CGFloat animationDuration=1.1f;

            HealthButton *newButton=[[HealthButton alloc]init];
            
            if (numberOfCreatedHealthButtons%2==0)
            {
            image=[UIImage imageNamed:@"lastImageAppearance_h.png"];
                imgvHealth=[[UIImageView alloc]initWithImage:image];

                if (animated)
                {
                    imgvMask=[[UIImageView alloc]initWithImage:[weakSelf.animationAppearanceHealthImages lastObject]];
                    imgvMask.animationImages=weakSelf.animationAppearanceHealthImages;
                }
            newButton.glitterType=kGlitterHealth;
                if (animated) {
                imgvHealth.alpha=0.0f;
                }
                if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                    ([UIScreen mainScreen].scale == 2.0))
                {
                [weakSelf appropriateTransformForUIImageView:imgvHealth putItOnCoordinate:d needToScale:NO isFlip:YES withAnchorPoint:CGPointMake(69.90f/436.0f,67.0f/146.0f)];
                }
                else
                {
                    [weakSelf appropriateTransformForUIImageView:imgvHealth putItOnCoordinate:d needToScale:NO isFlip:YES withAnchorPoint:CGPointMake(72.0f/436.0f,67.0f/146.0f)];
                }

            }
            else
            {
                image=[UIImage imageNamed:@"lastImageAppearance_h2.png"];
                imgvHealth=[[UIImageView alloc]initWithImage:image];
                
                if (animated) {
                    imgvMask=[[UIImageView alloc]initWithImage:[weakSelf.animationAppearanceHealthImages2 lastObject]];

                    imgvMask.animationImages=weakSelf.animationAppearanceHealthImages2;
                }
                newButton.glitterType=kGlitterHealth2;
                if (animated) {
                    imgvHealth.alpha=0.0f;
                }
                [weakSelf appropriateTransformForUIImageView:imgvHealth putItOnCoordinate:d needToScale:NO isFlip:YES withAnchorPoint:CGPointMake(62.0f/436.0f,67.0f/146.0f)];

            }
            if (!animated) {
                animationDuration=0.45f;
                imgvMask.alpha=0.0f;

            }
            if (imgvMask.animationImages==nil)
            {
                imgvMask.alpha=0.0f;
            }
            
            if (animated) {
                [weakSelf appropriateTransformForUIImageView:imgvMask putItOnCoordinate:d needToScale:YES isFlip:YES withAnchorPoint:CGPointMake(62.0f/436.0f,67.0f/146.0f)];

                imgvMask.animationDuration=1.2f;
                imgvMask.animationRepeatCount=1;
                [imgvMask startAnimating];
            }
            imgvHealth.tag=buttonTagValue+3000;

            
            
            newButton.titleLabel.shadowOffset=CGSizeMake(-2.0, 2.0);
            [newButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [newButton setTitle:titleButton forState:UIControlStateNormal];
            UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, -150.0);
            newButton.titleEdgeInsets = titleInsets;
            [newButton setDate:circle.date];

            newButton.center=d.pointToDrawButton;


            d.pointIsEmpty=NO;
            newButton.tag=buttonTagValue;
            [newButton addTarget:self action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            [newButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [newButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
            
            newButton.alpha=0;
            
            __weak __block ButtonObjectClass* weakButton=newButton;
            __weak __block UIImageView *weakImgvMask=imgvMask;
            __weak __block UIImageView *weakImgv=imgvHealth;
            __weak CoordinatesController *weakD=d;
            

            
            [UIView animateWithDuration:animationDuration animations:
             ^{
                 weakButton.alpha=1.0f;
                 weakButton.transform=CGAffineTransformRotate(weakButton.transform, (weakD.degreeValue-180.0f)*PI/180.0f);

             } completion:^(BOOL finished){
                 @autoreleasepool {
                     if (!weakImgvMask.animationImages) {
                         [UIView animateWithDuration:1.4f animations:^{                 weakImgv.alpha=1.0f;
                         }];
                     }
                     else
                     {
                         if (animated) {
                             weakImgv.alpha=1.0f;
                         }
                     }
                     weakButton.degreeRotationValue=weakD.degreeValue-180;
                     weakButton.homePoint=weakButton.center;


                     [weakImgvMask stopAnimating];
                     weakImgvMask.animationImages=nil;
                     [weakImgvMask removeFromSuperview];
                     weakImgvMask=nil;
                     
                     if(weakSelf.animationAppearanceHealthImages)
                     {
                         [weakSelf.animationAppearanceHealthImages removeAllObjects];
                         weakSelf.animationAppearanceHealthImages=nil;
                     }
                     if (weakSelf.animationAppearanceHealthImages2)
                     {
                         [weakSelf.animationAppearanceHealthImages2 removeAllObjects];
                         weakSelf.animationAppearanceHealthImages2=nil;
                     }
                     
                 }
                 
             }];
            NSLog(@"-----New Button Health----");

            if (animated) {

                AppDelegate *pAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:[pAppDelegate managedObjectContext]];
                
                Fugitive *toDoAssignment = [[Fugitive alloc] initWithEntity:entity insertIntoManagedObjectContext:[pAppDelegate managedObjectContext]];
                
                toDoAssignment.type=@"Health";
                toDoAssignment.date = circle.date;
                toDoAssignment.desc=@"yours truly";
                toDoAssignment.isEnchiridion = [NSNumber numberWithBool:YES];
                toDoAssignment.isShown=[NSNumber numberWithBool:NO];
                toDoAssignment.name=[NSString stringWithFormat:@"diet%d",buttonTagValue];
                toDoAssignment.bounty = [NSDecimalNumber decimalNumberWithDecimal:
                                         [[NSNumber numberWithFloat:2.75f] decimalValue]];
                toDoAssignment.fugitiveID=[NSNumber numberWithInt:10];
                toDoAssignment.numberOfSubobj=[NSNumber numberWithInt:0];
                toDoAssignment.isReached = [NSNumber numberWithBool:NO];
                newButton.toDoAssignment=toDoAssignment;
                
                [parentVC dissmissMapDetailViewController:nil];

            }
            //если в базе данных уже присутствует данная цель
            else
            {
                //задаем свойство кнопки fugitive
                newButton.toDoAssignment=assignment;
            }

            
            
            if (numberOfCreatedHealthButtons%2==0)
            {
                UIImage *image = [UIImage imageNamed:@"h1_subobjective.png"];
                newButton.imageWithSubobjective=image;
                UIImage *image2 = [UIImage imageNamed:@"h.png"];
                newButton.imageWithNoSubobjective=image2;
                
                if ([newButton.toDoAssignment.numberOfSubobj intValue]>0) {
                    
                    [newButton setBackgroundImage:newButton.imageWithSubobjective forState:UIControlStateNormal];
                    [self setAnchorPoint:CGPointMake(0.6f, 0.5f) forView:newButton];
                    [newButton setButtonState:kButtonStateHasSubobjectives];

                }
                else
                {
                    [newButton setBackgroundImage:newButton.imageWithNoSubobjective forState:UIControlStateNormal];
                    [newButton setButtonState:kButtonStateNoSubobjective];

                }

            }
            else
            {
                UIImage *image = [UIImage imageNamed:@"h2_subobjective.png"];
                newButton.imageWithSubobjective=image;
                UIImage *image2 = [UIImage imageNamed:@"h2.png"];
                newButton.imageWithNoSubobjective=image2;
                if ([newButton.toDoAssignment.numberOfSubobj intValue]>0) {
                    [newButton setBackgroundImage:newButton.imageWithSubobjective forState:UIControlStateNormal];
                    [self setAnchorPoint:CGPointMake(0.6f, 0.3f) forView:newButton];
                }
                else
                {
                    [newButton setBackgroundImage:newButton.imageWithNoSubobjective forState:UIControlStateNormal];
                    [self setAnchorPoint:CGPointMake(0.5f, 0.4f) forView:newButton];

                }

            }
            
            [newButton sizeToFit];
            
            [weakSelf.view2 addSubview:newButton];

           
            
            numberOfCreatedHealthButtons++;

            
            break;
        }
        
        
    }
    if (numberOfCreatedHealthButtons>=[self.graphView.arrayHealthCoordinatesToDrawButton count]+[self.graphView2.arrayHealthCoordinatesToDrawButton count]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Нет больше мест для здоровья" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    }
    //[parentVC swapViewControllers];
    

    [health setSelected:NO];
}


-(void)createPrivateLifeButtonAt:(CircleView*)circle withTag:(int)buttonTagValue animated:(BOOL)animated toDoAssignment:(Fugitive*)assignment
{
    
    NSString *titleButton=[NSString stringWithFormat:@"Private Life %d",buttonTagValue-2];
    
    __weak CombinedViewController *parentVC=(CombinedViewController*)self.parentViewController;
    __weak __block MainMapViewController *weakSelf=self;

    
    for (CoordinatesController *d in circle.arrayPrivateLifeCoordinatesToDrawButton) {
        if (d.pointIsEmpty)
        {
            NSMutableArray *arrayOfTags=[NSMutableArray new];
            [arrayOfTags addObject:[NSNumber numberWithInt:buttonTagValue]];
            _arrayOfPrivateLifeTags=arrayOfTags;

            if (d.isPointConverted==NO) {
                [weakSelf convertViewtoMainMapCoordinates:d fromCircle:circle];
            }
            UIImageView *imgvPrivateLife;
            UIImageView *imgvMask;
            UIImage *image;
            CGFloat animationDuration = 1.1f;
            
            pLifeButton *newButton=[[pLifeButton alloc]init];
            newButton.center=d.pointToDrawButton;

            
            d.pointIsEmpty=NO;
            
            newButton.titleLabel.shadowOffset=CGSizeMake(-2.0, 2.0);
            [newButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
            [newButton setTitle:titleButton forState:UIControlStateNormal];
            UIEdgeInsets titleInsets = UIEdgeInsetsMake(-75.0, -150.0, 0.0, 0.0);
            newButton.titleEdgeInsets = titleInsets;
            newButton.tag=buttonTagValue;
            [newButton setDate:circle.date];
            
            
            if (numberOfCreatedPrivateLifeButtons%2==0)
            {
                image=[UIImage imageNamed:@"lastImageAppearance_p.png"];
                imgvPrivateLife=[[UIImageView alloc]initWithImage:image];
                
                if (animated) {
                    imgvMask=[[UIImageView alloc]initWithImage:[weakSelf.animationAppearancePrivateLifeImages lastObject]];
                    imgvMask.animationImages=weakSelf.animationAppearancePrivateLifeImages;
                }
                newButton.glitterType=kGlitterPrivateLife;
                if (animated) {
                    imgvPrivateLife.alpha=0.0f;
                    
                }
                [weakSelf appropriateTransformForUIImageView:imgvPrivateLife putItOnCoordinate:d needToScale:NO isFlip:NO withAnchorPoint:CGPointMake(170.0f/214.0f, 89.8f/166.0f)];

            }
            else
            {
                
                image=[UIImage imageNamed:@"lastImageAppearance_p2.png"];
                imgvPrivateLife=[[UIImageView alloc]initWithImage:image];
                
                if (animated) {
                    imgvMask=[[UIImageView alloc]initWithImage:[weakSelf.animationAppearancePrivateLifeImages2 lastObject]];
                    if ([weakSelf.animationAppearancePrivateLifeImages2 count]==30) {
                        imgvMask.animationImages=weakSelf.animationAppearancePrivateLifeImages2;
                    }
                }
               
                
                newButton.glitterType=kGlitterPrivateLife2;
                if (animated) {
                    imgvPrivateLife.alpha=0.0f;

                }
                
                [weakSelf appropriateTransformForUIImageView:imgvPrivateLife putItOnCoordinate:d needToScale:NO isFlip:NO withAnchorPoint:CGPointMake(170.0f/214.0f, 89.8f/166.0f)];

            }
            if (!animated) {
                imgvMask.alpha=0.0f;
                animationDuration=0.45f;
            }
            if (imgvMask.animationImages==nil) {
                imgvMask.alpha=0.0f;
            }
                       
                    
            [newButton addTarget:weakSelf action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            [newButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            [newButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
            
            [weakSelf.view2 addSubview:newButton];
            
            
            imgvPrivateLife.tag=newButton.tag+4000;
            if (animated) {
                [weakSelf appropriateTransformForUIImageView:imgvMask putItOnCoordinate:d needToScale:YES isFlip:NO withAnchorPoint:CGPointMake(170.0f/214.0f, 90.0f/166.0f)];

                imgvMask.animationDuration=1.1;
                imgvMask.animationRepeatCount=1;
                [imgvMask startAnimating];
            }
           
            newButton.alpha=0.0;
            
                     
            __weak __block ButtonObjectClass* weakButton=newButton;
            __weak __block UIImageView *weakImgvMask=imgvMask;
            __weak __block UIImageView *weakImgv=imgvPrivateLife;
            __weak CoordinatesController *weakD=d;

            
            [UIView animateWithDuration:animationDuration animations:^{
                
                weakButton.alpha=1.0f;
                weakButton.transform=CGAffineTransformRotate(weakButton.transform, (weakD.degreeValue)*PI/180.0f);
            
            } completion:^(BOOL finished)
             {
                 @autoreleasepool {
                     //checking if animation is not fired
                     if (!weakImgvMask.animationImages) {
                         //then animation with smooth appearance
                         [UIView animateWithDuration:1.4f animations:^{                 weakImgv.alpha=1.0f;
                         }];
                     }
                     else
                     {
                         if (animated) {
                             weakImgv.alpha=1.0f;
                         }
                     }
                     
                     [weakImgvMask stopAnimating];
                     weakImgvMask.animationImages=nil;
                     [weakImgvMask removeFromSuperview];
                     weakImgvMask=nil;
                     if(weakSelf.animationAppearancePrivateLifeImages)
                     {
                         [weakSelf.animationAppearancePrivateLifeImages removeAllObjects];
                         weakSelf.animationAppearancePrivateLifeImages=nil;
                     }
                     if (weakSelf.animationAppearancePrivateLifeImages2)
                     {
                         [weakSelf.animationAppearancePrivateLifeImages2 removeAllObjects];
                         weakSelf.animationAppearancePrivateLifeImages2=nil;
                     }
                     weakButton.degreeRotationValue=weakD.degreeValue;
                     weakButton.homePoint=weakButton.center;


                     
             }

             }];
            
            NSLog(@"-----New Button pLife-----");
            if (animated) {
                [parentVC dissmissMapDetailViewController:nil];

                AppDelegate *pAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:[pAppDelegate managedObjectContext]];
                
                Fugitive *toDoAssignment = [[Fugitive alloc] initWithEntity:entity insertIntoManagedObjectContext:[pAppDelegate managedObjectContext]];
                
                toDoAssignment.type=@"Private Life";
                toDoAssignment.date = circle.date;
                toDoAssignment.desc=@"something that needs to fill";
                toDoAssignment.isEnchiridion = [NSNumber numberWithBool:YES];
                toDoAssignment.isShown=[NSNumber numberWithBool:NO];
                toDoAssignment.name=[NSString stringWithFormat:@"to find lover%d",buttonTagValue];
                toDoAssignment.bounty = [NSDecimalNumber decimalNumberWithDecimal:
                                         [[NSNumber numberWithFloat:2.75f] decimalValue]];
                toDoAssignment.fugitiveID=[NSNumber numberWithInt:11];
                toDoAssignment.numberOfSubobj=[NSNumber numberWithInt:0];
                toDoAssignment.isReached = [NSNumber numberWithBool:NO];

                
                newButton.toDoAssignment=toDoAssignment;
            }
            //если в базе данных уже присутствует данная цель
            else
            {
                //задаем свойство кнопки fugitive
                newButton.toDoAssignment=assignment;
            }
            
            UIImage *imageSubobj = [UIImage imageNamed:@"p1_main_subobjective.png"];
            newButton.imageWithSubobjective=imageSubobj;
            UIImage *image2 = [UIImage imageNamed:@"p.png"];
            newButton.imageWithNoSubobjective=image2;

            if ([newButton.toDoAssignment.numberOfSubobj intValue]>0) {
                
                [newButton setBackgroundImage:newButton.imageWithSubobjective forState:UIControlStateNormal];
                [self setAnchorPoint:CGPointMake(0.6f, 0.5f) forView:newButton];
                [newButton setButtonState:kButtonStateHasSubobjectives];
                
            }
            else
            {
                [newButton setBackgroundImage:newButton.imageWithNoSubobjective forState:UIControlStateNormal];
                [newButton setButtonState:kButtonStateNoSubobjective];
                
            }

            [newButton sizeToFit];

            
            numberOfCreatedPrivateLifeButtons++;

            break;
        }
        
        
    }
    if (numberOfCreatedPrivateLifeButtons>=[weakSelf.graphView.arrayPrivateLifeCoordinatesToDrawButton count]+[weakSelf.graphView2.arrayPrivateLifeCoordinatesToDrawButton count]) {
        [[[UIAlertView alloc]initWithTitle:nil message:@"Нет больше мест для личной жизни" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    }
    //[parentVC swapViewControllers];

    [privateLife setSelected:NO];

}

-(void)appropriateTransformForUIImageView:(UIImageView*)imgv putItOnCoordinate:(CoordinatesController*)d needToScale:(BOOL)needToScale isFlip:(BOOL)isFlip withAnchorPoint:(CGPoint)anchorPoint
{
    __weak MainMapViewController *weakSelf=self;
    CGFloat flipAngle=0.0f;
    if (isFlip) {
        flipAngle=180.0f;
    }
    if (needToScale) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        {
            // Retina display
            imgv.transform=CGAffineTransformScale(imgv.transform, 0.5f, 0.5f);
        }
        
    }
        [weakSelf setAnchorPoint:anchorPoint forView:imgv];

        imgv.transform= CGAffineTransformRotate(imgv.transform, (d.degreeValue-flipAngle)*PI/180.0f);
    imgv.layer.position=d.pointToDrawButton;
    
    [weakSelf.view2 insertSubview:imgv belowSubview:mainCommas];
    
}


-(void)updateToDoList:(NSDate*)date
{
    __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
    NSUInteger count=0;
    [parentVC requestImplement:date];
    NSString *titleString=[NSString stringWithFormat:@"\ntoDoList after updating.. Total number of objective in DataBase:%d. Here is the list:",[parentVC.toDoList count]];
    NSString *listOfObjectives=@"";
    NSString *finalList;
    for (Fugitive *toDoAssignment in parentVC.toDoList)
    {
        NSString *dateString=[NSString stringWithFormat:@"%d/%d/%d",[MainMapViewController getDayIntegerFromDate:toDoAssignment.date],[MainMapViewController getMonthIntegerFromDate:toDoAssignment.date],[MainMapViewController getYearIntegerFromDate:toDoAssignment.date]];
        NSString *objectiveProperties=[NSString stringWithFormat:@"\r\nName of assignment:%@\ndescription:%@\ntype:%@\nnumberOfSubobjectives:%d\nDate:%@",toDoAssignment.name,toDoAssignment.desc,toDoAssignment.type,
        [toDoAssignment.numberOfSubobj intValue],dateString];
        if (count==0) {
            NSString *title=[titleString stringByAppendingString:objectiveProperties];
            finalList=[listOfObjectives stringByAppendingString:title];
        }
        else
        {
            finalList=[finalList stringByAppendingString:objectiveProperties];
        }
        count++;
    }
    NSLog(@"%@",finalList);

}

-(BOOL)viewIntersectsWithAnotherView:(UIView*)selectedView inView:(UIView*)containerView
{
  
    if (CGRectIntersectsRect(selectedView.frame, containerView.frame))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark- GestureRecognizer Methods
-(IBAction)swipeToRightAndDismissDetailView:(id)sender
{
    UIPanGestureRecognizer *grecognizer = (UIPanGestureRecognizer*)sender;

    if (self.isDetailViewOn)
    {
    
        CGPoint translation = [grecognizer translationInView:grecognizer.view];
        CGPoint vel = [grecognizer velocityInView:self.view];
        
        if (self.mapDetailsViewController.view.frame.origin.x>1024.0f)
        {
            CGRect frame = self.mapDetailsViewController.view.frame;
            frame.origin=CGPointMake(1024.0f, frame.origin.y);
            self.mapDetailsViewController.view.frame = frame;
        }

        
        if (self.mapDetailsViewController.view.frame.origin.x>_mapDetailFrame.origin.x+50.0f)
        {
             self.mapDetailsViewController.view.center=CGPointMake(self.mapDetailsViewController.view.center.x+translation.x,self.mapDetailsViewController.view.center.y);
            if (vel.x>0)
            {
                if (self.view2.center.x<self.background.center.x)
                {
                    if (self.view2.center.x+translation.x<self.background.center.x)
                    {
                        self.view2.transform=CGAffineTransformScale(self.view2.transform, self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x), self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x));
                        self.view2.center=CGPointMake(self.view2.center.x+0.5f*translation.x,self.background.center.y);

                    }
                    else
                    
                        [UIView animateWithDuration:0.50f animations:^{
                           // self.view2.transform=_mainMapViewTransformIdentity;
                            self.view2.center=self.background.center;

                        }];
                    
                    }
            }
            else if (vel.x<0)
            {
                if (self.mapDetailsViewController.view.frame.origin.x<=1024.0f)
                {
                    self.view2.transform=CGAffineTransformScale(self.view2.transform, self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x), self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x));

                    self.view2.center=CGPointMake(self.view2.center.x+0.5f*translation.x,self.background.center.y);
                }
                
            }
        
        }
        else if ((self.mapDetailsViewController.view.frame.origin.x==_mapDetailFrame.origin.x)&&(vel.x>0))
        {
           
            self.mapDetailsViewController.view.center=CGPointMake(self.mapDetailsViewController.view.center.x+translation.x,self.mapDetailsViewController.view.center.y);
            

        }
        else if ((vel.x<0)&&(self.mapDetailsViewController.view.frame.origin.x<=_mapDetailFrame.origin.x+50.0f))
        {
            if (self.mapDetailsViewController.view.center.x+translation.x>_mapDetailFrame.size.width/2+_mapDetailFrame.origin.x)
            {
                self.mapDetailsViewController.view.center=CGPointMake(self.mapDetailsViewController.view.center.x+translation.x,self.mapDetailsViewController.view.center.y);
                self.view2.center=CGPointMake(self.view2.center.x+0.5f*translation.x,self.background.center.y);

            }
            else if (self.mapDetailsViewController.view.center.x+translation.x<_mapDetailFrame.size.width/2+_mapDetailFrame.origin.x)
            {
                
                self.mapDetailsViewController.view.frame=_mapDetailFrame;
            }

        }
        else
        {
            self.mapDetailsViewController.view.center=CGPointMake(self.mapDetailsViewController.view.center.x+translation.x,self.mapDetailsViewController.view.center.y);
            self.view2.transform=CGAffineTransformScale(self.view2.transform, self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x), self.mapDetailsViewController.view.frame.origin.x/(self.mapDetailsViewController.view.frame.origin.x-translation.x));
            self.view2.center=CGPointMake(self.view2.center.x+0.5f*translation.x,self.background.center.y);


        }
       
        if (grecognizer.state==UIGestureRecognizerStateEnded) {
            if (vel.x>0) {
                __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
                [privateLife setSelected:NO];
                [_finance setSelected:NO];
                [health setSelected:NO];
                [parentVC dissmissMapDetailViewController:grecognizer];
                
                @autoreleasepool {
                    __weak MainMapViewController *weakSelf=self;
                    if(weakSelf.animationAppearanceHealthImages)
                    {
                        [weakSelf.animationAppearanceHealthImages removeAllObjects];
                        weakSelf.animationAppearanceHealthImages=nil;
                    }
                    if (weakSelf.animationAppearanceFinanceImages)
                    {
                        [weakSelf.animationAppearanceFinanceImages removeAllObjects];
                        weakSelf.animationAppearanceFinanceImages=nil;
                    }
                    if (weakSelf.animationAppearanceFinanceImages2)
                    {
                        [weakSelf.animationAppearanceFinanceImages2 removeAllObjects];
                        weakSelf.animationAppearanceFinanceImages2=nil;
                    }
                    
                }
                _touchSwallowRotationEnabled=YES;
            }
            else
            {
                CGFloat duration = ABS((self.mapDetailsViewController.view.frame.origin.x-_mapDetailFrame.origin.x)/vel.x);
                if ((duration>1.0f)||(duration<0.65)) {
                    duration=0.65f;
                }
                [UIView animateWithDuration:duration animations:
                 ^{
                    self.mapDetailsViewController.view.frame=_mapDetailFrame;
                    self.view2.transform=_mainMapView2AffineTransform;
                    self.view2.frame=_mainMapView2Frame;
                }];
            }

            }
            [grecognizer setTranslation:CGPointMake(0.0f, 0.0f) inView:grecognizer.view];

    }
   
    
    


}

-(IBAction)swipeHandle:(id)sender
{
    NSLog(@"swipe recognizer");
}


-(void)zoomOutPinch:(UIPinchGestureRecognizer *)sender
{
    NSLog(@"Pinch Gesture recognized");

    if ([sender state] == UIGestureRecognizerStateBegan)
    {
        _lastScalePinch = [sender scale];
    }
    
    if (([sender state] == UIGestureRecognizerStateBegan)||([sender state]==UIGestureRecognizerStateChanged))
    {
        CGFloat currentScale = [[[sender view].layer valueForKeyPath:@"transform.scale"]floatValue];
        //constants to adjust the max/min values of zoom
        
        const CGFloat kMaxScale = 1.0f;
        const CGFloat kMinScale = 0.75f;
        
        CGFloat newScale = 1 - (_lastScalePinch - [sender scale]);
        newScale = MIN(newScale,kMaxScale/currentScale);
        newScale = MAX(newScale, kMinScale/currentScale);
        
        CGAffineTransform transform = CGAffineTransformScale([[sender view]transform], newScale, newScale);
        
        [sender view].transform = transform;
        _lastScalePinch = [sender scale];
    }
    else if ([sender state]==UIGestureRecognizerStateEnded)
    {

        if ([sender scale]>=0.75f) {
            __weak MainMapViewController *weakSelf=self;
            [UIView animateWithDuration:0.4f animations:^{
                weakSelf.view2.transform=CGAffineTransformIdentity;}];
        }
        else
        {
        __weak MainMapViewController *weakSelf=self;
        [UIView animateWithDuration:0.8f animations:^{
            weakSelf.view2.transform=CGAffineTransformScale(weakSelf.view2.transform, 0.5f, 0.5f);}];
        NSOperationQueue *queue=[NSOperationQueue new];
            NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(updateToDoList:) object:self.graphView.date];
            
        [queue addOperation:operation];

        __weak CombinedViewController * parentVC = (CombinedViewController*)self.parentViewController;
        [parentVC pushViewControllers];
        }

    }
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ((!self.isDetailViewOn)&&(_touchSwallowRotationEnabled))
    {
        if ([touch.view isKindOfClass:[ButtonObjectClass class]])
        {
            return NO;
        }
        else
        {
            return YES;
        }

        if (self.rotateGestureRecognizer.state==UIGestureRecognizerStateBegan)
        {
            return NO;
        }
        else
        {
            return YES;
        }
               
    }
    else
    {
        if ([touch.view isKindOfClass:[ButtonObjectClass class]])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
        
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ((!self.isDetailViewOn)&&(_touchSwallowRotationEnabled))
    {
        
        if (self.rotateGestureRecognizer.state==UIGestureRecognizerStateBegan)
        {
            return NO;
        }
        else
        {
            return YES;
        }

    }
    else
    {
        return YES;
    }
}
#pragma mark- setting the date methods

+(NSDate*)getNextDayOf:(NSDate*)yourDate
{
// start by retrieving day, weekday, month and year components for yourDate
NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yourDate];
NSInteger theDay = [todayComponents day];
NSInteger theMonth = [todayComponents month];
NSInteger theYear = [todayComponents year];

// now build a NSDate object for yourDate using these components
NSDateComponents *components = [[NSDateComponents alloc] init];
[components setDay:theDay];
[components setMonth:theMonth];
[components setYear:theYear];
NSDate *thisDate = [gregorian dateFromComponents:components];

// now build a NSDate object for the next day
NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
[offsetComponents setDay:1];
NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
return nextDate;
}


+(NSInteger)getDayIntegerFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSDayCalendarUnit
                                               fromDate:date];
    NSInteger day = [components day];
    return day;
    
}

+(NSInteger)getMonthIntegerFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSMonthCalendarUnit
                                               fromDate:date];
    NSInteger month = [components month];
    return month;    
}

+(NSInteger)getYearIntegerFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit
                                               fromDate:date];
    NSInteger year = [components year];
    return year;

}

+(NSDate*)setDateByComponentDay:(NSInteger)day byMonth:(NSInteger)month andByYear:(NSInteger)year
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];
    return date;
}

#pragma mark- animation inizialization

-(void)createAnimationIfNeeded
{
    __block __weak MainMapViewController *weakSelf=self;
    NSOperationQueue* queueMainCenterAnimation = [[NSOperationQueue alloc] init];
    [queueMainCenterAnimation addOperationWithBlock: ^(void) {
        
        if (!weakSelf.animationMainCenterFinanceImages) {
            Animations *animation4=[[Animations alloc]init];

            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                animation4.nameImage=@"mainAnimationCenterFinance@2x.png";
                
            }
            else
            {
                animation4.nameImage=@"mainAnimationCenterFinance.png";
            }
            animation4.animationType=kMainAnimationCenterFinance;
            weakSelf.animationMainCenterFinanceImages=[weakSelf createAnimation:animation4];
            
        }
                
    }];
    
    
}

-(void)createAnimationOnAnotherThread:(Animations*)animation
{
    __weak MainMapViewController *weakSelf=self;
    switch (animation.animationForButtonType)
    {
        case kFinanceTypeButton:
            
            switch (animation.animationType) {
                case kAppearanceAnimationFinance:
                    
                    if (weakSelf.animationAppearanceFinanceImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_f"];
                      
                                [weakSelf.animationAppearanceFinanceImages removeAllObjects];
                                weakSelf.animationAppearanceFinanceImages=nil;
                            weakSelf.animationAppearanceFinanceImages=[weakSelf createAnimation:animation];
                                          }
                    break;
                    
                case kAppearanceAnimationFinance2:
                    
                    if (weakSelf.animationAppearanceFinanceImages2==nil) {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_f2"];
                         weakSelf.animationAppearanceFinanceImages2=[weakSelf createAnimation:animation];
                    }
                    
                    break;
                    
                case kGlitterAnimationFinance:
                    
                    if (weakSelf.animationGlitterFinanceImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_f"];
                        weakSelf.animationGlitterFinanceImages=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kGlitterAnimationFinance2:
                    
                    if (weakSelf.animationGlitterFinanceImages2==nil) {
                        
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_f2"];
                        weakSelf.animationGlitterFinanceImages2=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                default:
                    NSLog(@"Unknown animationType for finance button! Error.");
                    break;
            }
            break;
            
            
        case kHealthTypeButton:
            
            switch (animation.animationType) {
                    
                case kAppearanceAnimationHealth:
                    if (weakSelf.animationAppearanceHealthImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_h_flip"];
                        weakSelf.animationAppearanceHealthImages=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kAppearanceAnimationHealth2:
                    if (weakSelf.animationAppearanceHealthImages2==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_h2_flip"];
                        weakSelf.animationAppearanceHealthImages2=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kGlitterAnimationHealth:
                    if (weakSelf.animationGlitterHealthImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_h_flip"];
                        weakSelf.animationGlitterHealthImages=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kGlitterAnimationHealth2:
                    if (weakSelf.animationGlitterHealthImages2==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_h2_flip"];
                        weakSelf.animationGlitterHealthImages2=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                default:
                    NSLog(@"Unknown animation type for health button! Error.");
                    break;
            }
            break;
            
        case kPrivateLifeButton:
            switch (animation.animationType) {
                    
                case kAppearanceAnimationPrivateLife:
                    if (weakSelf.animationAppearancePrivateLifeImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_p"];
                        weakSelf.animationAppearancePrivateLifeImages=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kAppearanceAnimationPrivateLife2:
                    if (weakSelf.animationAppearancePrivateLifeImages2==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"appearance_connection_p2"];
                        
                        [weakSelf.animationAppearancePrivateLifeImages2 removeAllObjects];
                        weakSelf.animationAppearancePrivateLifeImages2=nil;

                        
                        weakSelf.animationAppearancePrivateLifeImages2=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kGlitterAnimationPrivateLife:
                    if (weakSelf.animationGlitterPrivateLifeImages==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_p"];
                       weakSelf.animationGlitterPrivateLifeImages=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                case kGlitterAnimationPrivateLife2:
                    if (weakSelf.animationGlitterPrivateLifeImages2==nil)
                    {
                        animation.nameImage=[weakSelf createRetinaNameIfNeeded:@"glitter_connection_p2"];
                        weakSelf.animationGlitterPrivateLifeImages2=[weakSelf createAnimation:animation];
                    }
                    break;
                    
                default:
                    NSLog(@"Unknown animation type for private life button");
                    break;
            }
            break;
            
        default:
            NSLog(@"Unknown button tag! Error.");
            break;
            
    }
    
}

-(NSString*)createRetinaNameIfNeeded:(NSString*)name
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        // Retina display
        name=[NSString stringWithFormat:@"%@_retina.png",name];
    }
    else
    {
        name=[NSString stringWithFormat:@"%@.png",name];
    }
    return name;
    
}
       

- (NSMutableArray*)createAnimation:(Animations*)animation
        {

           UIImage* image =[[UIImage alloc]initImmediateLoadWithContentsOfFile:[[NSBundle mainBundle]pathForResource:animation.nameImage ofType:nil]];
            NSMutableArray *animationImages = [NSMutableArray array];
        
        int numberOfFrames=0;
        CGFloat width=0, height=0;
        BOOL isFlip=NO;
        
        //finance:
        //
        //main:
        //32 images
        //75 width, 75 height
        //
        //1:
        //27 images for glitter
        //46 images for appearance
        //height=72, width=217
        //
        //2:
        //25 images for appearance
        //22 images for glitter
        //height=72, width=216
        
        //health:
        //
        //main
        //29 images
        //75, 75 h/w
        //
        //1:
        //36 images for appearance
        //20 images for glitter
        //height=73, width=218 appearance
        //height 73, width 218.0 glitter
        //
        //2:
        //35 images for appearance
        //22 images for glitter
        //height=75, width=217
        
        //Private Life:
        //
        //main
        //
        //6 images
        //w/h:75,72
        //
        //44 images appearance
        //height=73.0f, width 214.0f
        //22 images for glitter;
        //height=73.0f,width=214.0f;
        //
        //2:
        //30 images for appearance
        //22 images for glitter
        //height=72.0f, width=214.0f;
        if (animation.animationType==kMainAnimationCenterFinance)
        {
            NSLog(@"Creating glitterMainFinanceAnimation");
            numberOfFrames=32;
            
                if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                    ([UIScreen mainScreen].scale == 2.0))
                    {
                    // Retina display
                    height=177.0f;
                    width=177.0f;
                    }
                else
                    {
                        height=75.0f;
                        width=75.0f;
                    }
            
        }
        else if (animation.animationType==kMainAnimationCenterPrivateLife)
        {
            numberOfFrames=6;
            height=72.0f;
            width=75.0f;
        }
        else if (animation.animationType==kAppearanceAnimationFinance)
        {
            NSLog(@"Creating kAppearanceAnimationFinance");
            
            numberOfFrames=46;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
                {
                // Retina display
                    height=143.0f;
                    width=434.0f;
                }
                else
                {
                    height=72.0f;
                    width=217.0f;
                
                }
            
            
        }
        else if (animation.animationType==kAppearanceAnimationFinance2)
        {
            NSLog(@"Creating kAppearanceAnimationFinance2");
            numberOfFrames=25;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                height=144.0f;
                width=432.0f;
            }
            else
            {
                height=72.0f;
                width=216.0f;
            }
            
        }
        else if (animation.animationType==kGlitterAnimationFinance)
        {
            NSLog(@"Creating kGlitterAnimationFinance");
            numberOfFrames=27;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=143.0f;
                width=434.0f;
            }
            else
            {
                height=72.0f;
                width=217.0f;
            }
            
        }
        else if (animation.animationType==kGlitterAnimationFinance2)
        {
            NSLog(@"Creating kGlitterAnimationFinance2");
            
            numberOfFrames=22;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=144.0f;
                width=432.0f;
            }
            else
            {
                height=72.0f;
                width=216.0f;
            }
        }
        else if (animation.animationType==kAppearanceAnimationHealth)
        {
            NSLog(@"Creating kAppearanceAnimationHealth");
            
            numberOfFrames=36;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=146.0f;
                width=436.0f;
            }
            else {
                height=73.0f;
                width=218.0f;
            }
            
        }
        else if (animation.animationType==kAppearanceAnimationHealth2)
        {
            NSLog(@"Creating kAppearanceAnimationHealth2");
            
            numberOfFrames=36;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=149.0f;
                width=434.0f;
            }
            else
            {
                height=75.0f;
                width=217.0f;
            }
            isFlip=YES;
        }
        else if (animation.animationType==kGlitterAnimationHealth)
        {
            NSLog(@"Creating kGlitterAnimationHealth");
            
            numberOfFrames=20;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=146.0f;
                width=436.0f;
            }
            else
            {
                height=73.0f;
                width=218.0f;
            }
            
        }
        else if (animation.animationType==kGlitterAnimationHealth2)
        {
            NSLog(@"Creating kGlitterAnimationHealth2");
            
            numberOfFrames=21;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
            {
                // Retina display
                height=149.0f;
                width=434.0f;
            }
            else
            {
                height=75.0f;
                width=217.0f;
            }
            isFlip=YES;
        }
        else if (animation.animationType==kAppearanceAnimationPrivateLife)
        {
            NSLog(@"Creating kAppearanceAnimationPrivateLife");
            
            numberOfFrames=44;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                width=446.0f;
                height=156.0f;
            }
            else
            {
                height=73.0f;
                width=214.0f;
            }
            
        }
        else if (animation.animationType==kGlitterAnimationPrivateLife)
        {
            NSLog(@"Creating kGlitterAnimationPrivateLife");
            
            numberOfFrames=22;
            height=73.0f;
            width=214.0f;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                height=156;
                width=446;
            }
            
        }
        else if (animation.animationType==kAppearanceAnimationPrivateLife2)
        {
            NSLog(@"Creating kAppearanceAnimationPrivateLife2");
            numberOfFrames=30;
            height=72.0f;
            width=214.0f;
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                height*=2;
                width*=2;
            }
        }
        else if (animation.animationType==kGlitterAnimationPrivateLife2)
            
        {
            NSLog(@"Creating kGlitterAnimationPrivateLife2");
            
            numberOfFrames=22;
            height=72.0f;
            width=214.0f;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0)) {
                // Retina display
                height*=2;
                width*=2;
            }
            
            
        }
        
        for (int i = 0; i<numberOfFrames; i++)
        {
           
    
            CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,
                                                               CGRectMake(i*width, 0.0f, width, height));
            UIImage *animationImage = [[UIImage alloc]initWithCGImage:imageRef];
            
            if (isFlip)
            {
                [animationImages insertObject:animationImage atIndex:0];
            }
            else
            {
                [animationImages addObject:animationImage];
            }
            animationImage=nil;
            CGImageRelease(imageRef);
            imageRef=nil;
            
            
        }
        
        isFlip=NO;
            
        
        switch (animation.animationType) {
                
            case kMainAnimationCenterFinance:

                if (animationImages) NSLog(@"mainCenterFinanceAnimationCreated");
                break;
                
            case kMainAnimationCenterPrivateLife:
                if (self.animationMainCenterPrivateLifeImages) NSLog(@"animationMainCenterPrivateLifeImages created");
                break;
                
            case kAppearanceAnimationFinance:
                if (animationImages) NSLog(@"kAppearanceAnimationFinance created");
                break;
                
            case kAppearanceAnimationFinance2:
                if (animationImages) NSLog(@"kAppearanceAnimationFinance2 created");
                break;
                
            case kAppearanceAnimationHealth:
                if (animationImages) NSLog(@"kAppearanceAnimationHealth created");
                break;
                
            case kAppearanceAnimationHealth2:
                if (animationImages) NSLog(@"kAppearanceAnimationHealth2 created");
                break;
                
            case kAppearanceAnimationPrivateLife:
                if (animationImages) NSLog(@"kAppearanceAnimationPrivateLife created");
                break;
                
            case kAppearanceAnimationPrivateLife2:
                if (animationImages) NSLog(@"kAppearanceAnimationPrivateLife2 created");
                break;
                
            case kGlitterAnimationPrivateLife:
                if (animationImages) NSLog(@"kGlitterAnimationPrivateLife created");
                break;
                
            case kGlitterAnimationPrivateLife2:
                if (animationImages) NSLog(@"kGlitterAnimationPrivateLife2 created");
                break;
                
            case kGlitterAnimationHealth:
                if (animationImages) NSLog(@"kGlitterAnimationHealth created");
                break;
                
            case kGlitterAnimationHealth2:
                if (animationImages) NSLog(@"kGlitterAnimationHealth2 created");
                break;
                
            case kGlitterAnimationFinance:
                if (animationImages) NSLog(@"kGlitterAnimationFinance created");
                break;
                
            case kGlitterAnimationFinance2:
                if (animationImages) NSLog(@"kGlitterAnimationFinance2 created");
                break;

        }
        image=nil;
        return animationImages;
    
    
}




@end
