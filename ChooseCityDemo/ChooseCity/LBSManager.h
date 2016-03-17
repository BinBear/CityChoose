//
//  LBSManager.h
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
@class LBSManager;
@protocol LBSManagerDelegate <NSObject>
@optional
- (void)getLbsSuccessWithLongitude:(NSString *)longitude latitude:(NSString *)latitude;

@end

@interface LBSManager : NSObject
@property (nonatomic, assign) id<LBSManagerDelegate>delegate;

+ (LBSManager *)startGetLBSWithDelegate:(id<LBSManagerDelegate>)delegate;
+ (NSString *)getUserLocationCityInfo;
@end
