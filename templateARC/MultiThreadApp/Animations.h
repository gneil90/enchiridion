//
//  Animations.h
//  templateARC
//
//  Created by Mac Owner on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "macros.h"
@interface Animations : NSObject

@property (strong,nonatomic) NSString *nameImage;
@property (assign,nonatomic) AnimationTypes animationType;
@property (assign,nonatomic) ButtonTypes animationForButtonType;

@end
