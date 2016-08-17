//
//  FacePPHelper.m
//  thewordofface
//
//  Created by xiaomo on 16/8/15.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

#import "FacePPHelper.h"
#import "FaceppAPI.h"

@implementation FacePPHelper

// 因为实例是全局的 因此要定义为全局变量，且需要存储在静态区，不释放。不能存储在栈区。
static FacePPHelper *helper = nil;

// 伪单例 和 完整的单例。 以及线程的安全。
// 一般使用伪单例就足够了 每次都用 sharedDataHandle 创建对象。
+ (FacePPHelper *)sharedDataHelper
{
    // 添加同步锁，一次只能一个线程访问。如果有多个线程访问，等待。一个访问结束后下一个。
    @synchronized(self){
        if (nil == helper) {
            helper = [[FacePPHelper alloc] init];
        }
    }
    return helper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [FaceppAPI initWithApiKey:@"d277502ffe983493f92754c4431726db" andApiSecret:@"pxyJuPZXukNG4JGPllXqooYaOOna4rIv" andRegion:APIServerRegionCN];
    }
    return self;
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


// Use facepp SDK to detect faces
-(void) detectWithImage: (UIImage*) image  completionHandler:(void (^ )(NSDictionary * result))completionHandler{
    NSOperationQueue * opQueue =[[NSOperationQueue alloc] init];
    NSBlockOperation * operation = [NSBlockOperation  blockOperationWithBlock:^{
        UIImage *image1 = [self fixOrientation:image];
        FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image1, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeAll];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (result.success) {
                completionHandler([result content]);
            }else{
                completionHandler(nil);
            }
        }];
        
    }];
    [opQueue addOperation:operation];
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    dispatch_sync(queue , ^{
    //        UIImage *image1 = [self fixOrientation:image];
    //        FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeNone];
    ////        if (result.success) {
    ////            dispatch_sync(dispatch_get_main_queue(), ^{
    ////                completionHandler([result content]);
    ////            });
    ////        }
    //
    //
    //    });
    return;
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeNone];
    if (result.success) {
        double image_width = [[result content][@"img_width"] doubleValue] *0.01f;
        double image_height = [[result content][@"img_height"] doubleValue] * 0.01f;
        
        UIGraphicsBeginImageContext(image.size);
        [image drawAtPoint:CGPointZero];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
        CGContextSetLineWidth(context, image_width * 0.7f);
        
        // draw rectangle in the image
        int face_count = [[result content][@"face"] count];
        for (int i=0; i<face_count; i++) {
            double width = [[result content][@"face"][i][@"position"][@"width"] doubleValue];
            double height = [[result content][@"face"][i][@"position"][@"height"] doubleValue];
            CGRect rect = CGRectMake(([[result content][@"face"][i][@"position"][@"center"][@"x"] doubleValue] - width/2) * image_width,
                                     ([[result content][@"face"][i][@"position"][@"center"][@"y"] doubleValue] - height/2) * image_height,
                                     width * image_width,
                                     height * image_height);
            CGContextStrokeRect(context, rect);
        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        float scale = 1.0f;
        scale = MIN(scale, 280.0f/newImage.size.width);
        scale = MIN(scale, 257.0f/newImage.size.height);
        //        [imageView setFrame:CGRectMake(imageView.frame.origin.x,
        //                                       imageView.frame.origin.y,
        //                                       newImage.size.width * scale,
        //                                       newImage.size.height * scale)];
        //        [imageView setImage:newImage];
        //        FaceppResult *resulu= [[[FaceppRecognition alloc] init] searchWithKeyFaceId:[result content][@"face"][0][@"face_id"] andFacesetId:nil orFacesetName:@"starlib3" andCount:nil async:NO];
        
    } else {
        // some errors occurred
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"error message: %@", [result error].message]
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        //        [alert release];
    }
    //    [image release];
    //
    //    [pool release];
}
@end
