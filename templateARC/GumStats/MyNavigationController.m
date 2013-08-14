//
//  MyNavigationController.m
//  templateARC
//
//  Created by Mac Owner on 2/15/13.
//
//

#import "MyNavigationController.h"

#import "MyUnwindSegue.h"
@implementation MyNavigationController
- (UIStoryboardSegue *)segueForUnwindingToViewController:
(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier
{
    if (([identifier isEqualToString:@"DoneEdit"])||([identifier isEqualToString:@"CancelEdit"])||([identifier isEqualToString:@"DeleteValue"]))
        return [[MyUnwindSegue alloc]
                initWithIdentifier:identifier
                source:fromViewController
                destination:toViewController];
    else
        return [super segueForUnwindingToViewController:
                toViewController
                                     fromViewController:fromViewController
                                             identifier:identifier];
}
@end
