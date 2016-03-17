# CityChoose
/*
 使用方法：
 1.导入头文件ChooseCityController.h
 2.设置代理，重写代理方法：- (void)areaPicker:(ChooseCityController *)picker didSelectAddress:(NSString *)provinceValue andCityValue:(NSString *)cityValue andAreaValue:(NSString *)areaValue; 返回省，市，区信息
 3.当前定位城市可初始化预设属性:userlocation
 4.控件选择省/市、省/市/区，配置属性:chooseType, 为枚举类型: ChooseTypeCity(省/市类型)   ChooseTypeArea(省/市/区类型)
 
*/

