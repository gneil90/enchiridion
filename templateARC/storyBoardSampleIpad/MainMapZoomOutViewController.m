//
//  MainMapZoomOutViewController.m
//  templateARC
//
//  Created by Mac Owner on 3/13/13.
//
//

#import "MainMapZoomOutViewController.h"
#import "CircleView.h"
#import "macros.h"
#import "HealthZoomOutButton.h"
#import <QuartzCore/QuartzCore.h>
#import "CombinedViewController.h"
#import "MainMapViewController.h"
#import "Fugitive.h"
#import "CoordinatesController.h"
#import "CircleMonth.h"
#import <QuartzCore/QuartzCore.h>
#import "FinanceZoomOutButton.h"
#import "pLifeZoomOutButton.h"
#import "RuneButton.h"
#import "UIImage+ImmediateLoading.h"
#import "NSDate+GetDayInteger.h"

@interface MainMapZoomOutViewController ()

@property (strong,nonatomic,readwrite) NSMutableArray *arrayOfMonthCircles;
@property (strong,nonatomic) NSMutableArray * arrayOfRuneTags;
@property (strong,nonatomic) NSMutableArray * arrayOfOddRuneTags;
@property (strong,nonatomic) NSMutableArray * arrayOfRuneTagsFinance;

@property (assign,nonatomic) int buttonTagValue;

@property (strong,nonatomic) UIImage * redCircleIndicator;


@end

@implementation MainMapZoomOutViewController
{
    
    BOOL _isConverted;
    BOOL _firstCall;
    NSInteger monthInteger;
    CGFloat m_locationBegan;
    
    BOOL isRuneShowed;
    BOOL isOddRuneShowed;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark- View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buttonTagValue = 3;
        
    _isConverted=NO;
    _firstCall=YES;

    // Do any additional setup after loading the view.
    NSMutableArray *arrayForTags=[NSMutableArray new];
    self.arrayOfTagsHealth=arrayForTags;
    
    NSMutableArray *arrayForRuneTags=[NSMutableArray new];
    self.arrayOfRuneTags=arrayForRuneTags;
    
    NSMutableArray *arrayForRuneTagsFinance=[NSMutableArray new];
    self.arrayOfRuneTagsFinance=arrayForRuneTagsFinance;
    
    NSMutableArray *arrayForOddRuneTags=[NSMutableArray new];
    self.arrayOfOddRuneTags=arrayForOddRuneTags;
    
    NSMutableArray *arrayForPrivateLifeTags=[NSMutableArray new];
    self.arrayOfTagsPrivateLife=arrayForPrivateLifeTags;
    
    NSMutableArray *arrayForFinanceTags=[NSMutableArray new];
    self.arrayOfTagsFinance=arrayForFinanceTags;

    isRuneShowed=NO;
    
    _zoomEnabled = YES;
    
    self.view.backgroundColor=[UIColor clearColor];
    
    
    
}

-(void)setFractalImageView:(UIImage*)image
{
    @autoreleasepool
    {
        UIImageView *fractalImgv=[[UIImageView alloc]initWithImage:image];
        if ([[UIScreen mainScreen]scale]==2) {
            fractalImgv.transform=CGAffineTransformScale(fractalImgv.transform, 0.5f, 0.5f);
        }
        CGRect frame = fractalImgv.frame;
        frame.origin=CGPointMake(50, 0);
        fractalImgv.frame=frame;
        fractalImgv.tag=8000;
        [self.view insertSubview:fractalImgv atIndex:0];
    }
}

-(void)backToSecondView:(RuneButton*)runeButton
{
    __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
    [[self.view viewWithTag:8000] removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.view.transform=CGAffineTransformScale(self.view.transform, 3.0f, 3.0f);
    [UIView commitAnimations];
    
    [parentVC backToMainMapViewController:runeButton];
}



-(void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    monthInteger=[MainMapViewController getMonthIntegerFromDate:self.date];
    switch (monthInteger) {
        case 1:
            self.month.text=@"january";
            break;
            
        case 2:
            self.month.text=@"february";
            break;

        case 3:
            self.month.text=@"march";
            break;

        case 4:
            self.month.text=@"april";
            break;

        case 5:
            self.month.text=@"may";
            break;

        case 6:
            self.month.text=@"june";
            break;
        case 7:
            self.month.text=@"july";
            break;
            
        case 8:
            self.month.text=@"august";
            break;
        case 9:
            self.month.text=@"sept";
            break;
            
            
        default:
            break;
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory warning received...");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination to supported by Viewcontroller.
    return  UIInterfaceOrientationMaskLandscape;
}


-(BOOL)shouldAutorotate
{
    return YES;
}



-(void)initCircleViewWithRadius:(CGFloat)radiusOfCircle dayTag:(NSNumber*)dayTag
{
    
    CircleMonth *circleView=[[CircleMonth alloc]init];
    
    circleView.dayTag=dayTag;
    
    CGPoint pointRadius=CGPointMake(radiusOfCircle/2, radiusOfCircle/2);
    
    circleView.radius=pointRadius;
    
    NSDate *dateOfCircle=[MainMapViewController setDateByComponentDay:[dayTag integerValue] byMonth:monthInteger andByYear:2013];
    
    circleView.dateOfCircle=dateOfCircle;
    [circleView createArrayOfCoordinatesForDrawZoomOutButtonsWithRadius:pointRadius withStep:1 centerOfCircle:mainCommasZoomOut.center];
    if (!self.arrayOfMonthCircles) {
        NSMutableArray *arrayOfCircles=[NSMutableArray new];
        self.arrayOfMonthCircles=arrayOfCircles;
    }
    [self.arrayOfMonthCircles addObject:circleView];
    
}

-(void)viewWillLayoutSubviews
{
    if (_firstCall) {
        BOOL isLandscape=UIDeviceOrientationIsLandscape(self.interfaceOrientation);
                
        if (isLandscape)
        {
            [self centerScrollViewContents:self.view2];

            self.month.center=CGPointMake(self.view2.bounds.size.width/2, self.view2.bounds.size.height/2-50.0f);;
            
            [self addMonthCircles];

            
            mainCommasZoomOut.center=CGPointMake(self.view2.bounds.size.width/2, self.view2.bounds.size.height/2);
            
            __weak MainMapZoomOutViewController *weakSelf=self;
                NSOperationQueue* queue = [[NSOperationQueue alloc] init];
                
                [queue addOperationWithBlock: ^(void)
                 {
                     CGFloat radius;
                     NSDate *todayDate = [NSDate date];
                     NSUInteger integerDate = [todayDate getDayIntegerFromDate]-1;
                      
                     for (int j=0; j<10; j++)
                     {
                         [weakSelf initCircleViewWithRadius:(145.0f+j*60.0f) dayTag:[NSNumber numberWithInt:j+1]];
                         if (integerDate==j)
                         {
                             radius = 145.0f+j*60;
                         }
                     }
                     
                     
                     for (int j=10; j<20; j++) {
                         
                         [weakSelf initCircleViewWithRadius:(145.0f+j*60.0f-10.0f) dayTag:[NSNumber numberWithInt:j+1]];
                         if (integerDate==j)
                         {
                             radius = 145.0f+j*60-10;
                         }
                     }
                     
                     for (int j=20; j<23; j++)
                     {
                         [weakSelf initCircleViewWithRadius:(145.0f+j*60.0f-15.0f) dayTag:[NSNumber numberWithInt:j+1]];
                         if (integerDate==j)
                         {
                             radius = 145.0f+j*60-15;
                         }
                     }
                     if ((integerDate==23)||(integerDate==24)) {
                         radius = 145.0f+23*60.0f-17.0f;
                     }
                     [weakSelf initCircleViewWithRadius:(145.0f+23*60.0f-17.0f) dayTag:[NSNumber numberWithInt:24]];
                     [weakSelf initCircleViewWithRadius:(145.0f+24*60.0f-17.0f) dayTag:[NSNumber numberWithInt:25]];
                     if (integerDate==25) {
                         radius = (145.0f+25*60.0f-19.0f);
                     }

                     [weakSelf initCircleViewWithRadius:(145.0f+25*60.0f-19.0f) dayTag:[NSNumber numberWithInt:26]];
                     
                     for (int j=26; j<31; j++) {
                         if (integerDate==j) {
                             radius = (145.0f+j*60.0f-21.0f);
                         }
                         [weakSelf initCircleViewWithRadius:(145.0f+j*60.0f-21.0f) dayTag:[NSNumber numberWithInt:j+1]];
                     }
                     
                     //self.redCircleIndicator.RadiusOfCircle = CGPointMake(radius,radius) ;
                     radius*=0.5f;
                     CGFloat width=2*(radius)+4.0f;
                     CGFloat brush = 7.5f;
                    
                     UIImage *image = [UIImage imageWithIdentifier:@"redCircleIdenticator" forSize:CGSizeMake(width, width) andDrawingBlock:^{
                         CGContextRef contextRef = UIGraphicsGetCurrentContext();
                         
                         CGRect frameOfCircle=CGRectMake(brush/2,brush/2, width-1.0f-brush, width-brush-1.0f);
                         // Draw a circle (border only)
                         CGContextSetLineWidth(contextRef, 10.0f);
                         
                         UIColor *color = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.15f];
                         [color set];
                         CGContextSetLineWidth(contextRef, brush);
                         
                         //CGContextSetStrokeColor(contextRef, mainColor);
                         CGContextStrokeEllipseInRect(contextRef, frameOfCircle);
                         
                     }];
                     self.redCircleIndicator=image;
                     
                   
                     //circleView.transform=CGAffineTransformScale(circleView.transform, 0.5f, 0.5f);
                     //self.redCircleIndicator=image;
                  
                     
                     [weakSelf performSelectorOnMainThread:@selector(showAllAssignments) withObject:nil waitUntilDone:YES];
                     UIImage *screenShot = [self takeViewScreenShot:self.scrollView];
                     CGRect rect = CGRectMake(55.0f, 12.0f, 727.0f, 727.0f);
                     UIImage *croppedScreenShotImage = [screenShot crop:rect];
                     UIImageView *imgv = [[UIImageView alloc]initWithImage:croppedScreenShotImage];
                     if (self.zoomEnabled)
                     {
                         self.imageViewScreenShot = imgv;
                         NSLog(@"Screen shot view 2 created.");
                     }
                     
                     self.imageViewScreenShot.clipsToBounds=YES;
                     self.imageViewScreenShot.layer.borderWidth=0;
                     self.imageViewScreenShot.layer.cornerRadius=363;
                     
                     self.imageViewScreenShot.transform = CGAffineTransformScale(self.imageViewScreenShot.transform, 0.55f, 0.55f);
                 }];

            }
            

                                                    
            _firstCall=NO;

        
        
    }
    
}
#pragma mark-Adding Buttons methods 

-(void)showAllAssignments
{
    UIImageView *imgv = [[UIImageView alloc]initWithImage:self.redCircleIndicator];
    imgv.center = CGPointMake(self.view2.bounds.size.width/2,self.view2.bounds.size.height/2);
    [imgv sizeToFit];
    [self.view2 addSubview:imgv];
    NSLog(@"firing show all assignments method.");
    //imgv.center=CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height/2);
    __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
        for (Fugitive *assignment in parentVC.toDoList)
        {
            if ([assignment.isShown boolValue])
            {
                assignment.isShown=[NSNumber numberWithBool:NO];
            }
        }
    
            for (Fugitive *assignment in parentVC.toDoList)
            {
                if (![assignment.isShown boolValue])
                {
                NSDate *dateOfAssignment=assignment.date;
                NSInteger dayOfDateAssignment=[MainMapViewController getDayIntegerFromDate:dateOfAssignment];
                NSInteger monthOfDateAssignment=[MainMapViewController getMonthIntegerFromDate:dateOfAssignment];
                
                if (monthInteger==monthOfDateAssignment)
                {
                    
                    if ([assignment.type isEqualToString:@"Health"])
                    {
                            [self createHealthButtonAt:[self.arrayOfMonthCircles objectAtIndex:dayOfDateAssignment-1] withTag:self.buttonTagValue toDoAssignment:assignment];
                        
                        
                        
                            self.buttonTagValue++;
                            
                        
                        
                    }
                    else if ([assignment.type isEqualToString:@"Finance"])
                    {
                    
                        
                            [self createFinanceButtonAt:[self.arrayOfMonthCircles objectAtIndex:dayOfDateAssignment-1] withTag:self.buttonTagValue toDoAssignment:assignment];
                        
                            self.buttonTagValue++;
                            
                    

                    }
                    else if ([assignment.type isEqualToString:@"Private Life"])
                    {
                     
                            [self createPrivateLifeButtonAt:[self.arrayOfMonthCircles objectAtIndex:dayOfDateAssignment-1] withTag:self.buttonTagValue toDoAssignment:assignment];
                        
                            self.buttonTagValue++;
                    }
                    }
                    
                }
                
            }
        
    NSLog(@"Buttons are showed now. Enabling swipe gestures.");
}

-(void)convertViewtoMainMapCoordinates:(CircleMonth*)circle forArrayOfCoordinates:(NSMutableArray*)array
{
        
    for (CoordinatesController *k in array)
    {
        k.pointToDrawButton=CGPointMake(k.pointToDrawButton.x,k.pointToDrawButton.y);
    }
    
}

-(void)convertIfNeeded:(BOOL) _isConvertedCoord
{
    if (_isConvertedCoord==NO) {
        
      
        for (CircleMonth *circle in self.arrayOfMonthCircles) {
            
                
            [self convertViewtoMainMapCoordinates:circle forArrayOfCoordinates:circle.arrayFinanceCoordinatesToDrawButton];
            [self convertViewtoMainMapCoordinates:circle forArrayOfCoordinates:circle.arrayHealthCoordinatesToDrawButton];
            [self convertViewtoMainMapCoordinates:circle forArrayOfCoordinates:circle.arrayPrivateLifeCoordinatesToDrawButton];
            
            
        }
        
        }
    _isConverted=YES;
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

-(void)createHealthButtonAt:(CircleMonth*)circle withTag:(int)newButtonTagValue toDoAssignment:(Fugitive*)assignment
{
    static int numberOfCreatedButtons=0;
    for (CoordinatesController *d in circle.arrayHealthCoordinatesToDrawButton) {
        
       if ((d.pointIsEmpty)&&(![d isEqual:[circle.arrayHealthCoordinatesToDrawButton lastObject]]))
        {
            assignment.isShown=[NSNumber numberWithBool:YES];

            [self.arrayOfTagsHealth addObject:[NSNumber numberWithInt:newButtonTagValue]];

            HealthZoomOutButton *newButton=[[HealthZoomOutButton alloc]init];
            
            if (numberOfCreatedButtons%2==0)
            {
               
            }
            else
            {
                
            }
       
            //[newButton setTitle:titleButton forState:UIControlStateNormal];
            newButton.center=d.pointToDrawButton;
            
            [self setAnchorPoint:CGPointMake(36.0f/65.0f, 28.0f/65.0f) forView:newButton];
            d.pointIsEmpty=NO;
            newButton.tag=newButtonTagValue;
            newButton.toDoAssignment=assignment;
            newButton.coordinateDefault=d;
            NSUInteger *indexOfCurrent=[circle.arrayHealthCoordinatesToDrawButton indexOfObject:d]+1;
            newButton.coordinateWithRune=[circle.arrayHealthCoordinatesToDrawButton objectAtIndex:indexOfCurrent];
            
            //[newButton addTarget:self action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            [newButton setupBackgroundImage];
            [newButton sizeToFit];
            newButton.transform=CGAffineTransformScale(newButton.transform, 0.7f, 0.7f);
            
            
        
            [self.view2 addSubview:newButton];
            
            newButton.alpha=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7f];
            newButton.alpha=1.0f;
            newButton.transform=CGAffineTransformRotate(newButton.transform, (d.degreeValue-180.0f)*M_PI/180.0f);
            [UIView commitAnimations];
            //assignment.isShown=[NSNumber numberWithBool:NO];
            newButton=nil;
            NSLog(@"-----New ZoomOutButton Health-----");

            break;
        }
        
        
    }
    
    
    
    numberOfCreatedButtons++;
    
}

-(void)createFinanceButtonAt:(CircleMonth*)circle withTag:(int)newButtonTagValue toDoAssignment:(Fugitive*)assignment
{
    static int numberOfFinanceCreatedButtons=0;
    for (CoordinatesController *d in circle.arrayFinanceCoordinatesToDrawButton) {
        
        if ((d.pointIsEmpty)&&(![d isEqual:[circle.arrayFinanceCoordinatesToDrawButton lastObject]]))
        {
            [self.arrayOfTagsFinance addObject:[NSNumber numberWithInt:newButtonTagValue]];

            assignment.isShown=[NSNumber numberWithBool:YES];

            FinanceZoomOutButton *newButton=[[FinanceZoomOutButton alloc]init];
            //[self.view2 insertSubview:imgvHealth belowSubview:mainCommasZoomOut];
            
            
            //[newButton setTitle:titleButton forState:UIControlStateNormal];
            newButton.center=d.pointToDrawButton;
            newButton.toDoAssignment=assignment;
            [self setAnchorPoint:CGPointMake(48.0f/65.0f, 28.0f/65.0f) forView:newButton];
            d.pointIsEmpty=NO;
            newButton.tag=newButtonTagValue;
            newButton.coordinateDefault=d;
            NSUInteger *indexOfCurrent=[circle.arrayFinanceCoordinatesToDrawButton indexOfObject:d]+1;
            newButton.coordinateWithRune=[circle.arrayFinanceCoordinatesToDrawButton objectAtIndex:indexOfCurrent];
            
            [newButton setupBackgroundImage];
            [newButton sizeToFit];
                      
            [self.view2 addSubview:newButton];
            
            newButton.alpha=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7];
            newButton.alpha=1.0f;
            newButton.transform=CGAffineTransformRotate(newButton.transform, (d.degreeValue)*M_PI/180.0f);
            [UIView commitAnimations];
            //assignment.isShown=[NSNumber numberWithBool:NO];
            NSLog(@"--New ZoomOutButton Finance--");
            newButton=nil;

            break;
        }
    }
    numberOfFinanceCreatedButtons++;
}

-(void)createPrivateLifeButtonAt:(CircleMonth*)circle withTag:(int)newButtonTagValue toDoAssignment:(Fugitive*)assignment
{
    static int numberOfPrivateLifeCreatedButtons=0;
    for (CoordinatesController *d in circle.arrayPrivateLifeCoordinatesToDrawButton) {
        
        if ((d.pointIsEmpty)&&(![d isEqual:[circle.arrayPrivateLifeCoordinatesToDrawButton lastObject]]))
        {
            assignment.isShown=[NSNumber numberWithBool:YES];

            [self.arrayOfTagsPrivateLife addObject:[NSNumber numberWithInt:newButtonTagValue]];

            
            //UIImageView *imgvHealth;
            pLifeZoomOutButton *newButton=[[pLifeZoomOutButton alloc]init];
            
            if (numberOfPrivateLifeCreatedButtons%2==0)
            {
                
            }
            else
            {
                
            }
            
            //[self setAnchorPoint:CGPointMake(25.0f/218.0f, 34.0f/73.0f) forView:imgvHealth];
            //imgvHealth.transform=CGAffineTransformRotate(imgvHealth.transform, (d.degreeValue-180.0f)*M_PI/180.0f);
            
            
            //imgvHealth.layer.position=CGPointMake(200.0f,200.0f);
            
           // imgvHealth.tag=newButtonTagValue+4000;
                        
            //imgvHealth.animationDuration=1.2;
            //imgvHealth.animationRepeatCount=1;
            //[imgvHealth startAnimating];
            
            newButton.center=d.pointToDrawButton;
            newButton.toDoAssignment=assignment;
            [self setAnchorPoint:CGPointMake(48.0f/65.0f, 28.0f/65.0f) forView:newButton];
            d.pointIsEmpty=NO;
            newButton.tag=newButtonTagValue;
            newButton.coordinateDefault=d;
            NSUInteger *indexOfCurrent=[circle.arrayPrivateLifeCoordinatesToDrawButton indexOfObject:d]+1;
            newButton.coordinateWithRune=[circle.arrayPrivateLifeCoordinatesToDrawButton objectAtIndex:indexOfCurrent];
            [newButton setupBackgroundImage];
            [newButton sizeToFit];
            
            [self.view2 addSubview:newButton];
            
            newButton.alpha=0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7];
            newButton.alpha=1.0f;
            newButton.transform=CGAffineTransformRotate(newButton.transform, (d.degreeValue)*M_PI/180.0f);
            [UIView commitAnimations];
            //assignment.isShown=[NSNumber numberWithBool:NO];
            NSLog(@"--New ZoomOutButton Private Life--");
            newButton=nil;

            break;
        }
        
        
    }
    numberOfPrivateLifeCreatedButtons++;
}




-(void)addMonthCircles
{
    
    __weak CombinedViewController *parentVC=(CombinedViewController*)[self parentViewController];
    UIImageView *imgv=[[UIImageView alloc]initWithImage:parentVC.circleMonthImage];
    imgv.tag=kCircleMonthImageView;
    
    imgv.center=CGPointMake(self.view2.bounds.size.width/2, self.view2.bounds.size.height/2);
    imgv.alpha=1.0f;
    [self.view2 insertSubview:imgv belowSubview:mainCommasZoomOut];
    
 
}

#pragma mark-GestureRecognizer methods



-(IBAction)swipeLeftToShowRunes:(id)sender
{
    NSLog(@"Swipe Left gesture recognized.");
    if ((!isRuneShowed)&&(!isOddRuneShowed)) {
        NSLog(@"Runes are not showed yet. Starting to add runes.");
        for (NSNumber *tag in self.arrayOfTagsHealth) {
            if (((HealthZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]]).subbuttonType==kHealthZoomOutSubButtonType) {
                HealthZoomOutButton *healthButton=(HealthZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
                [UIView animateWithDuration:0.7f animations:^(void){
                    healthButton.center=healthButton.coordinateWithRune.pointToDrawButton;
                    healthButton.transform=CGAffineTransformRotate(healthButton.transform, 1.0f*180.0f/3.14f);
                } completion:^(BOOL finished){}];
            }
            
        }
        NSUInteger *runeTag=6000;
        if (![self.view2 viewWithTag:runeTag])
        {
            CGFloat timeOffset = 0.35f;
            [CATransaction begin];
        for (CircleMonth *circle in self.arrayOfMonthCircles) {
            if ([circle.dayTag integerValue]%2==0) {
                
                CoordinatesController *coordinate=(CoordinatesController*)[circle.arrayHealthCoordinatesToDrawButton objectAtIndex:0];
                
                NSString *nameRune=[NSString stringWithFormat:@"rune_%d",[circle.dayTag integerValue]];
                RuneButton *runeButton=[RuneButton new];
                
                [self settingPropertiesForRuneButton:runeButton putOnCoordinate:coordinate withTag:runeTag forImageNamed:nameRune getPropertiesFromCircle:circle];
                
                [self runOpacityAnimationWithDuration:0.1f forView:runeButton withTimeOffset:timeOffset fromValue:0.0f toValue:1.0f];

                
                timeOffset += .03f;
                
                runeTag++;
                }
            }
            [CATransaction commit];
            isRuneShowed=YES;

        }
        else
        {
            
            CGFloat timeOffset = 0.35f;
            [CATransaction begin];
            while ([self.view2 viewWithTag:runeTag]) {
                
                UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:runeTag];
                
                [self runOpacityAnimationWithDuration:0.1f forView:runeButton withTimeOffset:timeOffset fromValue:0.0f toValue:1.0f];
                [self performSelector:@selector(setRuneButtonsVisibleAfterAnimations:) withObject:runeButton afterDelay:1.5f];


                
                timeOffset += .03f;

                runeTag++;
                
            }
            [CATransaction commit];
            isRuneShowed=YES;


        }
        
    }
    
    if (isOddRuneShowed) {
        NSLog(@"Runes are already added. Starting to hide them.");
        CGFloat timeOffset=0.0f;
        CGFloat timeOffsetFinance=0.0f;

        [CATransaction begin];
        NSUInteger i=[self.arrayOfOddRuneTags count]-1;
        for (int j=i; j>=0; j--) {
            UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:[[self.arrayOfOddRuneTags objectAtIndex:j]integerValue]];
            
            [self runOpacityAnimationWithDuration:0.1f forView:runeButton withTimeOffset:timeOffset fromValue:1.0f toValue:0.0f];
            [self performSelector:@selector(setRuneButtonsUnvisibleAfterAnimations:) withObject:runeButton afterDelay:1.5f];
            
            
            timeOffset += .05;
            
        }
        NSUInteger k=[self.arrayOfRuneTagsFinance count]-1;
        for (int j=k; j>=0; j--) {
            UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:[[self.arrayOfRuneTagsFinance objectAtIndex:j]integerValue]];
            
            [self runOpacityAnimationWithDuration:0.1f forView:runeButton withTimeOffset:timeOffsetFinance fromValue:1.0f toValue:0.0f];
            [self performSelector:@selector(setRuneButtonsUnvisibleAfterAnimations:) withObject:runeButton afterDelay:1.5f];
            
            
            timeOffsetFinance += .05;
            
        }

        
        [CATransaction commit];
        for (NSNumber *tag in self.arrayOfTagsPrivateLife) {
            if (((pLifeZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]]).subbuttonType==kPrivateLifeZoomOutSubButtonType) {
                __weak __block pLifeZoomOutButton *pLifeButton=(pLifeZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
                [UIView animateWithDuration:1.1f delay:0.4f options:UIViewAnimationCurveEaseIn animations:^(void){
                    pLifeButton.transform=CGAffineTransformRotate(pLifeButton.transform, -1.0f*180.0f/3.14f);
                    
                    pLifeButton.center=pLifeButton.coordinateDefault.pointToDrawButton;
                } completion:^(BOOL finished){}];
            }
          
        }
        for (NSNumber *tag in self.arrayOfTagsFinance) {
            if ((((FinanceZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]]).subbuttonType==kFinanceZoomOutSubButtonType)) {
                __weak __block FinanceZoomOutButton *financeButton=(FinanceZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
                [UIView animateWithDuration:1.1f delay:0.4f options:UIViewAnimationCurveEaseIn animations:^(void){
                    financeButton.transform=CGAffineTransformRotate(financeButton.transform, -1.0f*180.0f/3.14f);
                    
                    financeButton.center=financeButton.coordinateDefault.pointToDrawButton;
                } completion:^(BOOL finished){}];

            }
        }

        
        isOddRuneShowed=NO;

        
    }
    
    

}
-(void)settingPropertiesForRuneButton:(RuneButton*)runeButton putOnCoordinate:(CoordinatesController*)coordinate withTag:(NSUInteger)runeTag forImageNamed:(NSString*)nameRune getPropertiesFromCircle:(CircleMonth*)circle
{
    runeButton.date=circle.dateOfCircle;
    [runeButton setImage:[UIImage imageNamed:nameRune] forState:UIControlStateNormal];
    [runeButton sizeToFit];
    [runeButton addTarget:self action:@selector(backToSecondView:) forControlEvents:UIControlEventTouchUpInside];
    runeButton.transform=CGAffineTransformScale(runeButton.transform, 0.45f, 0.45f);
    coordinate.pointIsEmpty=NO;
    [runeButton setAlpha:0.0f];
    runeButton.tag=runeTag;
    if ([circle.dayTag integerValue]%2!=0)
    {
    [self.arrayOfOddRuneTags addObject:[NSNumber numberWithInteger:runeTag]];
    [self setAnchorPoint:CGPointMake(0.7f, 0.5f) forView:runeButton];
    }
    else
    {
        if (runeTag<7000) {
            [self.arrayOfRuneTags addObject:[NSNumber numberWithInteger:runeTag]];
        }
        else
        {
            [self.arrayOfRuneTagsFinance addObject:[NSNumber numberWithInteger:runeTag]];
        }
    }
    runeButton.center=coordinate.pointToDrawButton;

    [self.view2 addSubview:runeButton];
    [self performSelector:@selector(setRuneButtonsVisibleAfterAnimations:) withObject:runeButton afterDelay:1.5f];
}

-(void)setRuneButtonsVisibleAfterAnimations:(UIButton*)runeButton
{
    runeButton.alpha=1.0f;
}
-(void)setRuneButtonsUnvisibleAfterAnimations:(UIButton*)runeButton
{
    runeButton.alpha=0.0f;
}

-(IBAction)swipeRightToRemoveRunes:(id)sender
{
    NSLog(@"Swipe Right gesture recognized.");
    if (isRuneShowed) {
        NSLog(@"Runes are already added. Starting to hide them.");
        CGFloat timeOffset=0.0f;
        [CATransaction begin];
        NSUInteger i=[self.arrayOfRuneTags count]-1;
        for (int j=i; j>=0; j--) {
            UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:[[self.arrayOfRuneTags objectAtIndex:j]integerValue]];
            
            [self runOpacityAnimationWithDuration:0.05f forView:runeButton withTimeOffset:timeOffset fromValue:1.0f toValue:0.0f];
            [self performSelector:@selector(setRuneButtonsUnvisibleAfterAnimations:) withObject:runeButton afterDelay:1.4f];
            timeOffset += .03;
            
        }
            
        [CATransaction commit];
        for (NSNumber *tag in self.arrayOfTagsHealth) {
            __weak __block HealthZoomOutButton *healthButton=(HealthZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
            [UIView animateWithDuration:0.9f delay:0.3f options:UIViewAnimationCurveEaseIn animations:^(void){
                healthButton.transform=CGAffineTransformRotate(healthButton.transform, -1.0f*180.0f/3.14f);

                healthButton.center=healthButton.coordinateDefault.pointToDrawButton;
            } completion:^(BOOL finished){}];
        }

        isRuneShowed=NO;
    }
    else if (!isOddRuneShowed) {
        NSLog(@"Runes are not added. Starting to add them to the right direction.");
        NSLog(@"Enumeration Private Life buttons started.");
        for (NSNumber *tag in self.arrayOfTagsPrivateLife)
        {
           
            [UIView animateWithDuration:0.75f animations:^(void){
                 __block __weak pLifeZoomOutButton *pLifeButton=(pLifeZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
                NSLog(@"plife button %@",pLifeButton);
                pLifeButton.center=[[pLifeButton coordinateWithRune]pointToDrawButton];
                pLifeButton.transform=CGAffineTransformRotate(pLifeButton.transform, 1.0f*180.0f/3.14f);
            } completion:^(BOOL finished){}];
        }
        NSLog(@"Enumeration Finance buttons started.");
        for (NSNumber *tag in self.arrayOfTagsFinance)
        {
            [UIView animateWithDuration:0.75f animations:^(void){
                __block __weak FinanceZoomOutButton *financeButton=(FinanceZoomOutButton*)[self.view2 viewWithTag:[tag integerValue]];
                financeButton.center=financeButton.coordinateWithRune.pointToDrawButton;
                financeButton.transform=CGAffineTransformRotate(financeButton.transform, 1.0f*180.0f/3.14f);
            } completion:^(BOOL finished){}];
        }
        NSUInteger *runeTag=7000;
        NSUInteger *runeTagFinance=8000;
        NSLog(@"Checking existence of runes");
        if ((![self.view2 viewWithTag:runeTag])&&(![self.view2 viewWithTag:runeTagFinance]))
        {
            CGFloat timeOffset = 0.65f;
            CGFloat timeOffsetFinance=0.65f;
            [CATransaction begin];
            for (CircleMonth *circle in self.arrayOfMonthCircles) {
                if ([circle.dayTag integerValue]%2!=0) {
                    
                    CoordinatesController *coordinate=(CoordinatesController*)[circle.arrayPrivateLifeCoordinatesToDrawButton objectAtIndex:0];
                    
                    NSString *nameRune=[NSString stringWithFormat:@"rune_%d",[circle.dayTag integerValue]];
                    RuneButton *runeButton=[RuneButton new];
                    
                    [self settingPropertiesForRuneButton:runeButton putOnCoordinate:coordinate withTag:runeTag forImageNamed:nameRune getPropertiesFromCircle:circle];
                    
                    [self runOpacityAnimationWithDuration:0.05f forView:runeButton withTimeOffset:timeOffset fromValue:0.0f toValue:1.0f];
                    
                    
                    timeOffset += .03f;
                    
                    runeTag++;
                }
                //если круг четный (добавляем руны в секторе финансы)
                else
                {
                    CoordinatesController *coordinate=(CoordinatesController*)[circle.arrayFinanceCoordinatesToDrawButton objectAtIndex:0];
                    
                    NSString *nameRune=[NSString stringWithFormat:@"rune_%d",[circle.dayTag integerValue]];
                    RuneButton *runeButton=[RuneButton new];
                    
                    [self settingPropertiesForRuneButton:runeButton putOnCoordinate:coordinate withTag:runeTagFinance forImageNamed:nameRune getPropertiesFromCircle:circle];
                    
                    [self runOpacityAnimationWithDuration:0.05f forView:runeButton withTimeOffset:timeOffsetFinance fromValue:0.0f toValue:1.0f];
                    
                    
                    timeOffsetFinance += .03f;
                    
                    runeTagFinance++;
 
                }
            }
            [CATransaction commit];
            isOddRuneShowed=YES;
            
        }
        else
        {
            
            CGFloat timeOffset = 0.35f;
            CGFloat timeOffsetFinance=0.35f;

            [CATransaction begin];
            while ([self.view2 viewWithTag:runeTag]) {
                
                UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:runeTag];
                
                [self runOpacityAnimationWithDuration:0.05f forView:runeButton withTimeOffset:timeOffset fromValue:0.0f toValue:1.0f];
                [self performSelector:@selector(setRuneButtonsVisibleAfterAnimations:) withObject:runeButton afterDelay:1.3f];
                
                
                timeOffset += .03f;
                
                runeTag++;
                
            }
            while ([self.view2 viewWithTag:runeTagFinance]) {
                
                UIButton *runeButton=(UIButton*)[self.view2 viewWithTag:runeTagFinance];
                
                [self runOpacityAnimationWithDuration:0.1f forView:runeButton withTimeOffset:timeOffsetFinance fromValue:0.0f toValue:1.0f];
                [self performSelector:@selector(setRuneButtonsVisibleAfterAnimations:) withObject:runeButton afterDelay:1.3f];
                
                
                timeOffsetFinance += .03f;
                
                runeTagFinance++;
                
            }

            [CATransaction commit];
            
        }
        isOddRuneShowed=YES;

        
    }
    
    
    
    
}

- (void) runOpacityAnimationWithDuration:(CGFloat) duration forView:(UIView*)runeButton withTimeOffset:(CGFloat)timeOffset fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"opacity"];
    a.fromValue = [NSNumber numberWithFloat:fromValue];
    a.toValue = [NSNumber numberWithFloat:toValue];
    a.fillMode = kCAFillModeForwards;
    a.beginTime = [runeButton.layer convertTime:CACurrentMediaTime() fromLayer:nil] + timeOffset;
    a.duration = duration;
    a.removedOnCompletion = NO;
    [runeButton.layer addAnimation:a forKey:nil];
}


#pragma mark-UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *view = nil;

        if (scrollView == self.scrollView)
        {
            view = self.view2;
        }
    
    return view;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (_zoomEnabled) {
        if (self.view2.frame.size.height<=430.0f)
        {
            NSLog(@"view 2 frame size is smaller than 430");
            __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
            [weakParent switchViewControllerFromZoomOutMainMapToMenuThreeButtons:((UIImageView*)[self.view viewWithTag:8000])];
            
        }
        else if ((self.view2.frame.size.height<730.0f)&&(self.view2.frame.size.height>430.0f))
        {
            NSLog(@"view 2 size in interval (430,730)");
            [self centerScrollViewContents:self.view2];

        }
        else
        {
            NSLog(@"The scroll view has zoomed, so we need to re-center the contents");
            [self centerScrollViewContents:self.view2];
        }

    }
  }

-(UIImage*) takeViewScreenShot:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen]scale]);
    [[view layer]renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
}

- (void)centerScrollViewContents:(UIView*)yourView {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = yourView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    yourView.frame = contentsFrame;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}



@end
