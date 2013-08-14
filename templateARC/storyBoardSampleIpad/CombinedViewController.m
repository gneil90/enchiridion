//
//  ViewController.m
//  storyBoardSampleIpad
//
//  Created by Mac Owner on 2/9/13.
//
//

#import "CombinedViewController.h"
#import "macros.h"
#import "MapDetailsViewController.h"
#import "MainMapViewController.h"
#import "MenuViewController.h"
#import "MainMapZoomOutViewController.h"
#import <CoreData/CoreData.h>
#import "Animations.h"
#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImmediateLoading.h"
#import "CacheController.h"
#import "Fugitive.h"
#import "RuneButton.h"
#import "MainMapZoomInViewController.h"
#import "ObjectiveButtonClass.h"
#import "MenuThreeButtonsViewController.h"
#import "NSDate+GetDayInteger.h"

@interface CombinedViewController ()

@property (strong,nonatomic) MainMapZoomOutViewController *currentViewControllerZoomOut;

//background
@property (strong,nonatomic,readwrite) UIImage *backgroundMainView;

//animations
@property (strong,nonatomic,readwrite) NSArray *animationMainCenterFinanceImages;
@property (strong,nonatomic,readwrite) NSArray *animationMainCenterPrivateLifeImages;


//images for buttons
//mainView:

@property (strong,nonatomic,readwrite) UIImage *healthMainViewImage;
@property (strong,nonatomic,readwrite) UIImage *privateLifeMainViewImage;
@property (strong,nonatomic,readwrite) UIImage *financeMainViewImage;

//zoomOutView:
@property (strong,nonatomic,readwrite) UIImage *healthZoomOutImage;
@property (strong,nonatomic,readwrite) UIImage *privateLifeZoomOutImage;
@property (strong,nonatomic,readwrite) UIImage *financeZoomOutImage;
@property (strong,nonatomic,readwrite) UIImage *circleMonthImage;
@property (strong,nonatomic,readwrite) UIImage *screenShotZoomOutImage;



@end

@implementation CombinedViewController
{
    CGFloat offsetX, offsetY;
}

-(void)loadView
{
    [super loadView];
    
    //[self createMonthCircles];
    
    __autoreleasing UIImage *circle31=[UIImage imageNamed:@"31withBack.png"];

    self.circleMonthImage=circle31;
    
    __autoreleasing UIImage *healthImage=[UIImage imageNamed:@"h.png"];
    self.healthMainViewImage=healthImage;
    
    __autoreleasing UIImage *privateLifeImage=[UIImage imageNamed:@"p.png"];
    self.privateLifeMainViewImage=privateLifeImage;
    
    __autoreleasing UIImage *financeImage=[UIImage imageNamed:@"f.png"];
    self.financeMainViewImage=financeImage;
        
    __autoreleasing UIImage *backgroundMainView=[UIImage imageNamed:@"background.png"];
    self.backgroundMainView=backgroundMainView;
    
    __autoreleasing UIImage *imageScreenShot = [UIImage imageNamed:@"screenShotImage.png"];
    
    self.screenShotZoomOutImage = imageScreenShot;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   	// Do any additional setup after loading the view, typically from a nib.
    //MapDetailsViewController *mapDetailsViewController=(MapDetailsViewController*)[((UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailsStoryboard"]).viewControllers lastObject];
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MapDetailsStoryboard" bundle:nil];

   
    //navCon.navigationBarHidden=NO;
    self.mapDetailsViewController=(MapDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MapDetailStoryboard"];
    CGRect detailMapFrame=CGRectMake(1024,-3,400,753);
    self.mapDetailsViewController.view.frame=detailMapFrame;
    self.mainMapViewController.mapDetailsViewController=self.mapDetailsViewController;
    [self addChildViewController:self.mapDetailsViewController];
   // [self.navController.view layoutSubviews];
    [self.view insertSubview:self.mapDetailsViewController.view aboveSubview:self.mainMapViewController.view];
   //[[self navController] pushViewController:self.mapDetailsViewController animated:YES];
    [self.mapDetailsViewController didMoveToParentViewController:self];
    self.mainMapViewController.mapDetailsViewController=self.mapDetailsViewController;
    [self requestImplement:nil];
    __weak __block CombinedViewController *weakSelf=self;
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock: ^(void) {
        
           UIImage *fractalPersonalityImage  = [[UIImage alloc] initImmediateLoadWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [weakSelf createRetinaNameIfNeeded:@"fractal_personality"] ofType: nil]];
        weakSelf.fractalPersonality=fractalPersonalityImage;
        
      // UIImage* backgroundZoomView=[[UIImage alloc] initImmediateLoadWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"31withBack.png" ofType: nil]];
        //weakSelf.backgroundZoomView=backgroundZoomView;
        
    }];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning received...");
    // Dispose of any resources that can be recreated.
    [CacheController destroySharedInstance];
   
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"EmbedMainMap"])
    {
               
        self.mainMapViewController=segue.destinationViewController;

        [self addChildViewController:segue.destinationViewController];
        [segue.destinationViewController didMoveToParentViewController:self];

        
    }
    else if ([segue.identifier isEqualToString:@"EmbedMenu"])
    {
     
        self.menuViewController =
        segue.destinationViewController;
         [self addChildViewController:segue.destinationViewController];
        [segue.destinationViewController didMoveToParentViewController:self];

        
    }
    else if ([segue.identifier isEqualToString:@"EmbedDetails"])
    {

        // self.mapDetailsViewController=segue.destinationViewController;
         //[self addChildViewController:self.mapDetailsViewController];
        //[self.mapDetailsViewController didMoveToParentViewController:self];
        
    }

}

-(BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark- View Controller manupulation methods

-(void)backToMainMapViewControllerForDateFromZoomInViewController:(NSDate*)dateOfFirstCircle
{
    @autoreleasepool {
        NSLog(@"starting to launch main map view controller and transition from main map zoom in controller.");
        __weak MainMapViewController *mainMapViewController = (MainMapViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainMapStoryboard"];
        mainMapViewController.date=dateOfFirstCircle;
        __weak __block MainMapZoomInViewController *weakMainMapZoomInViewController = self.mainMapZoomInViewController;
        __weak __block CombinedViewController *weakSelf = self;

        CGAffineTransform transformScale=CGAffineTransformScale(weakMainMapZoomInViewController.circle.transform, 1/1.4f, 1/1.4f);
        BOOL isLandscape=UIDeviceOrientationIsLandscape(weakMainMapZoomInViewController.interfaceOrientation);
        CGPoint centerOfView;
        if (isLandscape) {
            centerOfView=CGPointMake(838.0f/2.0f, 753.0f/2.0f);
        }
        self.mainMapViewController=mainMapViewController;
        // Add this image as a subview to the tab bar controller
        
        [self.mainMapZoomInViewController willMoveToParentViewController:nil];
        [self addChildViewController:mainMapViewController];
        CGRect mainMapFrame=mainMapViewController.view.frame;
        mainMapViewController.showAssignmentsWithDelay=NO;
        [weakSelf.view insertSubview:weakSelf.mainMapViewController.view belowSubview:self.mainMapZoomInViewController.view];

        if (isLandscape)
        {
            mainMapFrame.origin=CGPointMake(186.0f, -3.0f);
            mainMapFrame.size=CGSizeMake(838.0f, 753.0f);
            
            mainMapViewController.view.frame=mainMapFrame;
            NSLog(@"MainMapOutOrientation is Landscape while initializing.");
            
        }
        
        [UIView animateWithDuration:0.45f animations:
         ^{
            for (UIView *subview in weakMainMapZoomInViewController.view2.subviews)
            {
                if ((![subview isEqual:weakMainMapZoomInViewController.circle])&&(![subview isEqual:weakMainMapZoomInViewController.containerForMainCommas])&&(![subview isEqual:weakMainMapZoomInViewController.background]))
                {
                    subview.alpha=0.0f;
                }
            }
            weakMainMapZoomInViewController.circle.transform=transformScale;
            weakMainMapZoomInViewController.circle.center=centerOfView;
            weakMainMapZoomInViewController.containerForMainCommas.center=CGPointMake(centerOfView.x,centerOfView.y-0.5f);
            
        }
                         completion:^(BOOL finished)
         {
             [weakSelf.mainMapZoomInViewController.view removeFromSuperview];
             [weakSelf.mainMapZoomInViewController removeFromParentViewController];
             [mainMapViewController didMoveToParentViewController:self];
             [mainMapViewController showAllAssignments];
             //__weak MapDetailsViewController *mapDetailsViewController=(MapDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"DetailsStoryboard"];
             [weakSelf.view bringSubviewToFront:weakSelf.mapDetailsViewController.view];
             weakSelf.mapDetailsViewController.delegate=mainMapViewController;
             CGRect detailMapFrame=CGRectMake(1024,-3,400,753);
             weakSelf.mapDetailsViewController.view.frame=detailMapFrame;
             weakSelf.mainMapViewController.mapDetailsViewController=weakSelf.mapDetailsViewController;
             if (!weakSelf.mapDetailsViewController.datePicker.userInteractionEnabled)
             {
                 weakSelf.mapDetailsViewController.datePicker.userInteractionEnabled=YES;
             }
             //[weakSelf addChildViewController:weakSelf.mapDetailsViewController];
             //[weakSelf.view insertSubview:mapDetailsViewController.view aboveSubview:weakSelf.mainMapViewController.view];
             //[weakSelf.mapDetailsViewController didMoveToParentViewController:weakSelf];
             weakSelf.mainMapZoomInViewController=nil;
 
         }];
        
        
        
       }
    

}

-(void)backToMainMapZoomOutViewControllerFromMenuThreeButtons:(UIImageView*)backgroundImageView
{

    [self.menuThreeButtonsViewController.view setUserInteractionEnabled:NO];
    MainMapZoomOutViewController *mainMapZoomOutViewController = [[MainMapZoomOutViewController alloc] initWithNibName:@"MainMapZoomOutView" bundle:nil] ;
    [UIView animateWithDuration:0.4f animations:^{
        
        //self.menuThreeButtonsViewController.buttonMainMapZoomOut.transform = CGAffineTransformScale(self.menuThreeButtonsViewController.buttonMainMapZoomOut.transform, 2.0f, 2.0f);
        self.menuThreeButtonsViewController.buttonMainMapZoomOut.center = self.menuThreeButtonsViewController.imageViewFractal.center;
        
    }];
    [mainMapZoomOutViewController.view setUserInteractionEnabled:NO];
    
    self.currentViewControllerZoomOut=mainMapZoomOutViewController;
    
    mainMapZoomOutViewController.view.alpha=0.0f;
    
    mainMapZoomOutViewController.date=self.menuThreeButtonsViewController.dateMainMapZoomOutView;
    
    //[mainMapZoomOutViewController.view layoutIfNeeded];
    
    [self.menuThreeButtonsViewController willMoveToParentViewController:nil];
    [self addChildViewController:mainMapZoomOutViewController];
    
    BOOL isLandscape=UIDeviceOrientationIsLandscape(mainMapZoomOutViewController.interfaceOrientation);
    
    
    if (isLandscape)
    {
        //[self startBackgroundImageLoading];
        CGRect childViewFrame=mainMapZoomOutViewController.view.bounds;
        childViewFrame.origin=CGPointMake(186.0f,-3.0f);
        childViewFrame.size=CGSizeMake(838.0f, 753.0f);
        mainMapZoomOutViewController.view.frame=childViewFrame;
        childViewFrame.origin=CGPointMake(0.0f,0.0f);
        childViewFrame.size=CGSizeMake(838.0f, 753.0f);
        mainMapZoomOutViewController.scrollView.frame=childViewFrame;
        childViewFrame.origin=CGPointMake(0.0f-900.0f,0.0f-900.0f);
        childViewFrame.size=CGSizeMake(2000.0f, 2000.0f);
        mainMapZoomOutViewController.view2.frame=childViewFrame;
        childViewFrame.size=CGSizeMake(838.0f, 753.0f);
        childViewFrame.origin=CGPointMake(-900.0f, -900.0f);
        mainMapZoomOutViewController.scrollView.contentSize=mainMapZoomOutViewController.view2.frame.size;
        mainMapZoomOutViewController.scrollView.contentOffset=CGPointMake(0.0f, 0.0f);
        
        //mainMapZoomOutViewController.scrollView.contentInset=UIEdgeInsetsMake(600,600,600, 600.0);
        
        // choose minimum scale so image width fits screen
        // Set up the minimum & maximum zoom scales
        CGRect scrollViewFrame = mainMapZoomOutViewController.scrollView.frame;
        CGFloat scaleWidth = scrollViewFrame.size.width / mainMapZoomOutViewController.scrollView.contentSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / mainMapZoomOutViewController.scrollView.contentSize.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        [mainMapZoomOutViewController.scrollView setMinimumZoomScale:minScale];
        [mainMapZoomOutViewController.scrollView setMaximumZoomScale:1.25f];
        [mainMapZoomOutViewController.scrollView setZoomScale:minScale];
        
        mainMapZoomOutViewController.view.transform = CGAffineTransformMakeScale(0.004f, 0.004f);
        
        NSLog(@"MainMapZoomOutOrientation is Landscape while initializing.");
        
    }
    
    [self.view insertSubview:mainMapZoomOutViewController.view aboveSubview:self.menuThreeButtonsViewController.view];
    
    [self.menuThreeButtonsViewController willMoveToParentViewController:nil];
    
    //removing mapDetails from view hierarchy
       
    __weak __block CombinedViewController *weakSelf=self;
    [UIView animateWithDuration:0.9f delay:0.0f options:UIViewAnimationCurveEaseInOut  animations:^{
        weakSelf.menuThreeButtonsViewController.buttonMainMapZoomOut.alpha = 0.0f;
        mainMapZoomOutViewController.view.alpha=1.0f;
        mainMapZoomOutViewController.view.transform = CGAffineTransformIdentity;
        
    }
                     completion:^(BOOL finished){
                         
                         
                         [weakSelf.currentViewControllerZoomOut.view setUserInteractionEnabled:YES];
                         
                         [weakSelf.menuThreeButtonsViewController.view removeFromSuperview];
                         [weakSelf.menuThreeButtonsViewController removeFromParentViewController];
                         [weakSelf.currentViewControllerZoomOut didMoveToParentViewController:self];
                         [weakSelf.currentViewControllerZoomOut setFractalImageView:weakSelf.fractalPersonality];
                         
                     }];
}

-(void)transitionToZoomInViewControllerWithCirclePosition:(ObjectiveButtonClass*)button
{
    @autoreleasepool {
        __weak MainMapViewController *weakMainMapViewController=self.mainMapViewController;
        __weak UIButton *parentButton;
        __weak __block UIImage *image;
        CGPoint anchorPointForViewOnCircle;
        switch (button.subbuttonType) {
            case kFinanceSubButtonType:
                parentButton=(UIButton*)[weakMainMapViewController.view2 viewWithTag:kFinanceTypeButton];
                image=[UIImage imageNamed:@"fg.png"];
                anchorPointForViewOnCircle=CGPointMake(0.5f, 0.5f);
                CGFloat angle = 0.0f;
                if ((button.buttonState==kButtonStateNoSubobjective)||(button.buttonState==kButtonStateDefault))
                {
                    angle = 12.0f;
                }
                button.degreeRotationValue=button.degreeRotationValue+angle;

                break;
            case kHealthSubButtonType:
                parentButton=(UIButton*)[weakMainMapViewController.view2 viewWithTag:9999];
                image=[UIImage imageNamed:@"hg.png"];
                anchorPointForViewOnCircle=CGPointMake(0.5f, 0.5f);

                break;
            case kPrivateLifeSubButtonType:
                parentButton=(UIButton*)[weakMainMapViewController.view2 viewWithTag:kPrivateLifeButton];
                image=[UIImage imageNamed:@"pg.png"];
                anchorPointForViewOnCircle=CGPointMake(46.0f/109.0f, 50.0f/153.0f);
                button.degreeRotationValue=button.degreeRotationValue+4;
                break;
                
            default:
                NSLog(@"Unknown subbutton type. ParentView is not recognized");
                break;
        }
        [weakMainMapViewController disableAllButtonsExcept:parentButton];
        __weak __block ButtonObjectClass *weakButton=(ButtonObjectClass*)button;
        //CGFloat angle=atan2(self.view2.transform.b, self.view2.transform.a);
        CGAffineTransform transform=CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeTranslation(0, 250));
        [UIView animateWithDuration:0.75f animations:^{
            weakButton.center=parentButton.center;
            
            // weakButton.transform=CGAffineTransformScale(weakButton.transform, 0.05f, 0.05f);
            weakMainMapViewController.view2.transform=transform;
            for(UIView* subview in weakMainMapViewController.view2.subviews)
            {
                if((![subview isEqual:[weakMainMapViewController.view2 viewWithTag:998]])
                   &&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:kFinanceTypeButton]])
                   &&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:kPrivateLifeButton]])
                   &&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:9999]])
                   &&(![subview isEqual:weakMainMapViewController.graphView2])
                   &&(![subview isEqual:weakButton]))
                {
                    subview.alpha=0.0f;
                }
            }
            
        } completion:^(BOOL finished){
            
            for(UIView* subview in weakMainMapViewController.view2.subviews)
            {
                if((![subview isEqual:[weakMainMapViewController.view2 viewWithTag:998]])&&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:kFinanceTypeButton]])&&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:kPrivateLifeButton]])&&(![subview isEqual:[weakMainMapViewController.view2 viewWithTag:9999]])&&(![subview isEqual:weakMainMapViewController.graphView2])&&(![subview isEqual:weakButton]))
                {
                    [subview removeFromSuperview];
                }
                
            }
        }];
        __weak __block CombinedViewController *weakSelf=self;
        MainMapZoomInViewController *mainMapZoomInViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MainMapZoomInStoryboard"];
        //BOOL _isDetailViewCreated;
        //if (self.mapDetailsViewController)
        //{
            //_isDetailViewCreated=YES;
            mainMapZoomInViewController.mapDetailsViewController=self.mapDetailsViewController;
       // }
       // else
       // {
           // _isDetailViewCreated=NO;
           //  MapDetailsViewController *mapDetailsViewController=(MapDetailsViewController*)[weakSelf.storyboard instantiateViewControllerWithIdentifier:@"DetailsStoryboard"];
           // self.mapDetailsViewController=mapDetailsViewController;

           
       // }
        mainMapZoomInViewController.selectedButton=button;
        mainMapZoomInViewController.dateOfMainMapView=weakMainMapViewController.graphView.date;
        weakSelf.mapDetailsViewController.delegate = mainMapZoomInViewController;
        [UIView animateWithDuration:0.85f animations:^{
            weakButton.transform=CGAffineTransformRotate(weakButton.transform, (-weakButton.degreeRotationValue)*3.14f/180.0f);

           [weakMainMapViewController runSpinAnimationWithDuration:1.0f forView:weakButton];
            weakMainMapViewController.graphView2.transform=CGAffineTransformScale(weakMainMapViewController.graphView2.transform, 1.4f,1.4f);
            weakMainMapViewController.graphView2.transform=CGAffineTransformTranslate(weakMainMapViewController.graphView2.transform, 0, 200);}
                         completion:^(BOOL finished){
                             
                             weakMainMapViewController.graphView2.brush=1.4f*weakMainMapViewController.graphView2.brush;
                             weakMainMapViewController.graphView2.RadiusOfCircle=CGPointZero;
                             weakMainMapViewController.graphView2.arraySubobjectivesCoordinatesToDrawButton=[weakMainMapViewController.graphView2 createArrayOfPointsWithDeltaStep:1 fromAngle:213 toAngle:320 withDeltaBetweenButtons:150 assignTypeOfButton:kButtonSubobject];
                             [weakMainMapViewController convertViewtoMainMapCoordinates:[weakMainMapViewController.graphView2.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:3] fromCircle:weakMainMapViewController.graphView2];
                             
                             
                             UIImageView *imgv=[[UIImageView alloc]initWithImage:image];
                             __weak UIImageView *weakImgv=imgv;
                             if (anchorPointForViewOnCircle.y!=0.5f) {
                                 [weakSelf setAnchorPoint:anchorPointForViewOnCircle forView:weakImgv];
                             }
                            
                             imgv.center=((CoordinatesController*)[weakMainMapViewController.graphView2.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:3]).pointToDrawButton;
                             imgv.alpha=0.0f;
                             [weakMainMapViewController.view2 insertSubview:imgv belowSubview:weakButton];
                             
                             [UIView animateWithDuration:0.3f animations:^{
                                 weakButton.center=((CoordinatesController*)[weakMainMapViewController.graphView2.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:3]).pointToDrawButton;
                                 imgv.alpha=1.0f;
                                 
                             } completion:^(BOOL finished){
                                 
                                 
                                 weakSelf.mainMapZoomInViewController=mainMapZoomInViewController;
                                 [weakSelf.mainMapViewController willMoveToParentViewController:nil];
                                 [weakSelf addChildViewController:mainMapZoomInViewController];
                                 CGRect mainMapFrame;
                                 BOOL isLandscape=UIDeviceOrientationIsLandscape(mainMapZoomInViewController.interfaceOrientation);
                                 
                                 
                                 if (isLandscape)
                                 {
                                     mainMapFrame.origin=CGPointMake(186.0f, -3.0f);
                                     mainMapFrame.size=CGSizeMake(838.0f, 753.0f);
                                     mainMapZoomInViewController.view.frame=mainMapFrame;
                                 }
                                 [weakSelf.view insertSubview:mainMapZoomInViewController.view belowSubview:self.containerViewMenu];
                                 [weakSelf.view bringSubviewToFront:weakSelf.mapDetailsViewController.view];
                                 
                                 [weakSelf.mainMapViewController removeFromParentViewController];
                                 [weakSelf.mainMapViewController.view removeFromSuperview];
                                 weakSelf.mainMapViewController.view=nil;
                                 weakSelf.mainMapViewController=nil;
                                [mainMapZoomInViewController didMoveToParentViewController:weakSelf];
                                 
                                 
                             }];
                             
                         }];
    }

}

-(void)pushViewControllers
{
    @autoreleasepool {
        [self.mainMapViewController.view setUserInteractionEnabled:NO];
        MainMapZoomOutViewController *mainMapZoomOutViewController = [[MainMapZoomOutViewController alloc] initWithNibName:@"MainMapZoomOutView" bundle:nil] ;
        [mainMapZoomOutViewController.view setUserInteractionEnabled:NO];
        
        self.currentViewControllerZoomOut=mainMapZoomOutViewController;
        
        mainMapZoomOutViewController.view.alpha=0.0f;
        
        mainMapZoomOutViewController.date=self.mainMapViewController.date;
        
        //[mainMapZoomOutViewController.view layoutIfNeeded];
        
        [self.mainMapViewController willMoveToParentViewController:nil];
        [self addChildViewController:mainMapZoomOutViewController];
        
        BOOL isLandscape=UIDeviceOrientationIsLandscape(mainMapZoomOutViewController.interfaceOrientation);
        
        
        if (isLandscape)
        {
            //[self startBackgroundImageLoading];
            CGRect childViewFrame=mainMapZoomOutViewController.view.bounds;
            childViewFrame.origin=CGPointMake(186.0f,-3.0f);
            childViewFrame.size=CGSizeMake(838.0f, 753.0f);
            mainMapZoomOutViewController.view.frame=childViewFrame;
            childViewFrame.origin=CGPointMake(0.0f,0.0f);
            childViewFrame.size=CGSizeMake(838.0f, 753.0f);
            mainMapZoomOutViewController.scrollView.frame=childViewFrame;
            childViewFrame.origin=CGPointMake(0.0f-900.0f,0.0f-900.0f);
            childViewFrame.size=CGSizeMake(2000.0f, 2000.0f);
            mainMapZoomOutViewController.view2.frame=childViewFrame;
            childViewFrame.size=CGSizeMake(838.0f, 753.0f);
            childViewFrame.origin=CGPointMake(-900.0f, -900.0f);
            mainMapZoomOutViewController.scrollView.contentSize=mainMapZoomOutViewController.view2.frame.size;
            mainMapZoomOutViewController.scrollView.contentOffset=CGPointMake(0.0f, 0.0f);
            
            //mainMapZoomOutViewController.scrollView.contentInset=UIEdgeInsetsMake(600,600,600, 600.0);
            
            // choose minimum scale so image width fits screen
            // Set up the minimum & maximum zoom scales
            CGRect scrollViewFrame = mainMapZoomOutViewController.scrollView.frame;
            CGFloat scaleWidth = scrollViewFrame.size.width / mainMapZoomOutViewController.scrollView.contentSize.width;
            CGFloat scaleHeight = scrollViewFrame.size.height / mainMapZoomOutViewController.scrollView.contentSize.height;
            CGFloat minScale = MIN(scaleWidth, scaleHeight);
            
            [mainMapZoomOutViewController.scrollView setMinimumZoomScale:minScale];
            [mainMapZoomOutViewController.scrollView setMaximumZoomScale:1.25f];
            [mainMapZoomOutViewController.scrollView setZoomScale:minScale];
            
            NSLog(@"MainMapZoomOutOrientation is Landscape while initializing.");
            
        }
        
        [self.view insertSubview:mainMapZoomOutViewController.view aboveSubview:self.mainMapViewController.view];
        
        [self.mainMapViewController willMoveToParentViewController:nil];
        
        //removing mapDetails from view hierarchy
        [self.mapDetailsViewController willMoveToParentViewController:nil];
        [self.mapDetailsViewController.view removeFromSuperview];
        [self.mapDetailsViewController removeFromParentViewController];
        self.mapDetailsViewController.delegate=nil;
        self.mapDetailsViewController.view=nil;

        self.mapDetailsViewController=nil;
        self.mainMapViewController.mapDetailsViewController=nil;
        
        
        __weak __block CombinedViewController *weakSelf=self;
        [UIView animateWithDuration:0.9f animations:^{
            mainMapZoomOutViewController.view.alpha=1.0f;
            
        }
                         completion:^(BOOL finished){
                             
                             
                             [weakSelf.currentViewControllerZoomOut.view setUserInteractionEnabled:YES];
                             
                             
                             [weakSelf.mainMapViewController.view removeFromSuperview];
                             if (weakSelf.containerViewMap) {
                                 [weakSelf.containerViewMap removeFromSuperview];
                                 weakSelf.containerViewMap=nil;
                                 
                             }
                             [weakSelf.mainMapViewController removeFromParentViewController];
                             weakSelf.mainMapViewController.view=nil;
                             weakSelf.mainMapViewController=nil;
                             
                             [weakSelf.currentViewControllerZoomOut didMoveToParentViewController:self];
                             [weakSelf.currentViewControllerZoomOut setFractalImageView:weakSelf.fractalPersonality];
                             
                         }];

    }
    
}

-(void)switchViewControllerFromZoomOutMainMapToMenuThreeButtons:(UIImageView*)backgroundImageView
{
    @autoreleasepool
    {
        NSLog(@"Swap VC from Zoom out to MenuThreeButtons");
         MenuThreeButtonsViewController *menuButtons= [self.storyboard instantiateViewControllerWithIdentifier:@"MenuThreeButtonsStoryboard"];
        [self.currentViewControllerZoomOut willMoveToParentViewController:nil];
        //-------
        //disabling scaling
        //-------
        self.currentViewControllerZoomOut.scrollView.maximumZoomScale=0.0f;
        self.currentViewControllerZoomOut.scrollView.minimumZoomScale=0.0f;
        //--------
        //weak reference to image view depending if screen shot is taken
        //--------
        __block __weak id imgvScreen;
        NSLog(@"Creating screen shot if needed");
        if (self.currentViewControllerZoomOut.imageViewScreenShot)
        {
            CGRect frameScreenShot =  self.currentViewControllerZoomOut.imageViewScreenShot.frame;
            frameScreenShot.origin = CGPointMake(frameScreenShot.origin.x+55.0f, frameScreenShot.origin.y+12.0f);
             self.currentViewControllerZoomOut.imageViewScreenShot.frame = frameScreenShot;
            [self.currentViewControllerZoomOut.scrollView insertSubview:  self.currentViewControllerZoomOut.imageViewScreenShot belowSubview: self.currentViewControllerZoomOut.view2];
            imgvScreen =  self.currentViewControllerZoomOut.imageViewScreenShot;
        }
        else
        {
            self.currentViewControllerZoomOut.zoomEnabled=NO;
            UIImageView * imgv = [[UIImageView alloc]initWithImage: self.screenShotZoomOutImage];
            imgvScreen=imgv;
            CGRect frameScreenShot = imgv.frame;
            frameScreenShot.origin = CGPointMake(218.0f, 175.0f);
            imgv.frame=frameScreenShot;
            [self.currentViewControllerZoomOut.scrollView insertSubview:imgv  belowSubview: self.currentViewControllerZoomOut.view2];
        }
        
        //-----
        //setup of menu three buttons'view
        NSLog(@"setup of menu three buttons'view");
        self.menuThreeButtonsViewController=menuButtons;
        NSLog(@"add menu three buttons in VC hierarchy");
        [self addChildViewController:self.menuThreeButtonsViewController];
        CGRect frameCurrentZoomOutView = self.currentViewControllerZoomOut.view.frame;
        self.menuThreeButtonsViewController.view.frame = frameCurrentZoomOutView;
        self.menuThreeButtonsViewController.dateMainMapZoomOutView = self.currentViewControllerZoomOut.date;
        NSLog(@"inserting menu view %@", imgvScreen);
        [self.view insertSubview:self.menuThreeButtonsViewController.view belowSubview:self.currentViewControllerZoomOut.view];
        [self.menuThreeButtonsViewController.view insertSubview:backgroundImageView atIndex:0];
        self.menuThreeButtonsViewController.imageViewFractal = backgroundImageView;
        [self.menuThreeButtonsViewController setupButtonMainMapZoomOutTransformScale:self.currentViewControllerZoomOut.zoomEnabled image:((UIImageView*)imgvScreen).image];
         self.currentViewControllerZoomOut.imageViewScreenShot.alpha=1.0f;
        
         self.currentViewControllerZoomOut.imageViewScreenShot.layer.shouldRasterize=YES;
        [self.currentViewControllerZoomOut centerScrollViewContents: self.currentViewControllerZoomOut.view2];
        //-------
        //inserting screen shot view in fractal image
        //-------
        __block __weak MainMapZoomOutViewController *weakZoomOut = (MainMapZoomOutViewController*)self.currentViewControllerZoomOut;
        CGRect boundsFrame =  self.currentViewControllerZoomOut.scrollView.bounds;
        boundsFrame.origin = CGPointMake(.0f, .0f);
        self.currentViewControllerZoomOut.scrollView.bounds=boundsFrame;
        [UIView animateWithDuration:0.2f animations:^{weakZoomOut.view2.alpha = 0.0f;}completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
                ((UIImageView*)imgvScreen).transform = CGAffineTransformScale( ((UIImageView*)imgvScreen).transform, 0.584f, 0.584f);
                [weakZoomOut centerScrollViewContents:(UIImageView*)imgvScreen];
                ((UIImageView*)imgvScreen).center = CGPointMake( ((UIImageView*)imgvScreen).center.x + 145.50f,((UIImageView*)imgvScreen).center.y+84.00f);
                ((UIImageView*)imgvScreen).alpha = 0.90f;
            } completion:^(BOOL finished){
                
                self.menuThreeButtonsViewController.buttonMainMapZoomOut.alpha=.90f;
                [self.currentViewControllerZoomOut.view removeFromSuperview];
                [self.currentViewControllerZoomOut removeFromParentViewController];
                self.currentViewControllerZoomOut = nil;
                [self.menuThreeButtonsViewController didMoveToParentViewController:self];
                
            } ];
        }];
    }
}

-(void)startBackgroundImageLoading
{
    __block __weak CombinedViewController *weakSelf=self;
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock: ^(void) {
        UIImage *backgroundZoomView;
        if (!weakSelf.backgroundZoomView) {
            backgroundZoomView=[[UIImage alloc] initImmediateLoadWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"31withBack.png" ofType: nil]];
            weakSelf.backgroundZoomView=backgroundZoomView;

        }
            [weakSelf performSelectorOnMainThread:@selector(setImageForZoomOutView:) withObject:weakSelf.backgroundZoomView waitUntilDone:YES];
            
    }];
}
-(void)setImageForZoomOutView:(UIImage*)background
{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:background];
    imgv.tag = 4280;
    [self.currentViewControllerZoomOut.view2 insertSubview:imgv atIndex:0];
}

-(void)backToMainMapViewController:(RuneButton*)runeButton
{
    @autoreleasepool {
        self.currentViewControllerZoomOut.view.userInteractionEnabled=NO;
        MainMapViewController *mainMapViewController = (MainMapViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainMapStoryboard"];
        mainMapViewController.date=runeButton.date;
        
        self.mainMapViewController=mainMapViewController;
        self.mainMapViewController.view.userInteractionEnabled=NO;
        // Add this image as a subview to the tab bar controller
        
        [self.currentViewControllerZoomOut willMoveToParentViewController:nil];
        [self addChildViewController:mainMapViewController];
        
        BOOL isLandscape=UIDeviceOrientationIsLandscape(mainMapViewController.interfaceOrientation);
        
        CGRect mainMapFrame=mainMapViewController.view.frame;
        
        if (isLandscape)
        {
            mainMapFrame.origin=CGPointMake(186.0f, -3.0f);
            mainMapFrame.size=CGSizeMake(838.0f, 753.0f);
            
            mainMapViewController.view.frame=mainMapFrame;
            NSLog(@"MainMapOutOrientation is Landscape while initializing.");
            
        }
        [mainMapViewController.view setUserInteractionEnabled:NO];
        [self.view insertSubview:mainMapViewController.view belowSubview:self.currentViewControllerZoomOut.view];
        
        __weak MainMapViewController *weakMainMapVC=mainMapViewController;
        
        [self.currentViewControllerZoomOut willMoveToParentViewController:nil];
        
        __weak __block CombinedViewController *weakSelf=self;
        
        [UIView animateWithDuration:0.9f animations:^{
            
            self.currentViewControllerZoomOut.view.alpha=0.0;
        }
                         completion:^(BOOL finished){
                             
                                 [weakMainMapVC.view setUserInteractionEnabled:YES];
                                 
                                 [weakSelf.currentViewControllerZoomOut.view removeFromSuperview];
                                 [weakSelf.currentViewControllerZoomOut removeFromParentViewController];
                                 weakSelf.currentViewControllerZoomOut=nil;
                                 [weakMainMapVC didMoveToParentViewController:weakSelf];
                                 __weak __block MapDetailsViewController *mapDetailsViewController=(MapDetailsViewController*)[weakSelf.storyboard instantiateViewControllerWithIdentifier:@"MapDetailStoryboard"];
                                 weakSelf.mapDetailsViewController=mapDetailsViewController;
                                 CGRect detailMapFrame=CGRectMake(1024,-3,400,753);
                                 mapDetailsViewController.view.frame=detailMapFrame;
                                 weakSelf.mainMapViewController.mapDetailsViewController=mapDetailsViewController;
                                 [weakSelf addChildViewController:weakSelf.mapDetailsViewController];
                                 [weakSelf.view insertSubview:mapDetailsViewController.view aboveSubview:weakSelf.mainMapViewController.view];
                                 [mapDetailsViewController didMoveToParentViewController:weakSelf];
                             
                            
                         }];

    }
    
}

#pragma mark- Core Data methods

-(void)requestImplement:(NSDate*)date
{
    NSPredicate *pred;
    if (date)
    {
        NSCalendar *curCalendar = [NSCalendar currentCalendar];
        NSRange daysRange = [curCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        //daysRange.length will contain the number of the last day
        //of the month containing curDate
        NSLog(@"last day of month %i",daysRange.length);
        NSDate *dateStart = [date setupWithComponentsDay:0 hour:23 minute:59 second:2];
        NSDate *dateLast = [date setupWithComponentsDay:daysRange.length hour:22 minute:59 second:0];
        pred=[NSPredicate predicateWithFormat:@"(isEnchiridion==YES) AND (date >= %@) AND (date <=%@)",dateStart, dateLast];
    }
    else
    {
         pred=[NSPredicate predicateWithFormat:@"isEnchiridion==YES"];
    }
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext=appDelegate.managedObjectContext;
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescritptor=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
 
    NSError *error;
    
  
    [request setPredicate:pred];
    
    NSMutableArray *mutableFetchResults=[[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (mutableFetchResults==nil)
    {
        
    }
    [mutableFetchResults sortUsingDescriptors:[NSArray arrayWithObject:sortDescritptor]];
       self.toDoList=mutableFetchResults;
    
}




-(CircleView*)circleViewWithRadius:(CGFloat)radiusOfCircle withBrush:(CGFloat)brush tag:(int)tag alphaParam:(CGFloat)alphaParam numberForLabel:(NSNumber*)number labelEnable:(BOOL)labelEnable
{
    CGFloat width=2*(radiusOfCircle)+brush;
    CGRect frame= CGRectMake(0, 0, width, width);
    CircleView *circleView=[[CircleView alloc]initWithFrame:frame];
    circleView.brush=brush;
    circleView.tag=tag;
    circleView.alphaParam=alphaParam;
    return circleView;
}

-(void)createMonthCircles
{
    self.arrayOfMonthCircles=[[NSMutableArray alloc]init];
    for (int i=0; i<10; i++)
    {
        [self.arrayOfMonthCircles addObject:[self circleViewWithRadius:530+i*35 withBrush:5+i tag:1014+i alphaParam:0.60 numberForLabel:[NSNumber numberWithInt:14+i] labelEnable:YES]];
    }
    NSLog(@"%@",self.arrayOfMonthCircles);
    
}

-(void)dissmissMapDetailViewController:(id)sender
{
    //ButtonObjectClass *button=(ButtonObjectClass*)sender;
    //[self.mainMapViewController.view setNeedsUpdateConstraints];
    __weak __block CombinedViewController *weakController=self;

    UIPanGestureRecognizer *pgr = nil;

    if (self.mainMapViewController)
    {
        self.mainMapViewController.isDetailViewOn=NO;
        pgr = (UIPanGestureRecognizer*)sender;
        if (pgr)
        {
            [UIView animateWithDuration:0.55f animations:^{
                weakController.mainMapViewController.mapDetailsViewController.view.frame=CGRectMake(1024.0f,-3.0f,400.0f,753.0f);
            weakController.mainMapViewController.view2.transform=CGAffineTransformIdentity;

            weakController.mainMapViewController.view2.center = weakController.mainMapViewController.background.center;

                
            }];

        }
        
    }

    
    [UIView animateWithDuration:0.65f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
    
    //[self.mainMapViewController.view layoutIfNeeded];
    //self.combinedViewController.mainMapViewController.view2.frame = CGRectMake(0, 0, 838, 753);  //_left is Left
        if (weakController.mainMapViewController)
        {
            if (!pgr)
            {
                 weakController.mainMapViewController.mapDetailsViewController.view.frame=CGRectMake(1024.0f,-3.0f,400.0f,753.0f);
                weakController.mainMapViewController.view2.center=CGPointMake(weakController.mainMapViewController.view2.center.x-offsetX, weakController.mainMapViewController.view2.center.y-offsetY);
                weakController.mainMapViewController.view2.transform=CGAffineTransformIdentity;
            }
           
            //for (UIView *d in weakController.mainMapViewController.view2.subviews)
            //{
                //d.center=CGPointMake(d.center.x+offsetX,d.center.y+offsetY);
            //}
           

        }
        else if (weakController.mainMapZoomInViewController)
        {
            weakController.mainMapZoomInViewController.mapDetailsViewController.view.frame=CGRectMake(1024.0f,-3.0f,400.0f,753.0f);
            
            weakController.mainMapZoomInViewController.view2.transform=CGAffineTransformIdentity;
            weakController.mainMapZoomInViewController.view2.center = CGPointMake(weakController.mainMapZoomInViewController.view2.center.x+225.0f,weakController.mainMapZoomInViewController.view2.center.y-50.0f);
            weakController.mainMapZoomInViewController.containerForMainCommas.center=CGPointMake(weakController.mainMapZoomInViewController.containerForMainCommas.center.x, weakController.mainMapZoomInViewController.containerForMainCommas.center.y-185.0f);
        }
                               } completion:^(BOOL finished){
             NSLog(@"dissmiss animation successfully completed");
             [weakController.mainMapViewController enableAllButtons];
            
         }

     ];
    
    offsetX=0.0f;
    offsetY=0.0f;
    
}

-(void)setNewFrames:(id)sender
{
    //-------
    //comment out following code if you want translate the views
    //-------
    /*
     offsetX=0.0f;
     offsetY=0.0f;
     self.mapDetailsViewController.view.backgroundColor=[UIColor brownColor];
     self.combinedViewController.containerViewDetails.transform=CGAffineTransformMakeScale(1.0,1.0);
     [self.mainMapViewController.view setNeedsUpdateConstraints];
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:1.0];
     [self.mainMapViewController.view layoutIfNeeded];
     self.combinedViewController.containerViewDetails.frame=CGRectMake(650,-3,400,753);
     
     UIButton *button=(UIButton*)sender;
     if (button.tag==kPrivateLifeButton)
     {
     offsetX=400.0f;
     offsetY=0.0f;
     }
     else if (button.tag==kFinanceTypeButton)
     {
     offsetX=150.0f;
     offsetY=50.0f;
     }
     for (UIView *d in self.combinedViewController.mainMapViewController.view.subviews)
     {
     d.center=CGPointMake(d.center.x-offsetX,d.center.y-offsetY);
     }
     
     
     [UIView commitAnimations];*/
    
    //scale views
    offsetX=-200.0f;
    offsetY=0.0f;
    
    __weak __block CombinedViewController *weakController=self;
    
    [UIView animateWithDuration:0.55f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^{
        
       
        weakController.mapDetailsViewController.view.frame=CGRectMake(650.0f,-3.0f,400.0f,753.0f);
        if (weakController.mainMapViewController) {
            weakController.mainMapViewController.view2.transform=CGAffineTransformMakeScale(0.6f, 0.6f);
            
            //for (UIView *d in weakController.mainMapViewController.view2.subviews)
            //{
               // d.center=CGPointMake(d.center.x-offsetX,d.center.y-offsetY);
           // }
             weakController.mainMapViewController.view2.center=CGPointMake(weakController.mainMapViewController.view2.center.x+offsetX, weakController.mainMapViewController.view2.center.y+offsetY);
            

        }
        else if (weakController.mainMapZoomInViewController)
        {
                weakController.mainMapZoomInViewController.view2.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
                weakController.mainMapZoomInViewController.view2.center=CGPointMake(weakController.mainMapZoomInViewController.view2.center.x-225.0f,weakController.mainMapZoomInViewController.view2.center.y+50.0f);
            weakController.mainMapZoomInViewController.containerForMainCommas.center=CGPointMake(weakController.mainMapZoomInViewController.containerForMainCommas.center.x, weakController.mainMapZoomInViewController.containerForMainCommas.center.y+185.0f);

        }
       
    } completion:^(BOOL finished){
        NSLog(@"setNewFrames animation successfully completed");}];
    //[self.mainMapViewController.view layoutIfNeeded];
    

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




@end
