//
//  macros.h
//  templateARC
//
//  Created by Mac Owner on 2/18/13.
//
//

//CGAffineTransformMake:

//# 1 = 0th row is at the top, and 0th column is on the left.
//# Orientation Normal
//image.fOrientation = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);

//# 2 = 0th row is at the top, and 0th column is on the right.
//# Flip Horizontal
//image.fOrientation = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, w, 0.0)

//# 3 = 0th row is at the bottom, and 0th column is on the right.
//# Rotate 180 degrees
//image.fOrientation = CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, w, h)

//# 4 = 0th row is at the bottom, and 0th column is on the left.
//# Flip Vertical
//image.fOrientation = CGAffineTransformMake(1.0, 0.0, 0, -1.0, 0.0, h)

//# 5 = 0th row is on the left, and 0th column is the top.
//# Rotate -90 degrees and Flip Vertical
//image.fOrientation = CGAffineTransformMake(0.0, -1.0, -1.0, 0.0, h, w)

//# 6 = 0th row is on the right, and 0th column is the top.
//# Rotate 90 degrees
//image.fOrientation = CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, w)

//# 7 = 0th row is on the right, and 0th column is the bottom.
//# Rotate 90 degrees and Flip Vertical
//image.fOrientation = CGAffineTransformMake(0.0, 1.0, 1.0, 0.0, 0.0, 0.0)

//# 8 = 0th row is on the left, and 0th column is the bottom.
//# Rotate -90 degrees
//image.fOrientation = CGAffineTransformMake(0.0, 1.0,-1.0, 0.0, h, 0.0)

#ifndef templateARC_macros_h
#define templateARC_macros_h
#import "AppDelegate.h"

#define myAppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]


//типы главных кнопок
typedef enum {kHealthTypeButton, kFinanceTypeButton, kPrivateLifeButton, kButtonSubobject, kNewButtonToCreate, kButtonDefault} ButtonTypes;

//типы анимаций
typedef enum  {
    
               kMainAnimationCenterFinance,
               kMainAnimationCenterHealth,
               kMainAnimationCenterPrivateLife,
    
               kGlitterAnimationFinance,
               kGlitterAnimationFinance2,
        
               kGlitterAnimationHealth,
               kGlitterAnimationHealth2,
    
               kAppearanceAnimationFinance,
               kAppearanceAnimationFinance2,
    
               kAppearanceAnimationHealth,
               kAppearanceAnimationHealth2,
    
               kAppearanceAnimationPrivateLife,
               kAppearanceAnimationPrivateLife2,
    
               kGlitterAnimationPrivateLife,
               kGlitterAnimationPrivateLife2,
    
               kAnimationDefault
    
               } AnimationTypes;

//типы сияний
typedef enum {
    
            kGlitterHealth,
            kGlitterHealth2,
    
            kGlitterFinance,
            kGlitterFinance2,
    
            kGlitterPrivateLife,
            kGlitterPrivateLife2,
    
            kGlitterNoneType

             } GlitterType;

//подтипы главных кнопок
typedef enum {kHealthSubButtonType, kHealthZoomOutSubButtonType, kFinanceSubButtonType, kFinanceZoomOutSubButtonType, kPrivateLifeSubButtonType,kPrivateLifeZoomOutSubButtonType, kFinanceSubobjectButton, kHealthSubobjectButton,kPrivateLifeSubobjectButton} subButtonTypes;

//типа маски для сияния
typedef enum
{
        kGlitterMaskFinance,
        kGlitterMaskFinance2,
    
    kGlitterMaskHealth,
    kGlitterMaskHealth2,
    
    kGlitterMaskPrivateLife,
    kGlitterMaskPrivateLife2
    
} GlitterMaskType;

typedef enum
{
  kCircleMonthImageView,
  kViewSubobjectiveNames
}

imageViewTags;

typedef enum
{
    kButtonStateReached,
    kButtonStateNoSubobjective,
    kButtonStateHasSubobjectives,
    kButtonStateDefault
}
ButtonStates;


#endif
