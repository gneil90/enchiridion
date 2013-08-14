//
//  MainMapZoomInViewController.h
//  templateARC
//
//  Created by Mac Owner on 5/24/13.
//
//

#import <UIKit/UIKit.h>
@class CircleView;
@class ObjectiveButtonClass;
@class MapDetailsViewController;
#import "Protocols.h"

@interface MainMapZoomInViewController : UIViewController
<MapDetailViewControllerDelegate>

@property (weak,nonatomic) IBOutlet UIButton *finance;
@property (weak,nonatomic) IBOutlet UIButton *health;
@property (weak,nonatomic) IBOutlet UIButton *privateLife;

@property (weak,nonatomic) IBOutlet UIView *containerForMainCommas;
@property (weak,nonatomic) IBOutlet UIImageView * background;
@property (weak,nonatomic) IBOutlet UIView *view2;

@property (strong,nonatomic) CircleView * circle;

@property (strong,nonatomic) ObjectiveButtonClass *selectedButton;

@property (strong,nonatomic) NSDate * dateOfMainMapView;

@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer * swipeGestureRecognizer;
@property  (weak,nonatomic) IBOutlet UISwipeGestureRecognizer * swipeRightGestureRecognizer;
@property (weak,nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (weak,nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak,nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (weak,nonatomic) MapDetailsViewController *mapDetailsViewController;

@property (assign,nonatomic) BOOL isDetailViewOn;

-(IBAction)pinchGestureUpDirection:(id)sender;
-(IBAction)swipeGestureRightDirection:(id)sender;
-(IBAction)swipeGestureLeftDirection:(UISwipeGestureRecognizer*)gestureRecognizer;
-(IBAction)tapGestureRemoveDetailView:(id)sender;
-(IBAction)handleTap:(id)sender;

-(void)runDrawCircleAnimationWithRadius:(CGFloat)radius center:(CGPoint)center duration:(CGFloat)duration width:(CGFloat)width alpha:(CGFloat)alpha;


@end
