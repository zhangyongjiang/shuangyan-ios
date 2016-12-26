//
//  UIImage+Kaishi.m
//  Kaishi
//
//  Created by Hyun Cho on 6/13/15.
//  Copyright (c) 2015 BCGDV. All rights reserved.
//

#import "UIImage+Kaishi.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Kaishi)

- (UIImage *)gaussianBlurImage {
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@50 forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CIFilter* controlsFilter = [CIFilter filterWithName:@"CIColorControls"];
    [controlsFilter setValue:result forKey:kCIInputImageKey];
    [controlsFilter setValue:@0.1 forKey:@"inputBrightness"];
    result = [controlsFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;

}


- (UIImage*)resizedImage:(CGSize)size {
    UIImage *generatedImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0); // just hard code this to 2x, iPhone 6+ would the only device with 3x, and that would make the images too big
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    generatedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return generatedImage;
}


+ (UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)resizeImageToMaxHeight {
    return [self resizeImageToWidth:[Config shared].defaultImageMaxHeight];
}


- (UIImage*)resizeImageToHeight:(CGFloat)height {
    CGFloat maxHeight = height;
    
    if ( self.size.width >= self.size.height ) {
        CGFloat ratio = self.size.height / self.size.width;
        UIImage* tempImage = [self resizedImage:CGSizeMake(maxHeight, maxHeight * ratio)];
        return tempImage;
    } else {
        CGFloat ratio = self.size.width / self.size.height;
        UIImage* tempImage = [self resizedImage:CGSizeMake(maxHeight * ratio, maxHeight)];
        return tempImage;
    }
}

- (UIImage*)resizeImageToWidth:(CGFloat)width
{
    if ( self.size.width >= width) {
        CGFloat ratio = self.size.height / self.size.width;
        UIImage* tempImage = [self resizedImage:CGSizeMake(width, width * ratio)];
        return tempImage;
    }
    return self;
}

- (NSData*)thumnbailDataForSharing {
    
    // create a thumbnail that's under 32k, but keep it under 30k
    CGFloat ratio = self.size.width / self.size.height;
    UIImage* thumbImage = [self resizedImage:CGSizeMake(300 * ratio, 300)];
    
    NSData* data;
    
    for ( CGFloat quality = 0.7; quality > 0.1; quality -= 0.1) {
        data = UIImageJPEGRepresentation(thumbImage, quality);
        if ( data.length < 1024 * 30 ) { // under 30k
            break;
        }
    }
    
    return data;
}

@end
