//
//  ViewController.m
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//

#import "ViewController.h"
#import "ChooseCityController.h"
@interface ViewController ()<ChooseCityDelegate>

@property (weak , nonatomic) UIButton *chooseCityButton;

@end

@implementation ViewController
/*
 使用方法：
 1.导入头文件ChooseCityController.h
 2.设置代理，重写代理方法：- (void)areaPicker:(ChooseCityController *)picker didSelectAddress:(NSString *)provinceValue andCityValue:(NSString *)cityValue andAreaValue:(NSString *)areaValue; 返回省，市，区信息
 3.当前定位城市可初始化预设属性:userlocation
 4.控件选择省/市、省/市/区，配置属性:chooseType, 为枚举类型: ChooseTypeCity(省/市类型)   ChooseTypeArea(省/市/区类型)
 
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *chooseCityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    chooseCityBtn.center = self.view.center;
    [chooseCityBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [chooseCityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
    [chooseCityBtn addTarget:self action:@selector(onClickChooseCity:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseCityButton = chooseCityBtn;
    [self.view addSubview:chooseCityBtn];
}

- (void)onClickChooseCity:(id)sender {
    
    ChooseCityController *cityPickerVC = [[ChooseCityController alloc] init];
    cityPickerVC.delegate = self;
    // 外部可传入定位信息，若传入定位信息则内部不开启定位
    cityPickerVC.userlocation = @"广东省 深圳市";
    // 设置选择类型，可配置省/市、省/市/区
    cityPickerVC.chooseType = ChooseTypeCity;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

- (void)areaPicker:(ChooseCityController *)picker didSelectAddress:(NSString *)provinceValue andCityValue:(NSString *)cityValue andAreaValue:(NSString *)areaValue
{
    NSString * place = [NSString stringWithFormat:@"%@ %@ %@",provinceValue,cityValue,areaValue];

    [self.chooseCityButton setTitle:place forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
