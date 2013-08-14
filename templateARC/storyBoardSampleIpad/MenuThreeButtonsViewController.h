//
//  MenuThreeButtonsViewController.h
//  templateARC
//
//  Created by Mac Owner on 6/15/13.
//
//

#import <UIKit/UIKit.h>

@interface MenuThreeButtonsViewController : UIViewController

@property (strong, nonatomic) UIButton *buttonMainMapZoomOut;
@property (assign,nonatomic) CGPoint homePointForButtonMainMapZoomOut;
@property (assign,nonatomic) BOOL isButtonMainMapZoomOutDragged;
@property (strong,nonatomic) NSDate * dateMainMapZoomOutView;

@property (weak,nonatomic) IBOutlet UIImageView * imageViewFractal;

-(void)buttonMainMapZoomOutTapped:(id)sender;
-(void)setupButtonMainMapZoomOutTransformScale:(BOOL)scaleEnabled image:(UIImage*)image 
;

@end
