//
//  RankingViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/12/13.
//
//

#import "RankingViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@interface RankingViewController ()

@end

@implementation RankingViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRecognizer];
}

-(void)handleSwipeFrom:(id)sender
{
	// Create a UIImage with the contents of the destination
	
	CGPoint oldCenter = self.view.center;
	CGPoint newCenter = CGPointMake(oldCenter.x - self.view.bounds.size.width, oldCenter.y);
	//destinationImageView.center = newCenter;
    
	// Start the animation
    //[self dismissViewControllerAnimated:NO completion:nil];
	[UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void)
     {
         //destinationImageView.transform = CGAffineTransformIdentity;
         self.view.center = newCenter;
     }
                     completion: ^(BOOL done)
     {
         // Remove the image as we no longer need it
         [self dismissViewControllerAnimated:NO completion:nil];
         
         // Properly present the new screen
     }];

    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:
(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.rankedPlayers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    Player *player = self.rankedPlayers[indexPath.row];
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.game;
    return cell;
}/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
-(IBAction)done:(id)sender
{
    [self.delegate donePressed:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player = self.rankedPlayers[indexPath.row];
    [self performSegueWithIdentifier:@"Ranks"
                              sender:player];}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ranks"])
    {
        RatePlayerViewController *rateVC=segue.destinationViewController;
        rateVC.player=sender;
        rateVC.delegate=self;
    }
}

#pragma mark - RatePlayerViewControllerDelegate
- (void)ratePlayerViewController:
(RatePlayerViewController *)controller
          didPickRatingForPlayer:(Player *)player
{
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    appDelegate.changeFlag=1;
    if (self.rankState==kBestState)
    {
            if (player.rating<4)
            {
                NSUInteger index = [self.rankedPlayers
                                    indexOfObject:player];
                [self.rankedPlayers removeObjectAtIndex:index];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else{
                [self.tableView reloadData];
            }
    }
    else if (self.rankState==kWorstState)
    {
        if (player.rating>2)
        {
            NSUInteger index = [self.rankedPlayers
                                indexOfObject:player];
            [self.rankedPlayers removeObjectAtIndex:index];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [self.tableView reloadData];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
