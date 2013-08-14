//
//  CoordinatesController.h
//  templateARC
//
//  Created by Mac Owner on 2/19/13.
//
//

#import <Foundation/Foundation.h>
#import "macros.h"
@interface CoordinatesController : NSObject

@property (assign,nonatomic) BOOL pointIsEmpty;
@property (assign,nonatomic) CGPoint pointToDrawButton;
@property (assign,nonatomic) CGFloat degreeValue;
@property (assign,nonatomic) ButtonTypes typeOfButton;
@property (assign,nonatomic) BOOL isPointConverted;

@end
