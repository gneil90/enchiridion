
#import "GraphViewController.h"
#import "MeasurementsViewController.h"
#import "Record.h"
#import "GraphView.h"

@interface GraphViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIButton *toggleButton;
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = [self.record dateForDisplay];

	// Add the graph view to the scroll view.
	GraphView *graphView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, 600, 152)];
	[self.scrollView addSubview:graphView];
	self.scrollView.contentSize = graphView.bounds.size;
	self.graphView = graphView;
	self.graphView.showCircles = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	// Redraw after we come back from the Measurements View Controller,
	// because the values may have changed.
	[self redrawGraph];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowRecord"])
	{
		MeasurementsViewController *controller = segue.destinationViewController;
		controller.record = self.record;
	}
}



- (void)redrawGraph
{
	self.graphView.values = self.record.values;
	[self.graphView setNeedsDisplay];
}

- (IBAction)toggleGraph:(id)sender
{
	self.graphView.showCircles = !self.graphView.showCircles;
	[self redrawGraph];
}

- (void)setRecord:(Record *)newRecord
{
    if (_record != newRecord)
    {
        _record = newRecord;
        [self redrawGraph];
    }
}

@end
