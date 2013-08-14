//
//  UIImage+ImmediateLoading.h
//  SwapTest
//
//  Created by Julian Asamer on 3/11/11.
//  Code taken from https://gist.github.com/259357
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (UIImage_ImmediateLoading)

- (UIImage*) initImmediateLoadWithContentsOfFile:(NSString*)path;
+ (UIImage*)imageImmediateLoadWithContentsOfFile:(NSString*)path;

@end

@interface UIImage (Crop)
-(UIImage*)crop:(CGRect)rect;
@end

#define BBlockImageIdentidier (fmt,...) [NSString stringWithFormat:("%@%@",fmt),\NSStringFromClass([self class]),NSStringFromSelector(_cmd),##__VA_ARGS__]

@interface UIImage (BBlock)

//returns a 'UIImage' with the drawing code in the block.
//this method does not cache the image object.
+(UIImage *)imageForSize:(CGSize)size withDrawingBlock:(void(^)())drawingBlock;
+(UIImage*) imageForSize:(CGSize)size opaque:(BOOL)opaque withDrawingBlock:(void(^)())drawingBlock;
//returns a cached UIImage rendered with the drawing code in the block.
//the UIImage is cached in a NSCache with the identifier provided.
+(UIImage*)imageWithIdentifier:(NSString*)identifier forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock;
+(UIImage*)imageWithIdentifier:(NSString*)identifier opaque:(BOOL)opaque forSize:(CGSize)size andDrawingBlock:(void(^)())drawingBlock;


@end