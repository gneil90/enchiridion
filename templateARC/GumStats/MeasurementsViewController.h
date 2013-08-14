
@class Record;

@interface MeasurementsViewController : UITableViewController

@property (nonatomic, strong) Record *record;

- (IBAction)cancel:(UIStoryboardSegue *)segue;

- (IBAction)done:(UIStoryboardSegue *)segue;

- (IBAction)deleteValue:(UIStoryboardSegue *)segue;
@end
