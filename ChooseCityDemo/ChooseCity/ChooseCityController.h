//
//  ChooseCityController.h
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

// 设置颜色
#define SetColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define SetAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#import <UIKit/UIKit.h>
/**
 *		地区类型
 */
typedef enum {
    PlaceTypeState = 0, /**< 省份类型 */
    PlaceTypeCity = 1,  /**< 市类型 */
    PlaceTypeArea = 2   /**< 区类型 */
}PlaceType;

/**
 *		选择类型
 */
typedef enum {
    ChooseTypeCity = 1, /**< 省/市类型 */
    ChooseTypeArea = 2,  /**< 省/市/区类型 */
    
}ChooseType;

@class ChooseCityController;

/**
 *		地区选择器协议
 */
@protocol ChooseCityDelegate <NSObject>

@required

/**
 *	@brief	当地区选择器选中地区后
 *
 *	@param 	picker 	    选择器
 *  @param  address     选中的地址
 */
- (void)areaPicker:(ChooseCityController *)picker didSelectAddress:(NSString *)provinceValue andCityValue:(NSString *)cityValue andAreaValue:(NSString *)areaValue;

@end

@interface ChooseCityController : UITableViewController

/**
 *	地区类型(省/市/区)
 */
@property (nonatomic,assign) PlaceType type;
/**
 *	选择类型
 */
@property (nonatomic,assign) ChooseType chooseType;
/**
 *	Model放(省/市/区)数组
 */
@property (nonatomic, strong) NSArray *places;
/**
 *	当前已经选择的省信息
 */
@property (nonatomic, strong) NSString *placeName;
/**
 *	当前已经选择的城市信息
 */
@property (nonatomic, strong) NSString *cityName;
/**
 *	当前已经选择的地区信息
 */
@property (nonatomic, strong) NSString *areaName;
/**
 *	当前用户所在的地区
 */
@property (nonatomic, strong) NSString *userlocation;
/**
 *  地区数组长度
 */
@property (assign , nonatomic) NSInteger  dataCount;


@property (weak , nonatomic) id<ChooseCityDelegate> delegate;

@end
