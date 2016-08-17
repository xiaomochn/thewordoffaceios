//
//  FacePPHelper.h
//  thewordofface
//
//  Created by xiaomo on 16/8/15.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface FacePPHelper : NSObject
+ (FacePPHelper *)sharedDataHelper;
-(void) detectWithImage: (UIImage*) image  completionHandler:(void (^ )(NSDictionary * result))completionHandler;
@end
