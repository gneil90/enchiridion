//
//  PlayersViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/8/13.
//
//

#import <UIKit/UIKit.h>
#import "PlayerDetailViewController.h"
#import "RatePlayerViewController.h"

@interface PlayersViewController : UITableViewController
<PlayerDetailsViewControllerDelegate,RatePlayerViewControllerDelegate>
@property (nonatomic,retain) NSMutableArray *players;
@property (nonatomic,assign) int rating;
@end
