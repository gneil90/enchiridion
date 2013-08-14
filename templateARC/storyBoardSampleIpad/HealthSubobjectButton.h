//
//  HealthSubobjectButton.h
//  templateARC
//
//  Created by Mac Owner on 5/27/13.
//
//

#import "HealthButton.h"
@class Subobjective;

@interface HealthSubobjectButton : HealthButton

@property (nonatomic, strong) UIImage * isReachedImage;
@property (nonatomic,strong) UIImage *isNotReachedImage;

@property (strong, nonatomic) Subobjective *subobjective;

@end
