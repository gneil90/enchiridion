//
//  PlayersViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/8/13.
//
//

#import "PlayersViewController.h"
#import "Player.h"
#import "AppDelegate.h"
@interface PlayersViewController ()

@end

@implementation PlayersViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate reloadDataTable:self];
    
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
    Player *player = [self.players objectAtIndex:indexPath.row];
	cell.textLabel.text = player.name;
	cell.detailTextLabel.text = player.game;
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%dStarsSmall.png",player.rating]];
    // Configure the cell...
    
    return cell;
}

/*
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)playerDetailsViewControllerDidCancel:
(PlayerDetailViewController *)controller
{
	[controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    	if ([segue.identifier isEqualToString:@"AddPlayer"])
	{
		UINavigationController *navigationControllerDetail =
        segue.destinationViewController;
        navigationControllerDetail.navigationBar.tintColor=[UIColor darkGrayColor];
		PlayerDetailViewController
        *playerDetailsViewController =
        [[navigationControllerDetail viewControllers]
         objectAtIndex:0];
		playerDetailsViewController.delegate = self;
        
        //модальное представление будет появляться в строго соответствующей зоне
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
        navigationControllerDetail.modalPresentationStyle =
        UIModalPresentationCurrentContext;
        //playerDetailsViewController.contentSizeForViewInPopover =
        //CGSizeMake(320, 423);
        }

	}
    else if ([segue.identifier isEqualToString:@"EditPlayer"])
    {
        UINavigationController *navigationController =
        segue.destinationViewController;
        PlayerDetailViewController *playerDetailsViewController
        = [navigationController viewControllers][0];
        playerDetailsViewController.delegate = self;
        NSIndexPath *indexPath = sender;
        Player *player = self.players[indexPath.row];
        playerDetailsViewController.playerToEdit = player;
    }
    else if ([segue.identifier isEqualToString:@"RatePlayer"])
    {
        //так это push navigationController объвлять не нужно
        RatePlayerViewController *ratePlayerViewController =
        segue.destinationViewController;
        ratePlayerViewController.delegate = self;
        NSIndexPath *indexPath = [self.tableView
                                  indexPathForCell:sender];
        Player *player = self.players[indexPath.row];
        ratePlayerViewController.player = player;
        
    }
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:
(NSIndexPath *)indexPath
{
    UINavigationController *navigationController =
    [self.storyboard instantiateViewControllerWithIdentifier:
     @"PlayerDetailsNavigationController"];
    PlayerDetailViewController *playerDetailsViewController =
    [navigationController viewControllers][0];
    playerDetailsViewController.delegate = self;
    Player *player = self.players[indexPath.row];
    playerDetailsViewController.playerToEdit = player;
    navigationController.modalPresentationStyle=UIModalPresentationCurrentContext;
    [self presentViewController:navigationController
                       animated:YES completion:nil];
}

- (void)playerDetailsViewController:
(PlayerDetailViewController *)controller
                       didAddPlayer:(Player *)player
{
	[self.players addObject:player];
	NSIndexPath *indexPath =
    [NSIndexPath indexPathForRow:[self.players count]-1
                       inSection:0];
	[self.tableView insertRowsAtIndexPaths:
     [NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playerDetailsViewController:(PlayerDetailViewController *)controller didEditPlayer:(Player *)player
{
    
    //second variant
    /*
     NSUInteger index = [self.players indexOfObject:player];
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
     inSection:0];
     [self.tableView reloadRowsAtIndexPaths:@[indexPath]
     withRowAnimation:UITableViewRowAnimationAutomatic];
     */
    NSUInteger rowNumber=[self.players indexOfObject:player];
    [self.players removeObject:player];
    NSIndexPath *indexPath =
    [NSIndexPath indexPathForRow:rowNumber
                       inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.players addObject:player];

    NSIndexPath *indexPathInsert=[NSIndexPath indexPathForRow:[self.players count] - 1
                       inSection:0];
	[self.tableView insertRowsAtIndexPaths:
     [NSArray arrayWithObject:indexPathInsert]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
	[self dismissViewControllerAnimated:YES completion:nil];

}


- (void)ratePlayerViewController:
(RatePlayerViewController *)controller
          didPickRatingForPlayer:(Player *)player
{
    NSUInteger index = [self.players indexOfObject:player];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
