//
//  MainMapViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "MapDetailsViewController.h"
#import "Animations.h"
#import "Protocols.h"

@class CircleView;
@class CoordinatesController;
@class OneFingerRotateGestureRecognizer;

@interface MainMapViewController : UIViewController
<MapDetailViewControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIButton *health;
    IBOutlet UIButton *_finance;
    IBOutlet UIButton *privateLife;
    IBOutlet UIImageView *mainCommas;
    IBOutlet UIView *centerSubview;
    
    BOOL _isDetailViewOn;
    BOOL _touchSwallowRotationEnabled;
    //flags for converting coordinates
    

    
}
@property (nonatomic,assign) BOOL showAssignmentsWithDelay;
@property (nonatomic,assign) CGRect mapDetailFrame;

//gesture recognizers
@property (nonatomic,weak) IBOutlet UIImageView *background;
@property (nonatomic,weak) IBOutlet UIView *view2;
@property (nonatomic, weak) IBOutlet UISwipeGestureRecognizer
*swipeGestureRecognizer;

@property (nonatomic,weak) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@property (nonatomic,strong) OneFingerRotateGestureRecognizer *rotateGestureRecognizer;

@property (weak, nonatomic) id delegate;

@property (nonatomic,assign) BOOL isDetailViewOn;
 
@property (nonatomic,strong) NSDate *date;

@property (strong,nonatomic) UIButton *finance;


@property (weak,nonatomic) MapDetailsViewController *mapDetailsViewController;
@property (strong,nonatomic) CircleView *graphView;
@property (strong,nonatomic) CircleView *graphView2;
@property (strong,nonatomic) NSMutableArray *coordinates;




-(void)showDetailView:(id)sender;
-(void)reDrawNewButton:(UIButton*)button;
-(void)enableAllButtons;
-(void)convertViewtoMainMapCoordinates:(CoordinatesController*)coordinate fromCircle:(CircleView*)circle;
-(void)showAllAssignments;

-(IBAction)swipeHandle:(id)sender;

-(IBAction)zoomOutPinch:(UIPinchGestureRecognizer*)sender;
-(void) runSpinAnimationWithDuration:(CGFloat) duration forView:(UIView*)myView;
-(void)disableAllButtonsExcept:(UIButton*)button;



//date class public methods

-(NSDate*)getNextDayOf:(NSDate*)yourDate;
+(NSInteger)getDayIntegerFromDate:(NSDate*)date;
+(NSInteger)getMonthIntegerFromDate:(NSDate*)date;
+(NSInteger)getYearIntegerFromDate:(NSDate*)date;

+(NSDate*)setDateByComponentDay:(NSInteger)day byMonth:(NSInteger)month andByYear:(NSInteger)year;

@end
