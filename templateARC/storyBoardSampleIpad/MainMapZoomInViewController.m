//
//  MainMapZoomInViewController.m
//  templateARC
//
//  Created by Mac Owner on 5/24/13.
//
//

#import "MainMapZoomInViewController.h"
#import "CircleView.h"
#import "CoordinatesController.h"
#import "ButtonObjectClass.h"
#import <QuartzCore/QuartzCore.h>
#import "CombinedViewController.h"
#import "Fugitive.h"
#import "Subobjective.h"
#import "MainMapViewController.h"
#import "MapDetailsViewController.h"
#import "FinanceButton.h"
#import "FinanceSubobjectButton.h"
#import "HealthButton.h"
#import "HealthSubobjectButton.h"
#import "pLifeButton.h"
#import "pLifeSubobjectButton.h"
#import <math.h>
#import <CoreText/CoreText.h>

#define PI 3.14

@interface MainMapZoomInViewController ()
@property (strong,nonatomic) NSArray *listOfAssignmentsToShow;
@property (strong,nonatomic) NSMutableArray * arrayOfCreatedButtons;
@property (strong,nonatomic) UILabel *noObjectivesLabel;
@property (strong, nonatomic) NSMutableArray *arrayOfCreatedSubobjectives;
-(void)setupButtonMovementWithStep:(short int)step indexOfObject:(NSUInteger)indexOfObject delay:(CGFloat) delay duration:(CGFloat)duration angle:(CGFloat)angleRotation tapObjective:(BOOL)isButtonTapped tapCreateNewObjective:(BOOL)needToCreateNewObjective tapCreateNewObjectiveCancelled:(BOOL)createCancelled;

@end

@implementation MainMapZoomInViewController
{
    CGPoint _anchorPointViewOnCircle;
    NSMutableArray *_mainArrayOfCoordinatesForSubobjective;
    NSMutableArray *_oddArrayOfCoordinatesForSubobjective;
    unsigned int buttonTagValue;
    subButtonTypes _subbuttonType;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    buttonTagValue=5002;
    //setting selected appropriate main button, other buttos alpha 0.65
    [self additionalSetupViewAfterItDidLoad];
    [self showAllSubobjectivesOfSelectedButton:self.selectedButton];
}

-(void)additionalSetupViewAfterItDidLoad
{
    NSMutableArray * array = [NSMutableArray array];
    self.arrayOfCreatedButtons=array;
    NSMutableArray *arrayOfSubobjectives = [NSMutableArray array];
    self.arrayOfCreatedSubobjectives = arrayOfSubobjectives;
    
    self.tapGestureRecognizer.enabled=NO;
    self.isDetailViewOn=NO;
    
    
    UIImage *image=[self setSelectedAppropriateMainButtonAccordingToTheSelectedSubbutton:self.selectedButton];
	// Do any additional setup after loading the view.
    [self initCircleViewWithRadius:1.4*360 withBrush:1.4f*80 tag:1012 alphaParam:0.35f needToCreateArray:NO needToCreateArrayForSubobjective:YES];
    self.circle=(CircleView*)[self.view2 viewWithTag:1012];
    self.circle.arraySubobjectivesCoordinatesToDrawButton=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:213 toAngle:400 withDeltaBetweenButtons:150 assignTypeOfButton:kButtonSubobject];
    self.circle.date=self.selectedButton.date;
    self.listOfAssignmentsToShow=[self createListOfAssignmentsThatNeedsToBeShown];
    
    
    for (int i=1; i<6; i++)
    {
        UIImageView *imgv3=[[UIImageView alloc]initWithImage:image];
        [self convertViewtoMainMapCoordinates:[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:i] fromCircle:self.circle];
        if (_anchorPointViewOnCircle.y!=0.5f) {
            [self setAnchorPoint:_anchorPointViewOnCircle forView:imgv3];
        }
        
        imgv3.center=((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:i]).pointToDrawButton;
        imgv3.transform=CGAffineTransformRotate(imgv3.transform, (((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:i]).degreeValue-270)*PI/180.0f);
        imgv3.tag=1000+i;
        //if button is not in the center, animate the opacity
        if ([self.listOfAssignmentsToShow count]==1) {
            if (i!=3)
            {
                imgv3.alpha=0.0f;
                [UIView animateWithDuration:0.35f animations:^{ imgv3.alpha=1.0f;}];
            }

        }
        else if ([self.listOfAssignmentsToShow count]==3)
        {
            if ((i==1)||(i==5))
            {
                imgv3.alpha=0.0f;
                [UIView animateWithDuration:0.35f animations:^{ imgv3.alpha=1.0f;}];
            }
        }
        else if ([self.listOfAssignmentsToShow count]==2)
        {
            if ((i==1)||(i==5)||(i==4)) {
                imgv3.alpha=0.0f;
                [UIView animateWithDuration:0.35f animations:^{ imgv3.alpha=1.0f;}];
                
            }
        }
        else if ([self.listOfAssignmentsToShow count]==4)
        {
            if (i==5) {
                imgv3.alpha=0.0f;
                [UIView animateWithDuration:0.35f animations:^{ imgv3.alpha=1.0f;}];
                
            }
        }
        
        [self.view2 insertSubview:imgv3 aboveSubview:self.circle];
    }
    self.selectedButton.tag=5001;
    [self.selectedButton addTarget:self action:@selector(buttonObjectiveTapped:) forControlEvents:UIControlEventTouchUpInside];

    self.selectedButton.numberOfPositionOnTheCircle=3;
    _subbuttonType=self.selectedButton.subbuttonType;
    [self showAllAssignmentsFromArray:self.listOfAssignmentsToShow ExceptSelectedButton:self.selectedButton];
    
    self.selectedButton.center=((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:3]).pointToDrawButton;
    [self.view2 addSubview:self.selectedButton];
    [self.arrayOfCreatedButtons addObject:self.selectedButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------
//в зависимости от типа выбранной цели, возвращаем картинку, которая будет фоновой
//для кнопки, а также дополнительной задаем прозрачность главных кнопок
//-----------
-(UIImage*)setSelectedAppropriateMainButtonAccordingToTheSelectedSubbutton:(ButtonObjectClass*)button
{
    UIImage *image;
    if (button.subbuttonType==kFinanceSubButtonType)
    {
        [self.finance setSelected:YES];
        [self.health setAlpha:0.65f];
        [self.privateLife setAlpha:0.65f];
        image=[UIImage imageNamed:@"fg.png"];
        _anchorPointViewOnCircle=CGPointMake(0.5f, 0.5f);
        self.health.enabled=NO;
        self.privateLife.enabled=NO;
    }
    else if (button.subbuttonType==kHealthSubButtonType)
    {
        [self.health setSelected:YES];
        [self.privateLife setAlpha:0.65f];
        [self.finance setAlpha:0.65f];
         image=[UIImage imageNamed:@"hg.png"];
        _anchorPointViewOnCircle=CGPointMake(0.5f, 0.5f);
        self.privateLife.enabled=NO;
        self.finance.enabled=NO;

    }
    else if (button.subbuttonType==kPrivateLifeSubButtonType)
    {
        [self.privateLife setSelected:YES];
        [self.finance setAlpha:0.65f];
        [self.health setAlpha:0.65f];
        image=[UIImage imageNamed:@"pg.png"];
        _anchorPointViewOnCircle=CGPointMake(46.0f/109.0f, 50.0f/153.0f);
        self.finance.enabled=NO;
        self.health.enabled=NO;
       
    }
    return image;
}
#pragma mark-Circle View and Convert Coordinate method
//-------
//инициализация класса окружности с заданными параметрами радиуса, толщины,
//прозрачности
//-------
-(void)initCircleViewWithRadius:(CGFloat)radiusOfCircle withBrush:(CGFloat)brush tag:(int)tag alphaParam:(CGFloat)alphaParam needToCreateArray:(BOOL)needToCreateArray needToCreateArrayForSubobjective:(BOOL)needToCreateArrayForSubobjective
{
    
    CGFloat width=2*(radiusOfCircle)+brush;
    CGRect frame= CGRectMake(0.0f, 0.0f, width, width);
    CircleView *circleView=[[CircleView alloc]initWithFrame:frame];
    circleView.center=CGPointMake(self.containerForMainCommas.center.x,self.containerForMainCommas.center.y+280.6f);
    circleView.brush=brush;
    circleView.isVisible=YES;
    circleView.tag=tag;
    circleView.alphaParam=alphaParam;
    circleView.needToCreateArray=needToCreateArray;
    circleView.needToCreateArrayForSubobjectives=needToCreateArrayForSubobjective;
    [circleView createArraysWithCoordinatesForAllButtonTypes];
    [self.view2 insertSubview:circleView belowSubview:self.containerForMainCommas];
}
//----------
//конвертация координаты в главную систему координат в левом верхнем углу
//----------
-(void)convertViewtoMainMapCoordinates:(CoordinatesController*)coordinate fromCircle:(CircleView*)circle
{
    if (!coordinate.isPointConverted)
    {
        CGPoint startPointOfCoordinateSystem=CGPointMake(circle.frame.origin.x,circle.frame.origin.y);
        
        coordinate.pointToDrawButton=CGPointMake(coordinate.pointToDrawButton.x+startPointOfCoordinateSystem.x,startPointOfCoordinateSystem.y+coordinate.pointToDrawButton.y);
        coordinate.isPointConverted=YES;
    }
}
//--------
//задание точки-"якоря" для вида
//--------
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
#pragma mark-Button's methods
//---------
//показать все субцели для заданной кнопки
//---------
-(void)showAllSubobjectivesOfSelectedButton:(ButtonObjectClass*)button
{
    if (self.noObjectivesLabel)
    {
        [self.noObjectivesLabel removeFromSuperview];
        //self.noObjectivesLabel = nil;
    }
    if (!([self.arrayOfCreatedSubobjectives count]==0))
    {
        for (ObjectiveButtonClass *subobjective in self.arrayOfCreatedSubobjectives) {
            [subobjective removeFromSuperview];
        }
        [self.arrayOfCreatedSubobjectives removeAllObjects];
    }
    
    //[[self.view viewWithTag:button.tag+2000] removeFromSuperview];
    //[[self.view viewWithTag:button.tag+3000] removeFromSuperview];
    NSArray *arrayOfSubobjectives=[button.toDoAssignment.subObjective allObjects];
    if ([arrayOfSubobjectives count]!=0)
    {
        NSUInteger numberAtSubobjectiveCircle=0;
        for (Subobjective *subobj in arrayOfSubobjectives)
        {
            id buttonBuffer;
            if (button.subbuttonType==kFinanceSubButtonType)
            {
                FinanceSubobjectButton *financeSubobj=[[FinanceSubobjectButton alloc]init];
                financeSubobj.subobjective=subobj;
                if ([subobj.isReached boolValue])
                 {
                    
                        [financeSubobj setBackgroundImage:financeSubobj.isReachedImage forState:UIControlStateNormal];
                 }
                    else
                    {
                        [financeSubobj setBackgroundImage:financeSubobj.isNotReachedImage forState:UIControlStateNormal];
                        
                    }

                
                buttonBuffer=financeSubobj;
            }
            else if (button.subbuttonType==kHealthSubButtonType)
            {
                HealthSubobjectButton *healthSubobj=[[HealthSubobjectButton alloc]init];
                healthSubobj.subobjective=subobj;
                if ([subobj.isReached boolValue])
                {
                    [healthSubobj setBackgroundImage:healthSubobj.isReachedImage forState:UIControlStateNormal];
                }
                else
                {
                    [healthSubobj setBackgroundImage:healthSubobj.isNotReachedImage forState:UIControlStateNormal];

                }
                buttonBuffer=healthSubobj;
            }
            else if (button.subbuttonType==kPrivateLifeSubButtonType)
            {
                pLifeSubobjectButton *privateLifeSubobj=[[pLifeSubobjectButton alloc]init];
                [self setAnchorPoint:CGPointMake(60.0f/100.0f, 38.0f/85.0f) forView:privateLifeSubobj];
                buttonBuffer=privateLifeSubobj;
            }
            //-------------------
            //размещение субцелей, если их количество нечетно
            //всегда в -90 градусов ставить субцель
            //-------------------
            if (!([arrayOfSubobjectives count]%2==0))
            {
                //создаем координаты на окружности с центром в главной цели
                //в секторе от -150  до -20 градусов
                if (!_mainArrayOfCoordinatesForSubobjective) {
                    _mainArrayOfCoordinatesForSubobjective=[NSMutableArray array];
                    for (int i=-150; i<-20; i+=20) {
                        [_mainArrayOfCoordinatesForSubobjective addObject:[self createCoordinateForSubobjectiveWithAngle:i forButton:button]];
                    }
                }
                
                if ([arrayOfSubobjectives count]==5)
                {
                    if (numberAtSubobjectiveCircle==0)
                    {
                        //переборка координат с 1
                        numberAtSubobjectiveCircle=1;
                    }
                }
                else if ([arrayOfSubobjectives count]==3)
                {
                    if (numberAtSubobjectiveCircle==0)
                    {
                        numberAtSubobjectiveCircle=2;
                    }
                }
                else if ([arrayOfSubobjectives count]==1)
                {
                    if (numberAtSubobjectiveCircle==0)
                    {
                        numberAtSubobjectiveCircle=3;
                    }
                }
                [self createButton:buttonBuffer withAssignment:subobj.parentObj andSubobjective:subobj onCoordinate:[_mainArrayOfCoordinatesForSubobjective objectAtIndex:numberAtSubobjectiveCircle] buttonTagValue:button.tag+2000 numberOfPlaceOnTheCircle:3];
                numberAtSubobjectiveCircle++;
                
            }
            //если количество субцелей четно
            else
            {
                if (!_oddArrayOfCoordinatesForSubobjective)
                {
                    _oddArrayOfCoordinatesForSubobjective=[NSMutableArray array];
                    for (int i=-140; i<-30; i+=20)
                    {
                        [_oddArrayOfCoordinatesForSubobjective addObject:[self createCoordinateForSubobjectiveWithAngle:i forButton:button]];
                    }
                }
                if ([arrayOfSubobjectives count]==4)
                {
                    if (numberAtSubobjectiveCircle==0)
                    {
                        //переборка координат с 1
                        numberAtSubobjectiveCircle=1;
                    }
                }
                else if ([arrayOfSubobjectives count]==2)
                {
                    if (numberAtSubobjectiveCircle==0)
                    {
                        numberAtSubobjectiveCircle=2;
                    }
                }
                [self createButton:buttonBuffer withAssignment:subobj.parentObj andSubobjective:subobj onCoordinate:[_oddArrayOfCoordinatesForSubobjective objectAtIndex:numberAtSubobjectiveCircle] buttonTagValue:button.tag+2000 numberOfPlaceOnTheCircle:3];
                numberAtSubobjectiveCircle++;
                
            }
            
            
        }

    }
    else
    {
        if (!self.noObjectivesLabel)
        {
        UILabel *labelNotExistingSubobj=[[UILabel alloc]init];
        labelNotExistingSubobj.text=@"This goal does not have any subobjectives yet.";
        [labelNotExistingSubobj sizeToFit];
        labelNotExistingSubobj.backgroundColor=[UIColor clearColor];
        labelNotExistingSubobj.textColor=[UIColor whiteColor];
        labelNotExistingSubobj.center=[self createCoordinateForSubobjectiveWithAngle:-90 forButton:button].pointToDrawButton;
        labelNotExistingSubobj.alpha=0.0;
        self.noObjectivesLabel=labelNotExistingSubobj;
        }
        self.noObjectivesLabel.alpha=0.0f;
        [self.view2 addSubview:self.noObjectivesLabel];

        [UIView animateWithDuration:0.2f animations:^{self.noObjectivesLabel.alpha=1.0f;}];
        

       /* UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50, 100)];
        [path addLineToPoint:CGPointMake(50, 200)];
        [self.view.layer addSublayer:self.layerLine];
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = CGRectMake(369, 100, 100, 300);
        pathLayer.geometryFlipped = YES;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [[UIColor colorWithRed:255.0f/255.0f green:250.0f/255.0f blue:250.0f alpha:0.6f] CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = 2.0f;
        pathLayer.lineJoin = kCALineJoinBevel;

        [self.view.layer addSublayer:pathLayer];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.2f;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];*/
        
    }
}
//-------------
//text animation layer
//-------------
//--------
//создать координату на окружности, центром которой является кнопка (цель)
//--------
-(CoordinatesController*)createCoordinateForSubobjectiveWithAngle:(int)angle forButton:(ButtonObjectClass*)button
{
    //---------------------------
    //radius of circle:250 points
    //center: selected button center
    //---------------------------
    CoordinatesController *coordinate=[[CoordinatesController alloc]init];
    coordinate.pointToDrawButton=CGPointMake(button.center.x+250*cos(angle*PI/180.0f),button.center.y+250*sin(angle*PI/180.0f));
    coordinate.pointIsEmpty=YES;
    coordinate.isPointConverted=YES;
    coordinate.degreeValue=angle;
    return coordinate;
}
//-------------------
//метод добавляющий на круг 4 цели (кроме выбранной)
//-------------------
-(void)showAllAssignmentsFromArray:(NSArray*)array ExceptSelectedButton:(ButtonObjectClass*)button
{
    if ([array count]>1)
    {
        int numberOfPlaceOnCircle;
        //номер позиции кнопки убывает в арифметической прогрессии
        //размер массива i-ый элемент этой прогрессии
        //таким образом находим с какой позиции начинать нумерацию кнопок, так чтобы
        //количество кнопок слева и справа было одинаковым
        int firstMemberInCountProgression, indexOfMemberInProgression,stepInProgressionCount,stepInNumberOnCircleProgression,firstMemberOnCircleProgression;
        if ([array count]%2==0)
        {
            firstMemberInCountProgression=2;
        }
        else
        {
            firstMemberInCountProgression=3;
        }
        firstMemberOnCircleProgression=2;
        stepInProgressionCount=2;
        stepInNumberOnCircleProgression=-1;
        indexOfMemberInProgression=([array count]-firstMemberInCountProgression)/stepInProgressionCount+1;
        
        numberOfPlaceOnCircle=(indexOfMemberInProgression-1)*stepInNumberOnCircleProgression+firstMemberOnCircleProgression;
        //переборка все целей в БД на заданную дату
            for (Fugitive *toDoAssignment in self.listOfAssignmentsToShow)
            {
                //условие того, что цель не выбрана
                if (![toDoAssignment isEqual:self.selectedButton.toDoAssignment])
                {
                    if (numberOfPlaceOnCircle==3)
                    {
                        numberOfPlaceOnCircle++;
                    }
                    
                    [self setupButtonOnTheCoordinateNumber:numberOfPlaceOnCircle andSetToDoListAssingment:toDoAssignment buttonTagValue:buttonTagValue];
                    numberOfPlaceOnCircle++;
                }

            }
        
    }
}
//---------------
//создаем массив из целей, которые необходимо показать
//---------------

-(NSDate*)setupWithComponentsDate:(NSDate*)yourDate hour:(unsigned int)hour minute:(unsigned int)minute second:(unsigned int)second
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.selectedButton.date];
    
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    [dateComponents setSecond:second];
    
    return [gregorian dateFromComponents:dateComponents];
}
-(NSArray*)createListOfAssignmentsThatNeedsToBeShown
{
    NSDate *startDate = [self setupWithComponentsDate:self.selectedButton.date hour:0 minute:0 second:0];
    NSDate *endDate = [self setupWithComponentsDate:self.selectedButton.date hour:23 minute:59 second:59];
    NSMutableArray *arrayOfAssignments=[NSMutableArray new];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext=appDelegate.managedObjectContext;
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setReturnsObjectsAsFaults:NO];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescritptor=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSError *error;
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"(type like [cd] %@) AND (date >= %@) AND (date <= %@)",self.selectedButton.stringType, startDate, endDate];
    [request setPredicate:pred];
    
    NSMutableArray *mutableFetchResults=[[managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    if (mutableFetchResults==nil)
    {
        NSLog(@"There are no subobjectives. Error.");
    }
    [mutableFetchResults sortUsingDescriptors:[NSArray arrayWithObject:sortDescritptor]];

   // __weak CombinedViewController *weakParent=(CombinedViewController*)self.parentViewController;
    NSInteger dayOfDateAssignment;
    NSInteger monthOfDateAssignment;
    NSInteger dayOfCircle1=[MainMapViewController getDayIntegerFromDate:self.circle.date];
    NSInteger monthOfCircle1=[MainMapViewController getMonthIntegerFromDate:self.circle.date];
    for (Fugitive *toDoAssignment in mutableFetchResults)
        {
        dayOfDateAssignment=[MainMapViewController getDayIntegerFromDate:toDoAssignment.date];
        monthOfDateAssignment=[MainMapViewController getMonthIntegerFromDate:toDoAssignment.date];
        //checking the date of toDoAssignment and Circle Date Tag
        if ((dayOfDateAssignment==dayOfCircle1)&&(monthOfDateAssignment==monthOfCircle1))
            {
                if ([toDoAssignment.type isEqualToString:self.selectedButton.stringType]) {
                     [arrayOfAssignments addObject:toDoAssignment];
                }
            }
        }
    return arrayOfAssignments;
}
//-------------
//создать цель под порядковым номером на круге (всего 5)
//-------------
-(void)setupButtonOnTheCoordinateNumber:(int)numberOfPlaceOnCircle andSetToDoListAssingment:(Fugitive*)assignment buttonTagValue:(unsigned int)buttonTag
{
    id bufferButton;
    if (self.selectedButton.subbuttonType==kFinanceSubButtonType)
    {
        FinanceButton *financeOnCircle=[[FinanceButton alloc]init];
        bufferButton=financeOnCircle;
    }
    else if (self.selectedButton.subbuttonType==kHealthSubButtonType)
    {
        HealthButton *healthOnCircle=[[HealthButton alloc]init];
        bufferButton=healthOnCircle;
    }
    else if (self.selectedButton.subbuttonType==kPrivateLifeSubButtonType)
    {
        pLifeButton *privateLifeOnCircle=[[pLifeButton alloc]init];
        bufferButton=privateLifeOnCircle;
       
    }
      if ((numberOfPlaceOnCircle<0)||(numberOfPlaceOnCircle>6))
      {
          CoordinatesController *coordinate = [[CoordinatesController alloc]init];
          coordinate.pointToDrawButton=CGPointMake(-100,800);
          coordinate.pointIsEmpty=YES;
          coordinate.isPointConverted=YES;
          coordinate.degreeValue=(3-numberOfPlaceOnCircle)*(-19)+270;
          [self createButton:bufferButton withAssignment:assignment andSubobjective:nil onCoordinate:coordinate buttonTagValue:buttonTagValue numberOfPlaceOnTheCircle:numberOfPlaceOnCircle];
      }
      else
      {
          [self createButton:bufferButton withAssignment:assignment andSubobjective:nil onCoordinate:[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:numberOfPlaceOnCircle] buttonTagValue:buttonTagValue numberOfPlaceOnTheCircle:numberOfPlaceOnCircle];
      }
    
}
//---------------
//создаем кнопку с назначением свойста цели под порядковым номером на окружности
//---------------
-(void)createButton:(ObjectiveButtonClass*)button withAssignment:(Fugitive*)assignment andSubobjective:(Subobjective*)subobjective onCoordinate:(CoordinatesController*)coordinate buttonTagValue:(unsigned int)buttonTag numberOfPlaceOnTheCircle:(int)numberOfPlaceOnTheCircle
{
    if (coordinate.pointIsEmpty)
    {
        button.tag=buttonTag;
        buttonTagValue++;
        [self convertViewtoMainMapCoordinates:coordinate fromCircle:self.circle];
        button.center=coordinate.pointToDrawButton;
       
        button.toDoAssignment=assignment;
        coordinate.pointIsEmpty=YES;
        UIEdgeInsets titleInsets = UIEdgeInsetsMake(-75.0, -150.0, 0.0, 0.0);
        button.titleEdgeInsets = titleInsets;
        [button sizeToFit];
        button.date=self.circle.date;
        int angle=0;
        if (button.subbuttonType==kFinanceSubButtonType)
        {
            angle=-12;
        }
        if ((numberOfPlaceOnTheCircle>=0)&&(numberOfPlaceOnTheCircle<=6))
        {
        button.alpha=0.0f;
        [UIView animateWithDuration:0.4f animations:^{
            button.transform=CGAffineTransformRotate(button.transform, (coordinate.degreeValue+angle-270)*PI/180.0f);
            button.alpha=1.0f;
        }];
            [button addTarget:self action:@selector(buttonObjectiveTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view2 addSubview:button];
        }
        else if ((numberOfPlaceOnTheCircle<0)||(numberOfPlaceOnTheCircle>6))
        {
            button.transform=CGAffineTransformRotate(button.transform, (coordinate.degreeValue+angle-270)*PI/180.0f);
            [button addTarget:self action:@selector(buttonObjectiveTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setHidden:YES];
        }
        if (subobjective) {
            [button setTitle:subobjective.name forState:UIControlStateNormal];
            button.subobjective=subobjective;
            [self.arrayOfCreatedSubobjectives addObject:button];
        }
        else
        {
            [button setTitle:assignment.name forState:UIControlStateNormal];
            button.numberOfPositionOnTheCircle=numberOfPlaceOnTheCircle;
            
            //[button addTarget:self action:@selector(startGlitter:) forControlEvents:UIControlEventTouchUpInside];
            //[button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            //[button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
            [self.arrayOfCreatedButtons addObject:button];
        }
        if (button.subbuttonType==kHealthSubobjectButton)
        {
            [self createImageViewForSubobjectiveType:kHealthSubobjectButton withAnchorPoint:CGPointMake(1.0f, 0.35f) rotationTransformAnge:(coordinate.degreeValue)*PI/180.0f center:button.center alpha:0.75f tag:buttonTag+1000];
        }
        else if (button.subbuttonType==kFinanceSubobjectButton)
        {
            [self createImageViewForSubobjectiveType:kFinanceSubobjectButton withAnchorPoint:CGPointMake(0.0f, 0.6f) rotationTransformAnge:(coordinate.degreeValue)*PI/180.0f+PI center:button.center alpha:1.0f tag:buttonTag+1000];
        }
        else if (button.subbuttonType==kPrivateLifeSubobjectButton)
        {
           [self createImageViewForSubobjectiveType:kPrivateLifeSubobjectButton withAnchorPoint:CGPointMake(0.0f, 0.5f) rotationTransformAnge:(coordinate.degreeValue)*PI/180.0f+PI center:button.center alpha:1.0f tag:buttonTag+1000];
        }
        
    }
}


-(void)createImageViewForSubobjectiveType:(subButtonTypes)buttonType withAnchorPoint:(CGPoint)anchorPoint rotationTransformAnge:(CGFloat)angle center:(CGPoint)center alpha:(CGFloat)alpha tag:(unsigned int) tag
{
    UIImage *image;
    switch (buttonType) {
        case kHealthSubobjectButton:
            image=[UIImage imageNamed:@"hb.png"];
            break;
        case kFinanceSubobjectButton:
            image=[UIImage imageNamed:@"fb.png"];
            break;
        case kPrivateLifeSubobjectButton:
            image=[UIImage imageNamed:@"pb.png"];
            break;
        default:
            break;
    }
    UIImageView *imgv=[[UIImageView alloc]initWithImage:image];
    imgv.transform=CGAffineTransformMakeRotation(angle);
    imgv.tag=tag;
    [self setAnchorPoint:anchorPoint forView:imgv];
    imgv.center=center;
    imgv.alpha=alpha;
    [self.arrayOfCreatedSubobjectives addObject:imgv];
    [self.view2 insertSubview:imgv belowSubview:self.circle];
}

-(void)moveButton:(ObjectiveButtonClass*)button indexOfButtonInArrayOfCreatedButtons:(NSUInteger)indexOfObject increaseNumberOfPosition:(short int)step delay:(CGFloat) delay duration:(CGFloat)duration angle:(CGFloat)angleRotation tap:(BOOL)isButtonTapped
{
    //---------
    //decrease/increase number of position
    //---------
    button.numberOfPositionOnTheCircle+=step;
    //---------
    //checking if future position lays on 0-6 position
    //---------
    if ((button.numberOfPositionOnTheCircle<=6)&&(button.numberOfPositionOnTheCircle>=0))
    {
        if (button.isHidden)
        {
            [button setHidden:NO];
            [self.view2 addSubview:button];
            
        }
        
        NSLog(@"Creating interpolation points for moving buttons with circle trajectory");
        NSArray *arrayOfCoordinates;
        CGPoint startPoint;
        if (step<0)
        {
            
            arrayOfCoordinates=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle-step]).degreeValue withDeltaBetweenButtons:5 assignTypeOfButton:kButtonDefault];
            
            startPoint = ((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle-step]).pointToDrawButton;
            
        }
        else
        {
            if (button.numberOfPositionOnTheCircle==0)
            {
                arrayOfCoordinates=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:0]).degreeValue toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue+1.0f withDeltaBetweenButtons:4 assignTypeOfButton:kButtonDefault];
                startPoint = CGPointMake(-100.0f, 748.0f);
                
            }
            else if (button.numberOfPositionOnTheCircle==1)
            {
                
                if (step==1)
                {
                    arrayOfCoordinates=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:0]).degreeValue toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue+2.0f withDeltaBetweenButtons:4 assignTypeOfButton:kButtonDefault];
                    startPoint = ((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:0]).pointToDrawButton;
                }
                else if (step==2)
                {
                    arrayOfCoordinates=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:0]).degreeValue-10 toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue+2.0f withDeltaBetweenButtons:4 assignTypeOfButton:kButtonDefault];
                    startPoint = CGPointMake(-200, 1000.0f);
                }
                
                
            }
            else
            {
                arrayOfCoordinates=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle-step]).degreeValue toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue+2.0f withDeltaBetweenButtons:4 assignTypeOfButton:kButtonDefault];
                startPoint = ((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle-step]).pointToDrawButton;
                
            }
        }
        
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:[arrayOfCoordinates count]];
        
        
        NSValue *leftValue = [NSValue valueWithCGPoint:startPoint];
        
        for (CoordinatesController *coordinate in arrayOfCoordinates)
        {
            [self convertViewtoMainMapCoordinates:coordinate fromCircle:self.circle];
            //------
            //step < 0 means left direction, sorting values
            //------
            if (step<0)
            {
                [values insertObject:[NSValue valueWithCGPoint:coordinate.pointToDrawButton] atIndex:0];
            }
            else
            {
                [values addObject:[NSValue valueWithCGPoint:coordinate.pointToDrawButton]];
            }
        }
        [values insertObject:leftValue atIndex:0];
        
        
        CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        theAnimation.values = values;
        theAnimation.duration = duration;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        theAnimation.calculationMode = kCAAnimationLinear;
        //last point
        [self convertViewtoMainMapCoordinates:[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle] fromCircle:self.circle];
        [button.layer setValue:[NSValue valueWithCGPoint:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).pointToDrawButton] forKeyPath:theAnimation.keyPath];
        theAnimation.beginTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil] + delay;
        [button.layer addAnimation:theAnimation forKey:@"move"];
        
        
        [UIView animateWithDuration:duration animations:
         ^{
             button.transform=CGAffineTransformRotate(button.transform, step*angleRotation*PI/180.0f);
         }];
        if (button.numberOfPositionOnTheCircle==3)
        {
            [self showAllSubobjectivesOfSelectedButton:button];
            if (self.isDetailViewOn)
            {
                [self.mapDetailsViewController setupDetailView:button createNewButton:NO showDetailsOfExisted:YES];
            }
            
            else
                
            {
                if (isButtonTapped)
                {
                    [self.mapDetailsViewController setupDetailView:button createNewButton:NO showDetailsOfExisted:YES];
                    
                    
                    __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
                    self.tapGestureRecognizer.enabled=YES;
                    self.isDetailViewOn=YES;
                    [weakParent setNewFrames:nil];
                }
                
            }
            
            
        }
        
    }
    //number of position on the circle do not equal 1-6
    else
    {
        if (step<0)
        {
            if (button.isHidden) {
                button.transform=CGAffineTransformRotate(button.transform, step*angleRotation*PI/180.0f);
            }
            else
            {
                [UIView animateWithDuration:0.2f animations:^{
                    button.center=CGPointMake(-100.0f, 748.0f);
                    
                } completion:^(BOOL finished)
                 {
                     button.transform=CGAffineTransformRotate(button.transform, step*angleRotation*PI/180.0f);
                     
                     [button removeFromSuperview];
                     [button setHidden:YES];
                     
                 }];
            }
        }
        else
        {
            if (button.isHidden) {
                button.transform=CGAffineTransformRotate(button.transform, step*angleRotation*PI/180.0f);
            }
            else
            {
                [UIView animateWithDuration:0.2f animations:
                 ^{
                     button.center=CGPointMake(1050.0f, 748.0f);
                     
                 } completion:^(BOOL finished)
                 {
                     button.transform=CGAffineTransformRotate(button.transform, step*angleRotation*PI/180.0f);
                     if (!button.isHidden)
                     {
                         [button removeFromSuperview];
                         [button setHidden:YES];
                         
                     }
                 }];
            }
            
            
        }
    }
    
}


-(void)bounceButton:(ObjectiveButtonClass*)button direction:(short int) step
{
    
    if (button.numberOfPositionOnTheCircle==3)
    {
        NSArray *arrayOfCoordinatesFrom=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue-2.0f toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue withDeltaBetweenButtons:5 assignTypeOfButton:kButtonDefault];
        //+
        NSArray *arrayOfCoordinatesBounceToNotSorted=[self.circle createArrayOfPointsWithDeltaStep:1 fromAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue toAngle:((CoordinatesController*)[self.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:button.numberOfPositionOnTheCircle]).degreeValue+2.0f withDeltaBetweenButtons:1 assignTypeOfButton:kButtonDefault];
        NSMutableArray *arrayOfCoordinatesBounceToSorted = [NSMutableArray arrayWithCapacity:[arrayOfCoordinatesBounceToNotSorted count]];
        for (CoordinatesController *coordinate in arrayOfCoordinatesBounceToNotSorted)
        {
            [arrayOfCoordinatesBounceToSorted insertObject:coordinate atIndex:0];
        }
        
        
        unsigned int totalCountOfPoints = [arrayOfCoordinatesFrom count]+[arrayOfCoordinatesBounceToSorted count];
        unsigned int indexTo=0;
        unsigned int indexFrom = 0;
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:totalCountOfPoints];
        for (int i=0; i<totalCountOfPoints; i++)
        {
            if (step<0)
            {
                if (i%2==0)
                {
                    [self convertViewtoMainMapCoordinates:[arrayOfCoordinatesFrom objectAtIndex:indexFrom] fromCircle:self.circle];
                    [values addObject:[NSValue valueWithCGPoint:((CoordinatesController*)[arrayOfCoordinatesFrom objectAtIndex:indexFrom]).pointToDrawButton]];;
                    indexFrom++;
                }
                else
                {
                    [self convertViewtoMainMapCoordinates:[arrayOfCoordinatesBounceToSorted objectAtIndex:indexTo] fromCircle:self.circle];
                    [values addObject:[NSValue valueWithCGPoint:((CoordinatesController*)[arrayOfCoordinatesBounceToSorted objectAtIndex:indexTo]).pointToDrawButton]];
                    indexTo++;
                }
            }
            else if (step >0)
            {
                
                if (i%2!=0)
                    
                {
                    [self convertViewtoMainMapCoordinates:[arrayOfCoordinatesFrom objectAtIndex:indexFrom] fromCircle:self.circle];
                    [values addObject:[NSValue valueWithCGPoint:((CoordinatesController*)[arrayOfCoordinatesFrom objectAtIndex:indexFrom]).pointToDrawButton]];
                    
                    indexFrom++;
                    
                }
                
                else
                {
                    [self convertViewtoMainMapCoordinates:[arrayOfCoordinatesBounceToSorted objectAtIndex:indexTo] fromCircle:self.circle];
                    [values addObject:[NSValue valueWithCGPoint:((CoordinatesController*)[arrayOfCoordinatesBounceToSorted objectAtIndex:indexTo]).pointToDrawButton]];
                    indexTo++;
                }
            }
            
            
        }
        if (step >0)
        {
            [self convertViewtoMainMapCoordinates:[arrayOfCoordinatesBounceToNotSorted objectAtIndex:0] fromCircle:self.circle];
            
            [values addObject:[NSValue valueWithCGPoint:((CoordinatesController*)[arrayOfCoordinatesBounceToNotSorted objectAtIndex:0]).pointToDrawButton]];
        }
        CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        theAnimation.values = values;
        theAnimation.duration = 0.45f;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        theAnimation.calculationMode = kCAAnimationLinear;
        [button.layer addAnimation:theAnimation forKey:@"bounceButton"];
        
    }
    
}

-(IBAction)addButtonItem:(id)sender
{
    NSLog(@"User wants to add new button item");
    if (!self.isDetailViewOn)
    {
        NSLog(@"Moving one step left direction buttons <=3");
        [self setupButtonMovementWithStep:0 indexOfObject:0 delay:0.0f duration:0.4f angle:19.0f tapObjective:NO tapCreateNewObjective:YES tapCreateNewObjectiveCancelled:NO];
        
        __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
        id bufferButton;
        if (self.selectedButton.subbuttonType==kFinanceSubButtonType)
        {
            FinanceButton *financeOnCircle=[[FinanceButton alloc]init];
            bufferButton=financeOnCircle;
        }
        else if (self.selectedButton.subbuttonType==kHealthSubButtonType)
        {
            HealthButton *healthOnCircle=[[HealthButton alloc]init];
            bufferButton=healthOnCircle;
        }
        else if (self.selectedButton.subbuttonType==kPrivateLifeSubButtonType)
        {
            pLifeButton *privateLifeOnCircle=[[pLifeButton alloc]init];
            bufferButton=privateLifeOnCircle;
            
        }
        if (((ObjectiveButtonClass*)bufferButton).subbuttonType==kFinanceSubButtonType)
        {
            ((ObjectiveButtonClass*)bufferButton).transform=CGAffineTransformRotate(((ObjectiveButtonClass*)bufferButton).transform,-12.0f*PI/180.0f);
        }
        
        
        ((ObjectiveButtonClass*)bufferButton).center=CGPointMake(self.health.center.x+self.containerForMainCommas.frame.origin.x,self.health.center.y+self.containerForMainCommas.frame.origin.y);
        ((ObjectiveButtonClass*)bufferButton).tag = kNewButtonToCreate;
        
        
        [((ObjectiveButtonClass*)bufferButton) sizeToFit];
        [((ObjectiveButtonClass*)bufferButton) setAlpha:0.3f];
        [self.view2 addSubview:bufferButton];
        __weak __block MainMapZoomInViewController * weakSelf = self;
        [UIView animateWithDuration:0.7f animations:^{
            ((ObjectiveButtonClass*)bufferButton).center=((CoordinatesController*)[weakSelf.circle.arraySubobjectivesCoordinatesToDrawButton objectAtIndex:3]).pointToDrawButton;
            ((ObjectiveButtonClass*)bufferButton).alpha=0.4f;} completion:^(BOOL finished){NSLog(@"button prototype movement animation complete");}];
        [weakSelf showAllSubobjectivesOfSelectedButton:bufferButton];
        [weakParent setNewFrames:nil];
        self.tapGestureRecognizer.enabled=YES;
        self.isDetailViewOn=YES;
        if (!self.mapDetailsViewController.delegate)
        {
            self.mapDetailsViewController.delegate=self;
        }
        [[self.mapDetailsViewController.view viewWithTag:kViewSubobjectiveNames]removeFromSuperview];
        self.mapDetailsViewController.datePicker.userInteractionEnabled = YES;
        self.mapDetailsViewController.buttonTypeToCreate=kNewButtonToCreate;
        self.mapDetailsViewController.date = self.selectedButton.date;
        NSDate *startDate = [self setupWithComponentsDate:self.selectedButton.date hour:0 minute:0 second:10];
        NSDate *endDate = [self setupWithComponentsDate:self.selectedButton.date hour:23 minute:59 second:0];
        self.mapDetailsViewController.datePicker.minimumDate = startDate;
        self.mapDetailsViewController.datePicker.maximumDate=endDate;
        self.mapDetailsViewController.buttonToCreateSubObjective.alpha = .0f;
        self.mapDetailsViewController.numberOfSubojectives.alpha=0.0f;
        self.mapDetailsViewController.circle1.alpha = 1.0f;
        
    }
    
}

-(void)buttonObjectiveTapped:(ObjectiveButtonClass*)button
{
    NSLog(@"button objective tapped.");
    short int numberOnTheCircle = button.numberOfPositionOnTheCircle;
    self.mapDetailsViewController.buttonFromZoomIn = button;
    if ((numberOnTheCircle<3)&&(numberOnTheCircle>0))
    {
        [self setupButtonMovementWithStep:3-numberOnTheCircle indexOfObject:0 delay:.0f duration:0.4f angle:19.0f tapObjective:YES tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
        
    }
    else if ((numberOnTheCircle>3)&&(numberOnTheCircle<6))
    {
        NSUInteger indexOfObject;
        if ([self.arrayOfCreatedButtons count]==1)
        {
            indexOfObject=0;
        }
        else if ([self.arrayOfCreatedButtons count]==2)
        {
            indexOfObject=1;
        }
        else
        {
            indexOfObject=[self.arrayOfCreatedButtons count]-2;
        }
        
        [self setupButtonMovementWithStep:3-numberOnTheCircle indexOfObject:indexOfObject delay:.0f duration:0.4f angle:19.0f tapObjective:YES tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
    }
    else if (numberOnTheCircle==3)
    {
        if (!self.isDetailViewOn)
        {
            [self.mapDetailsViewController setupDetailView:button createNewButton:NO showDetailsOfExisted:YES];
            __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
            self.tapGestureRecognizer.enabled=YES;
            self.isDetailViewOn=YES;
            [weakParent setNewFrames:nil];
            
        }
        
    }
}

#pragma mark - Gesture Recognizer's Methods
-(IBAction)pinchGestureUpDirection:(id)sender
{
    if (!self.isDetailViewOn)
    {
        NSLog(@"Gesture Up Direction recognized");
        NSOperationQueue *queue=[NSOperationQueue new];
        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(updateToDoList) object:nil];
        
        [queue addOperation:operation];
        BOOL isLandscape=UIDeviceOrientationIsLandscape(self.interfaceOrientation);
        CGPoint centerOfView;
        if (isLandscape)
        {
            centerOfView=CGPointMake(838.0f/2.0f, 753.0f/2.0f);
        }
        
        self.finance.alpha=1.0f;
        self.finance.selected=NO;
        self.health.alpha=1.0f;
        self.health.selected=NO;
        self.privateLife.alpha=1.0f;
        self.privateLife.selected=NO;
        
        __weak __block CombinedViewController * weakParent=(CombinedViewController*)self.parentViewController;
        
        [weakParent backToMainMapViewControllerForDateFromZoomInViewController:self.dateOfMainMapView];
        
        [self runDrawCircleAnimationWithRadius:100.0f center:centerOfView duration:0.55f width:10.0f alpha:0.35f];
        
        [self runDrawCircleAnimationWithRadius:185.0f center:centerOfView duration:0.55f width:50.0f alpha:0.35f];
    }
}

-(IBAction)swipeGestureRightDirection:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Swipe gesture Right Direction recognized.");
    [self setupButtonMovementWithStep:1 indexOfObject:0 delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
}


-(IBAction)swipeGestureLeftDirection:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    NSLog(@"Swipe gesture Left Direction recognized.");
    NSUInteger indexOfObject;
    if ([self.arrayOfCreatedButtons count]==1)
    {
        indexOfObject=0;
    }
    else if ([self.arrayOfCreatedButtons count]==2)
    {
        indexOfObject=1;
    }
    else
    {
        indexOfObject=[self.arrayOfCreatedButtons count]-2;
    }
   
    [self setupButtonMovementWithStep:-1 indexOfObject:indexOfObject delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
}
-(IBAction)tapGestureRemoveDetailView:(id)sender;
{
    NSLog(@"tap gesture recognized.");
    if (self.isDetailViewOn)
    {
        __weak __block CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
        self.tapGestureRecognizer.enabled=NO;
        self.isDetailViewOn=NO;
        [weakParent dissmissMapDetailViewController:nil];
        if ([[self view2]viewWithTag:kNewButtonToCreate])
        {
            [UIView animateWithDuration:0.5f animations:^{
                [[self view2]viewWithTag:kNewButtonToCreate].alpha=0.0f;
            } completion:^(BOOL finished){
                [[[self view2]viewWithTag:kNewButtonToCreate] removeFromSuperview];
            }];
            [self setupButtonMovementWithStep:0 indexOfObject:0 delay:0.0f duration:0.4f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:YES ];
        }
       
        
    }
}
-(IBAction)handleTap:(id)sender
{
    NSLog(@"handleTap method recognized");
    
    //NSLog(@"Swipe gesture Left Direction recognized.");
    UIPanGestureRecognizer *grecognizer = (UIPanGestureRecognizer*)sender;
    
    CGPoint translation = [grecognizer translationInView:self.view];
    CGPoint vel = [grecognizer velocityInView:self.view];
    if (grecognizer.state==UIGestureRecognizerStateEnded) {
        if (((vel.y<-500.0f)&&(vel.x>-250.0f)&&(vel.x<250.0f))||(translation.y<-100.0f)) {
            if (!self.isDetailViewOn)
            {
                NSLog(@"Gesture Up Direction recognized");
                NSOperationQueue *queue=[NSOperationQueue new];
                NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(updateToDoList) object:nil];
                
                [queue addOperation:operation];
                BOOL isLandscape=UIDeviceOrientationIsLandscape(self.interfaceOrientation);
                CGPoint centerOfView;
                if (isLandscape)
                {
                    centerOfView=CGPointMake(838.0f/2.0f, 753.0f/2.0f);
                }
                
                self.finance.alpha=1.0f;
                self.finance.selected=NO;
                self.health.alpha=1.0f;
                self.health.selected=NO;
                self.privateLife.alpha=1.0f;
                self.privateLife.selected=NO;
                
                __weak __block CombinedViewController * weakParent=(CombinedViewController*)self.parentViewController;
                
                [weakParent backToMainMapViewControllerForDateFromZoomInViewController:self.dateOfMainMapView];
                
                [self runDrawCircleAnimationWithRadius:100.0f center:centerOfView duration:0.55f width:10.0f alpha:0.35f];
                
                [self runDrawCircleAnimationWithRadius:185.0f center:centerOfView duration:0.55f width:50.0f alpha:0.35f];
            }

        }
        else
        if (vel.x>100.0f)
        {
            NSLog(@"%f",translation.x);
            NSLog(@"Right Direction");
            if ([self.arrayOfCreatedButtons count]<6)
            {
                 [self setupButtonMovementWithStep:1 indexOfObject:0 delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
            }
            else
            {
                if (vel.x<1300.0f)
                {
                    [self setupButtonMovementWithStep:1 indexOfObject:0 delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
                }
                else
                {
                    if (((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:0]).numberOfPositionOnTheCircle+2!=4)
                    {
                    [self setupButtonMovementWithStep:2 indexOfObject:0 delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
                    }
                    else
                    {
                        [self setupButtonMovementWithStep:1 indexOfObject:0 delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
                    }
 
                    
                }
            }
           
            
            
            
        }
        else if (vel.x<-100)
        {
            NSLog(@"translation %f",translation.x);
            NSLog(@"Left Direction");
            NSUInteger indexOfObject;
            if ([self.arrayOfCreatedButtons count]==1)
            {
                indexOfObject=0;
            }
            else if ([self.arrayOfCreatedButtons count]==2)
            {
                indexOfObject=1;
            }
            else
            {
                indexOfObject=[self.arrayOfCreatedButtons count]-2;
            }
            
            if (vel.x>-1300.0f)
            {
                [self setupButtonMovementWithStep:-1 indexOfObject:indexOfObject delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
            }
            else
            {
                if (((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:indexOfObject]).numberOfPositionOnTheCircle-2!=2) {
                    [self setupButtonMovementWithStep:-2 indexOfObject:indexOfObject delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
                }
                else
                {
                [self setupButtonMovementWithStep:-1 indexOfObject:indexOfObject delay:0.0f duration:0.35f angle:19.0f tapObjective:NO tapCreateNewObjective:NO tapCreateNewObjectiveCancelled:NO];
                }
            }
            
        }

    }
        //[grecognizer setTranslation:CGPointMake(0.0f, 0.0f) inView:grecognizer.view];
}



-(void)setupButtonMovementWithStep:(short int)step indexOfObject:(NSUInteger)indexOfObject delay:(CGFloat) delay duration:(CGFloat)duration angle:(CGFloat)angleRotation tapObjective:(BOOL)isButtonTapped tapCreateNewObjective:(BOOL)needToCreateNewObjective tapCreateNewObjectiveCancelled:(BOOL)createCancelled

{
    //checking if need to scroll
    //enumeration of created buttons are following:
    //self.selectedButton - last object
    //the other part of created buttons' indexes [0;[count-2]]
    if (((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:indexOfObject]).numberOfPositionOnTheCircle!=3)
    {
        for (ObjectiveButtonClass *button in self.arrayOfCreatedButtons)
        {
            if (needToCreateNewObjective)
            {
                //moving only buttons which have position <=3
                if (button.numberOfPositionOnTheCircle<=3)
                {
                    [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:-1 delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
                }
               
            }
            else if (createCancelled)
            {
                if (((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:0]).numberOfPositionOnTheCircle>=3)
                {
                    if (button.numberOfPositionOnTheCircle>=3)
                    {
                    [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:-1 delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
                    }
                }
                else
                {
                if (button.numberOfPositionOnTheCircle<=3)
                {
 
                [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:1 delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
                    
                }
                }
            }
            else
            {
            //no need to create new objective, moving all buttons
            [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:step delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
            }
        }
 
    }
    else
    {
        //not scroll
        if (needToCreateNewObjective)
        {
            for (ObjectiveButtonClass *button in self.arrayOfCreatedButtons)
            {
                if (button.numberOfPositionOnTheCircle>=3)
                {
                    [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:1 delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
                }
            }
        }
       /* else if (createCancelled)
        {
            for (ObjectiveButtonClass *button in self.arrayOfCreatedButtons)
            {
                if (button.numberOfPositionOnTheCircle>=3)
                {
                    [self moveButton:button indexOfButtonInArrayOfCreatedButtons:indexOfObject increaseNumberOfPosition:-1 delay:delay duration:duration angle:angleRotation tap:isButtonTapped];
                }
            }

        }*/
        else
        {
            //bounce
        NSLog(@"there is no place to scroll, last button's subobjectives in array are shown. Staring bouncing.");
        [self bounceButton:[self.arrayOfCreatedButtons objectAtIndex:indexOfObject]  direction:step];
        }
    }

}


-(void)runDrawCircleAnimationWithRadius:(CGFloat)radius center:(CGPoint)center duration:(CGFloat)duration width:(CGFloat)width alpha:(CGFloat)alpha
{
    // Set up the shape of the circle

    CAShapeLayer *circleAnimation = [CAShapeLayer layer];
    // Make a circular shape
    circleAnimation.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius-1.0f, 2.0*radius)
                                                      cornerRadius:radius].CGPath;
    // Center the shape in self.view
    circleAnimation.position = CGPointMake(center.x-radius, center.y-radius) ;
    
    // Configure the apperence of the circle
    circleAnimation.fillColor = [UIColor clearColor].CGColor;
    circleAnimation.strokeColor = [UIColor colorWithRed:23.0f/255.0f green:12.0f/255.0f blue:0.0f alpha:alpha].CGColor;
    circleAnimation.lineWidth = width;
    
    // Add to parent layer
    [self.view2.layer insertSublayer:circleAnimation below:self.containerForMainCommas.layer];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = duration; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circleAnimation addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

#pragma mark - Map Details Delegate methods

-(void)createButton:(ButtonTypes)buttonType atCircleWithDate:(NSDate *)date
{
    NSLog(@"New button Zoom In creating.");
     __weak ObjectiveButtonClass *button=(ObjectiveButtonClass*)[self.view2 viewWithTag:buttonType];
     button.alpha=1.0f;
     button.numberOfPositionOnTheCircle=3;
    button.tag=buttonTagValue;
    if ([self.arrayOfCreatedButtons count]==1)
    {
        [self.arrayOfCreatedButtons insertObject:button atIndex:0];
    }
    else if  ([self.arrayOfCreatedButtons count]==2)
    {
        [self.arrayOfCreatedButtons insertObject:button atIndex:1];
    }
    else
    {
        if(((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:([self.arrayOfCreatedButtons count]-2)]).numberOfPositionOnTheCircle==2)
        {
            [self.arrayOfCreatedButtons insertObject:button atIndex:([self.arrayOfCreatedButtons count]-1)];
        }
        else if (((ObjectiveButtonClass*)[self.arrayOfCreatedButtons objectAtIndex:0]).numberOfPositionOnTheCircle==4)
        {
        [self.arrayOfCreatedButtons insertObject:button atIndex:0];
        }
        else
        {
            [self.arrayOfCreatedButtons insertObject:button atIndex:([self.arrayOfCreatedButtons count]-2)];
        }
    }
    
    NSString *name,*type;
    if (button.subbuttonType==kFinanceSubButtonType)
    {
        name=[NSString stringWithFormat:@"FZoomIn%d",button.tag-5000];
        type=@"Finance";
    }
    else if (button.subbuttonType==kHealthSubButtonType)
    {
        name=[NSString stringWithFormat:@"HZoomIn%d",button.tag-5000];
        type=@"Health";
    }
    else if (button.subbuttonType==kPrivateLifeSubButtonType)
    {
        name=[NSString stringWithFormat:@"PZoomIn%d",button.tag-5000];
        type=@"Private Life";
    }
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(-75.0, -150.0, 0.0, 0.0);
    button.titleEdgeInsets = titleInsets;
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.textColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(buttonObjectiveTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];

    AppDelegate *pAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fugitive" inManagedObjectContext:[pAppDelegate managedObjectContext]];
    
    Fugitive *toDoAssignment = [[Fugitive alloc] initWithEntity:entity insertIntoManagedObjectContext:[pAppDelegate managedObjectContext]];
    
    toDoAssignment.type=type;
    toDoAssignment.date = date;
    toDoAssignment.desc=@"something that needs to fill";
    toDoAssignment.isEnchiridion = [NSNumber numberWithBool:YES];
    toDoAssignment.isShown=[NSNumber numberWithBool:NO];
    toDoAssignment.name=name;
    toDoAssignment.bounty = [NSDecimalNumber decimalNumberWithDecimal:
                             [[NSNumber numberWithFloat:2.75f] decimalValue]];
    toDoAssignment.fugitiveID=[NSNumber numberWithInt:11];
    toDoAssignment.numberOfSubobj=[NSNumber numberWithInt:0];
    toDoAssignment.isReached = [NSNumber numberWithBool:NO];
    
    button.toDoAssignment=toDoAssignment;
    
    __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
    [weakParent dissmissMapDetailViewController:nil];
    self.isDetailViewOn=NO;
    buttonTagValue++;
}

-(void)updateButtonSubobjective:(ObjectiveButtonClass *)button
{
    [self showAllSubobjectivesOfSelectedButton:button];
}

-(void)updateToDoList
{
    __weak CombinedViewController *weakParent = (CombinedViewController*)self.parentViewController;
    [weakParent requestImplement:nil];
}
@end
