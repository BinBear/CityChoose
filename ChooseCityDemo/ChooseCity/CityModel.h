//
//  CityModel.h
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
/*
 *  城市ID
 */
@property (nonatomic, strong) NSString *cityID;

/*
 *  城市名称
 */
@property (nonatomic, strong) NSString *cityName;

/*
 *  短名称
 */
@property (nonatomic, strong) NSString *shortName;

/*
 *  城市名称-拼音
 */
@property (nonatomic, strong) NSString *pinyin;

/*
 *  城市名称-拼音首字母
 */
@property (nonatomic, strong) NSString *initials;


@end

#pragma mark - CityGroup
@interface CityGroup : NSObject

/*
 *  分组标题
 */
@property (nonatomic, strong) NSString *groupName;

/*
 *  城市数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCitys;

@end
