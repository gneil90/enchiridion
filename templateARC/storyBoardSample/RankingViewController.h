//
//  RankingViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/12/13.
//
//

#import <UIKit/UIKit.h>
#import "RatePlayerViewController.h"

typedef enum {kBestState,kWorstState} RankState;

@class RankingViewController;
@protocol RankingViewDelegate
-(void)donePressed:(RankingViewController*)controller;
@end

@interface RankingViewController : UITableViewController
<RatePlayerViewControllerDelegate>

@property (assign,nonatomic) RankState rankState;


@property (nonatomic, strong) NSMutableArray *rankedPlayers;
@property (nonatomic,weak) id delegate;
- (IBAction)done:(id)sender;

@end
