//
//  DetailsViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

#import "MapDetailsViewController.h"
#import "MainMapViewController.h"
#import "MainMapZoomInViewController.h"
#import "Fugitive.h"
#import "Subobjective.h"
#import "AppDelegate.h"
#import "ButtonObjectClass.h"
#import "macros.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImmediateLoading.h"
#import "SubobjectiveButton.h"

@interface MapDetailsViewController ()

@end

@implementation MapDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    self.date=[self.datePicker date];
    self.view.backgroundColor=[UIColor brownColor];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)dateDidChange:(UIDatePicker*)sender
{
    NSDate * oneSecondAfterPickersDate = [self.datePicker.date dateByAddingTimeInterval:1];
    if ([self.datePicker.date compare:self.datePicker.minimumDate]==NSOrderedSame) {
        NSLog(@"date is at or below the minimum");
        self.datePicker.date=oneSecondAfterPickersDate;
    }
    else if ([self.datePicker.date compare:self.datePicker.maximumDate]==NSOrderedSame)
    {
        NSLog(@"date is at or above the maximum");
        self.datePicker.date=oneSecondAfterPickersDate;
    }
}

-(void)showSubobjectivesName:(Subobjective*)subobjective delay:(CGFloat)delay 
{
    CGRect frameOfSubobjectiveView;
    UIView *viewOfSubobjectives;
    if (![self.view viewWithTag:kViewSubobjectiveNames])
    {
        CGRect frameOfSubobjectiveView = CGRectMake (self.numberOfSubojectives.frame.origin.x,self.numberOfSubojectives.frame.origin.y+50.0f,250.0f,50.0f);
        viewOfSubobjectives = [[UIView alloc]initWithFrame:frameOfSubobjectiveView];
        viewOfSubobjectives.tag = kViewSubobjectiveNames;

    }
    else
    {
        viewOfSubobjectives = [self.view viewWithTag:kViewSubobjectiveNames];
        frameOfSubobjectiveView = CGRectMake(self.numberOfSubojectives.frame.origin.x, self.numberOfSubojectives.frame.origin.y+50.0f, 250.0f, viewOfSubobjectives.frame.size.height+25.0f);
        viewOfSubobjectives.frame=frameOfSubobjectiveView;
    }
    
    
    //viewOfSubobjectives.backgroundColor = [UIColor yellowColor];
    CGRect frameLabel;
    if ([[viewOfSubobjectives subviews]lastObject])
    {
    CGRect frameLabelOld = ((UIView*)[[viewOfSubobjectives subviews]lastObject]).frame;
        frameLabel = CGRectMake(0.0f, frameLabelOld.origin.y+30, 150.0f, 20.0f);
    }
    else
    {
         frameLabel = CGRectMake(0.0f, 10.0f, 150.0f, 20.0f);
    }
    UILabel *label = [[UILabel alloc]initWithFrame:frameLabel];
    CGRect frameCheckMark = CGRectMake(label.frame.origin.x+label.frame.size.width+50.0f, label.frame.origin.y-15.0f, 40.0f, 40.0f);
    label.backgroundColor = [UIColor clearColor];
    viewOfSubobjectives.userInteractionEnabled=YES;
    viewOfSubobjectives.backgroundColor = [UIColor clearColor];
    SubobjectiveButton *checkButton = [[SubobjectiveButton alloc]initWithFrame:frameCheckMark];
    if ([subobjective.isReached boolValue])
    {
        [checkButton setBackgroundImage:[self checkMarkImage] forState:UIControlStateNormal];
    }
    else
    {
        [checkButton setBackgroundImage:[self boxImage] forState:UIControlStateNormal];
    }
    checkButton.subobjective=subobjective;
    checkButton.frame = frameCheckMark;
    checkButton.alpha = 1.0f;
    [checkButton setBackgroundColor:[UIColor clearColor]];
    //[checkButton sizeToFit];
    [checkButton addTarget:self action:@selector(checkMarkTap:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
        label.backgroundColor = [UIColor clearColor];
        NSString *name = [NSString stringWithFormat:@"-%@",subobjective.name];
        label.text = name;
    label.alpha=1.0f;
    label.textColor=[UIColor whiteColor];
    [viewOfSubobjectives addSubview:checkButton];
    [viewOfSubobjectives addSubview:label];


    
    
    [self.view addSubview:viewOfSubobjectives];
    
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"opacity"];
    a.fromValue = [NSNumber numberWithFloat:0];
    a.toValue = [NSNumber numberWithFloat:1];
    a.fillMode = kCAFillModeBackwards;
    a.beginTime = [label.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delay;
    a.duration = 0.3f;
    a.removedOnCompletion = YES;
    a.cumulative=YES;
    
    [label.layer addAnimation:a forKey:nil];
    [checkButton.layer addAnimation:a forKey:nil];
    
    checkButton.userInteractionEnabled=YES;
    checkButton.imageView.userInteractionEnabled=YES;

}

-(void)checkMarkTap:(SubobjectiveButton*)button
{
    NSLog(@"check mark tapped with subobjective name%@",button.subobjective.name);
    BOOL reached = [button.subobjective.isReached boolValue];
    button.subobjective.isReached = [NSNumber numberWithBool:!reached];
    if ([button.subobjective.isReached boolValue])
    {
        [button setBackgroundImage:[self checkMarkImage] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[self boxImage] forState:UIControlStateNormal];
    }

}

-(IBAction)circleSelected:(id)sender
{
    @autoreleasepool
    {
    [self.delegate createButton:self.buttonTypeToCreate atCircleWithDate:[self.datePicker date]];
        self.delegate=nil;
    }

    
}
-(IBAction)addSubObjective:(id)sender
{
    //[[self.view viewWithTag:kViewSubobjectiveNames] removeFromSuperview];
    static int nameCount=1;
    NSLog(@"Button to create subobjective pressed.");
    self.toDoAssignment.numberOfSubobj=[NSNumber numberWithInt:([self.toDoAssignment.numberOfSubobj intValue]+1)];
    self.numberOfSubojectives.text=[NSString stringWithFormat:@"Number of sub-objectives: %d",[self.toDoAssignment.numberOfSubobj intValue]];
    [self.numberOfSubojectives sizeToFit];
    AppDelegate *pAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Subobjective" inManagedObjectContext:[pAppDelegate managedObjectContext]];

    Subobjective *subObjective = [[Subobjective alloc]initWithEntity:entity insertIntoManagedObjectContext:[pAppDelegate managedObjectContext]];
    subObjective.parentObj = self.toDoAssignment;
    subObjective.name=[NSString stringWithFormat:@"subobj #%d",nameCount];
    subObjective.desc=@"please, reach me!";
    subObjective.isReached = [NSNumber numberWithBool:NO];
  
    nameCount++;
    [self showSubobjectivesName:subObjective delay:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frameButton = self.buttonToCreateSubObjective.frame;
        frameButton.origin=CGPointMake(frameButton.origin.x, [self.view viewWithTag:kViewSubobjectiveNames].frame.size.height+[self.view viewWithTag:kViewSubobjectiveNames].frame.origin.y+10.0f);
        
        self.buttonToCreateSubObjective.frame = frameButton;}];
    
    if ([self.toDoAssignment.numberOfSubobj intValue]>=7) {
        self.buttonToCreateSubObjective.enabled=NO;
        self.buttonToCreateSubObjective.alpha=.7f;
    }
    else if ([self.toDoAssignment.numberOfSubobj intValue]==1)
    {
        if ([self.delegate isKindOfClass:[MainMapViewController class]])
        {
             [self.delegate setImageButton:self.selectedButton ForState:kButtonStateHasSubobjectives];
        }
    }
    if ([self.delegate isKindOfClass:[MainMapZoomInViewController class]])
    {
        [self.delegate updateButtonSubobjective:self.buttonFromZoomIn];
    }
    
}

-(void)setupDetailView:(__weak ButtonObjectClass*)button createNewButton:(BOOL)createNewButton showDetailsOfExisted:(BOOL)showDetailsOfExisted
{
    if (showDetailsOfExisted)
    {
        self.toDoAssignment=button.toDoAssignment;
        self.circle1.alpha=0.0f;
        self.buttonToCreateSubObjective.alpha=1.0f;
        self.numberOfSubojectives.alpha=1.0f;
        NSArray *arrayOfSubobj = [button.toDoAssignment.subObjective allObjects];
        self.numberOfSubojectives.text = [NSString stringWithFormat:@"Number of sub-objectives: %@",[[NSNumber numberWithInteger:[arrayOfSubobj count]] stringValue]];
        [self.numberOfSubojectives sizeToFit];
        self.name.alpha=1.0f;
        self.name.text=button.toDoAssignment.name;
        [self.name sizeToFit];
        self.objectiveNameTitle.alpha=1.0f;
        [self.objectiveNameTitle sizeToFit];
        self.datePicker.date=button.date;
        self.datePicker.minimumDate=button.date;
        self.datePicker.maximumDate=button.date;
        self.datePicker.userInteractionEnabled=NO;
        [[self.view viewWithTag:kViewSubobjectiveNames] removeFromSuperview];
        CGFloat delay = 0.0f;
        for (Subobjective *subobj in button.toDoAssignment.subObjective)
        {
            [self showSubobjectivesName:subobj delay:delay];
            delay +=.05f;
        }
        if ([self.view viewWithTag:kViewSubobjectiveNames])
        {
            [UIView animateWithDuration:0.3f animations:^{
                
                CGRect frameButton = self.buttonToCreateSubObjective.frame;
                frameButton.origin=CGPointMake(frameButton.origin.x, [self.view viewWithTag:kViewSubobjectiveNames].frame.size.height+[self.view viewWithTag:kViewSubobjectiveNames].frame.origin.y+10.0f);
                
                self.buttonToCreateSubObjective.frame = frameButton;
                
                
            }];

        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                
                CGRect frameButton = self.buttonToCreateSubObjective.frame;
                frameButton.origin=CGPointMake(frameButton.origin.x, self.numberOfSubojectives.frame.size.height+ self.numberOfSubojectives.frame.origin.y+10.0f);
                
                self.buttonToCreateSubObjective.frame = frameButton;
                
                
            }];
        }
    }
}

-(void)detailViewForCreatingNew
{
    
}

-(UIImage*)checkMarkImage
{
    UIImage *image = [UIImage imageWithIdentifier:@"checkMark" forSize:CGSizeMake(50.0f, 50.0f) andDrawingBlock:^{
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        UIColor *strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        UIColor *color = [UIColor colorWithRed:1.0f green:0.114f blue:0.114f alpha:1.0f];
        
        //frames
        CGRect frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        
        ////Rectangle Drawing
        UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(frame)+5.5f,CGRectGetMinY(frame)+19.5f, 26.0f, 24.0f)];
        [fillColor setStroke];
        rectanglePath.lineWidth=1.5f;
        [rectanglePath stroke];
        
        
        
        ////Bezier 3 Drawing
        UIBezierPath *bezier3Path = [UIBezierPath bezierPath];
        [bezier3Path moveToPoint:CGPointMake(CGRectGetMinX(frame)+12.5f, CGRectGetMinY(frame)+35.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+19.5f, CGRectGetMinY(frame)+42.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+42.5f, CGRectGetMinY(frame)+12.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+35.5f, CGRectGetMinY(frame)+7.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+19.5f, CGRectGetMinY(frame)+35.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+12.5f, CGRectGetMinY(frame)+27.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+7.5f, CGRectGetMinY(frame)+31.5f)];
        [bezier3Path addLineToPoint:CGPointMake(CGRectGetMinX(frame)+12.5f, CGRectGetMinY(frame)+35.5f)];
        [bezier3Path closePath];
        
        bezier3Path.lineJoinStyle = kCGLineJoinBevel;
        [color setFill];
        [[UIColor whiteColor] setStroke];
        bezier3Path.lineWidth=1.0f;
        [bezier3Path stroke];
        [bezier3Path fill];
        
    }];
    return image;
}
-(UIImage*)boxImage
{
UIImage *image = [UIImage imageWithIdentifier:@"box" forSize:CGSizeMake(50.0f, 50.0f) andDrawingBlock:^{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    UIColor *strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    UIColor *color = [UIColor colorWithRed:1.0f green:0.114f blue:0.114f alpha:1.0f];
    
    //frames
    CGRect frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    
    ////Rectangle Drawing
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMinX(frame)+5.5f,CGRectGetMinY(frame)+19.5f, 26.0f, 24.0f)];
    [fillColor setStroke];
    rectanglePath.lineWidth=1.5f;
    [rectanglePath stroke];
    
    }];
return image;
}



@end
