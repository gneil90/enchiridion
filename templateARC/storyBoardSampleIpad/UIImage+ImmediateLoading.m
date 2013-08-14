//
//  UIImage+ImmediateLoading.m
//  SwapTest
//
//  Created by Julian Asamer on 3/11/11.
//  Code taken from https://gist.github.com/259357
//

#import "UIImage+ImmediateLoading.h"

@implementation UIImage (UIImage_ImmediateLoading)

+ (UIImage*)imageImmediateLoadWithContentsOfFile:(NSString*)path {
    return [[UIImage alloc] initImmediateLoadWithContentsOfFile: path];
}

- (UIImage*) initImmediateLoadWithContentsOfFile:(NSString*)path {

    
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    CGImageRef imageRef = [image CGImage];
    CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       CGImageGetBitsPerComponent(imageRef),
                                                       CGImageGetBytesPerRow(imageRef),
                                                       CGImageGetColorSpace(imageRef),
                                                       kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                                       );
    //kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little are the bit flags required so that the main thread doesn't have any conversions to do.
    
    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    __autoreleasing UIImage* decompressedImage = [[UIImage alloc] initWithCGImage: decompressedImageRef];
    
    CGImageRelease(decompressedImageRef);
    decompressedImageRef=NULL;
    CGContextRelease(bitmapContext);
    bitmapContext=NULL;
    
   // CGImageRelease(imageRef);
    return decompressedImage;
}
@end

@implementation UIImage (Crop)

-(UIImage*)crop:(CGRect)rect;
{
    CGFloat scale = self.scale;
    rect = CGRectMake(rect.origin.x*scale
, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    NSLog(@"Image cropped.");
    return result;
}

@end

@implementation UIImage (BBlock)

+(NSCache*)drawingCache
{
    static NSCache *cache = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{cache = [[NSCache alloc]init];});
    return cache;
}
+(UIImage*)imageForSize:(CGSize)size opaque:(BOOL)opaque withDrawingBlock:(void (^)())drawingBlock
{
    if (size.width<=0||size.height<=0)
    {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, opaque, 0.0f);
    if (drawingBlock) {
        drawingBlock();
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage*)imageForSize:(CGSize)size withDrawingBlock:(void (^)())drawingBlock
{
    return [self imageForSize:size opaque:NO withDrawingBlock:drawingBlock];
}
+(UIImage*)imageWithIdentifier:(NSString *)identifier opaque:(BOOL)opaque forSize:(CGSize)size andDrawingBlock:(void (^)())drawingBlock
{
    UIImage *image = [[self drawingCache] objectForKey:identifier];
    if (image==nil&&(image = [self imageForSize:size opaque:opaque withDrawingBlock:drawingBlock])) {
        [[self drawingCache] setObject:image forKey:identifier];
    }
    return image;
}
+(UIImage*)imageWithIdentifier:(NSString *)identifier forSize:(CGSize)size andDrawingBlock:(void (^)())drawingBlock
{
    return [self imageWithIdentifier:identifier opaque:NO forSize:size andDrawingBlock:drawingBlock];
}


@end
