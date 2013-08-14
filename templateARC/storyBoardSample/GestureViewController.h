//
//  ViewController.h
//  storyBoardSample
//
//  Created by Mac Owner on 2/8/13.
//
//

#import <UIKit/UIKit.h>
#import "RankingViewController.h"
@interface GestureViewController: UIViewController <RankingViewDelegate>

@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic,strong) NSMutableArray *worstPlayers;
@property (nonatomic,strong) NSMutableArray *bestPlayers;
@property (nonatomic, strong) IBOutlet UISwipeGestureRecognizer
*swipeGestureRecognizer;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;


@end
