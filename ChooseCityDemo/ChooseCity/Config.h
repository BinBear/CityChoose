//
//  Config.h
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key;
+ (id)getValueInUDWithKey:(NSString *)key;
+(BOOL)isStringNilOrEmpty:(NSString *)str;
@end
