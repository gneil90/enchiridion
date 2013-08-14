
#import "MeasurementsViewController.h"
#import "EditViewController.h"
#import "Record.h"

@interface MeasurementsViewController () 
@end

@implementation MeasurementsViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"EditValue"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		EditViewController *controller = (EditViewController *)navigationController.topViewController;

		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		NSNumber *number = self.record.values[indexPath.row];
		controller.value = [number intValue];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.record.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	NSNumber *number = self.record.values[indexPath.row];
	cell.textLabel.text = [number description];

	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.record deleteValueAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

- (IBAction)deleteValue:(UIStoryboardSegue *)segue
{
    NSIndexPath *indexPath = [self.tableView
                              indexPathForSelectedRow];
    [self.record deleteValueAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    EditViewController *controller = segue.sourceViewController;
    NSIndexPath *indexPath = [self.tableView
                              indexPathForSelectedRow];
    [self.record replaceValue:controller.value
                      atIndex:indexPath.row];
    [self.tableView reloadData];
}


@end
