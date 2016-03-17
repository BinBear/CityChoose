//
//  Config.m
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

#import "Config.h"

@implementation Config
+ (void)saveStrValueInUD:(NSString *)str forKey:(NSString *)key{
    if(!str){
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:str forKey:key];
    [ud synchronize];
}
+ (id)getValueInUDWithKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud valueForKey:key];
    
}
+(BOOL)isStringNilOrEmpty:(NSString *)str{
    if(str == nil || [@"" isEqualToString:str]){
        return YES;
    }else{
        return NO;
    }
}
@end
