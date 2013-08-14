//
//  ViewController.h
//  storyBoardSampleIpad
//
//  Created by Mac Owner on 2/9/13.
//
//

#import <UIKit/UIKit.h>
@class MapDetailsViewController;
@class MainMapViewController;
@class MenuViewController;
@class MainMapZoomOutViewController;
@class MainMapZoomInViewController;
@class Animations;
@class RuneButton;
@class MenuThreeButtonsViewController;
@interface CombinedViewController : UIViewController

@property (strong,nonatomic) MainMapViewController *mainMapViewController;
@property (strong,nonatomic) MenuViewController *menuViewController;
@property (strong,nonatomic) MapDetailsViewController *mapDetailsViewController;
@property (strong,nonatomic) MainMapZoomInViewController *mainMapZoomInViewController;
@property (strong,nonatomic) MenuThreeButtonsViewController *menuThreeButtonsViewController;

@property (weak, nonatomic) IBOutlet UIView *containerViewMap;
@property (weak, nonatomic) IBOutlet UIView *containerViewMenu;

@property (strong,nonatomic) NSMutableArray *toDoList;

//images for buttons
//background
@property (strong,nonatomic,readonly) UIImage *backgroundMainView;
@property (strong,nonatomic) UIImage *backgroundZoomView;
@property (strong,nonatomic) UIImage *fractalPersonality;



//mainView:
@property (strong,nonatomic,readonly) UIImage *healthMainViewImage;
@property (strong,nonatomic,readonly) UIImage *privateLifeMainViewImage;
@property (strong,nonatomic,readonly) UIImage *financeMainViewImage;


//zoomOutView:
@property (strong,nonatomic,readonly) UIImage *healthZoomOutImage;
@property (strong,nonatomic,readonly) UIImage *privateLifeZoomOutImage;
@property (strong,nonatomic,readonly) UIImage *financeZoomOutImage;
@property (strong,nonatomic,readonly) UIImage *screenShotZoomOutImage;

@property (strong,nonatomic) UINavigationController *navController;

@property (strong,nonatomic,readonly) UIImage *circleMonthImage;

@property (strong,nonatomic) NSMutableArray *arrayOfMonthCircles;


//transition VC methods
-(void)transitionToZoomInViewControllerWithCirclePosition:(UIView*)circle;
-(void)pushViewControllers;
-(void)backToMainMapViewController:(RuneButton*)runeButton;
-(void)backToMainMapViewControllerForDateFromZoomInViewController:(NSDate*)dateOfFirstCircle;
-(void)switchViewControllerFromZoomOutMainMapToMenuThreeButtons:(UIImageView*)backgroundImageView;
-(void)backToMainMapZoomOutViewControllerFromMenuThreeButtons:(UIImageView*)backgroundImageView;

-(void)setNewFrames:(id)sender;
-(void)dissmissMapDetailViewController:(id)sender;
-(void)createAnimationOnAnotherThread:(Animations*)animation;


-(void)requestImplement:(NSDate*)date;
+ (UIColor *)color;



@end
