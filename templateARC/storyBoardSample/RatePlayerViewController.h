//
//  MyClass.h
//  templateARC
//
//  Created by Mac Owner on 2/11/13.
//
//

@class RatePlayerViewController;
@class Player;

@protocol RatePlayerViewControllerDelegate <NSObject>
- (void)ratePlayerViewController:
(RatePlayerViewController *)controller
          didPickRatingForPlayer:(Player *)player;
@end

@interface RatePlayerViewController : UIViewController
@property (nonatomic, weak) id
<RatePlayerViewControllerDelegate> delegate;

@property (nonatomic,weak) IBOutlet UIButton *star1;
@property (nonatomic,weak) IBOutlet UIButton *star2;
@property (nonatomic,weak) IBOutlet UIButton *star3;
@property (nonatomic,weak) IBOutlet UIButton *star4;
@property (nonatomic,weak) IBOutlet UIButton *star5;




@property (nonatomic, strong) Player *player;

- (IBAction)rateAction:(UIButton *)sender;
@end