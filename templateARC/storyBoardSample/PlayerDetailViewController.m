//
//  PlayerDetailViewController.m
//  templateARC
//
//  Created by Mac Owner on 2/8/13.
//
//

#import "PlayerDetailViewController.h"
#import "AppDelegate.h"
@interface PlayerDetailViewController ()

@end

@implementation PlayerDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init PlayerDetailsViewController");
		self.gameName = @"Chess";
	}
	return self;
}

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
    self.addName.delegate=self;
    
    if (self.playerToEdit != nil)
    {
        self.title = @"Edit Player";
        self.addName.text = self.playerToEdit.name;
        self.gameName = self.playerToEdit.game;
    }
    //в static cell по default два UILabel
    self.detailLabel.text = self.gameName;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.detailLabel.text = self.gameName;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _addName=nil;
    _detailLabel=nil;
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaticCell" //forIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}*/

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
    //даже если в случае выбора staticCell, будем вызываться экземпляр UITextField
        if (indexPath.section == 0)
            [self.addName becomeFirstResponder];
    
}


- (IBAction)cancel:(id)sender
{
	[self.delegate playerDetailsViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    if (self.playerToEdit != nil)
    {
        self.playerToEdit.name = self.addName.text;
        self.playerToEdit.game = _gameName;
        [self.delegate playerDetailsViewController:self
                                     didEditPlayer:self.playerToEdit];
    }
    else
    {
    Player *player=[[Player alloc]init];
    player.name=self.addName.text;
    player.game=self.gameName;
    player.rating=1;
        [self.delegate playerDetailsViewController:self didAddPlayer:player];
    //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"resigning First Responder");
    [textField resignFirstResponder];
    return YES;
}

- (void)gamePickerViewController:
(GamePickerViewController *)controller
                   didSelectGame:(NSString *)game
{
    NSLog(@"Receive Message from GamePicker. Begin to implement");
    if (self.gameName)
    {
        self.gameName=nil;
    }
    self.gameName=game;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushGame"])
    {
        GamePickerTableViewController *gamePickerVC=segue.destinationViewController;
        gamePickerVC.delegate=self;
        gamePickerVC.game=nil;
        gamePickerVC.game=self.gameName;
    }
}



@end
