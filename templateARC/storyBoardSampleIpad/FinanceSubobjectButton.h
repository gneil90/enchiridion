//
//  FinanceSubobjectButton.h
//  templateARC
//
//  Created by Mac Owner on 5/27/13.
//
//

#import "FinanceButton.h"
@class Subobjective;
@interface FinanceSubobjectButton : FinanceButton


@property (nonatomic, strong) UIImage * isReachedImage;
@property (nonatomic,strong) UIImage *isNotReachedImage;

@property (strong, nonatomic) Subobjective *subobjective;



@end
