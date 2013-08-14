//
//  DetailsViewController.h
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

#import <UIKit/UIKit.h>
#import "macros.h"
#import "Protocols.h"
@class Fugitive;
@class Subobjective;
@class CircleView;
@class ObjectiveButtonClass;
@class ButtonObjectClass;

@interface MapDetailsViewController : UIViewController

{
    CGPoint coordinateToCreateButton;
}


@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) Fugitive* toDoAssignment;
@property (strong,nonatomic) ButtonObjectClass * selectedButton;

@property (weak,nonatomic) IBOutlet UIDatePicker *datePicker;

@property (assign,nonatomic) ButtonTypes buttonTypeToCreate;
@property (assign,nonatomic) BOOL isNewButtonZoomIn;
@property (weak,nonatomic) id delegate;

@property (weak,nonatomic) IBOutlet UILabel *numberOfSubojectives;
@property (weak,nonatomic) IBOutlet UILabel *objectiveNameTitle;
@property (weak,nonatomic) IBOutlet UILabel *name;

@property (weak,nonatomic) IBOutlet UIButton* buttonToCreateSubObjective;

@property (weak,nonatomic) IBOutlet UIButton* circle1;

@property (weak,nonatomic) ObjectiveButtonClass *buttonFromZoomIn;


-(IBAction)circleSelected:(id)sender;
-(IBAction)addSubObjective:(id)sender;

-(void)setupDetailView:(__weak ButtonObjectClass*)button createNewButton:(BOOL)createNewButton showDetailsOfExisted:(BOOL)showDetailsOfExisted;
-(void)showSubobjectivesName:(Subobjective*)subobjective delay:(CGFloat)delay;

@end
