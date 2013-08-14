//
//  MainMapZoomOutViewController.h
//  templateARC
//
//  Created by Mac Owner on 3/13/13.
//
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@class CircleView;
@class MainMapViewController;

@interface MainMapZoomOutViewController : UIViewController
 <UIScrollViewDelegate>
{
    IBOutlet UIImageView* mainCommasZoomOut;
}

-(void)backToSecondView:(id)sender;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UIView *view2;

@property (strong,nonatomic) NSMutableArray *arrayOfTagsHealth;
@property (strong,nonatomic) NSMutableArray *arrayOfTagsFinance;
@property (strong,nonatomic) NSMutableArray *arrayOfTagsPrivateLife;

@property (strong,nonatomic) UIImageView *imageViewScreenShot;


@property (weak,nonatomic) IBOutlet UISwipeGestureRecognizer *swipeToLeftGestureRecognizer;

@property (weak,nonatomic) IBOutlet UISwipeGestureRecognizer *swipeToRightGestureRecognizer;

@property (assign,nonatomic) BOOL zoomEnabled;



@property (strong, nonatomic) NSDate *date;

@property (weak,nonatomic) IBOutlet UILabel *month;
@property (weak,nonatomic)  MainMapViewController *mainMapViewController;

-(IBAction)swipeLeftToShowRunes:(id)sender;
-(IBAction)swipeRightToRemoveRunes:(id)sender;

-(void)setFractalImageView:(UIImage*)image;
- (void)centerScrollViewContents:(UIView*)yourView;

@end
