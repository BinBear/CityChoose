//
//  ChooseCityController.m
//  ChooseCityDemo
//
//  Created by 熊彬 on 16/2/22.
//  Copyright © 2016年 彬熊. All rights reserved.
//  github地址：https://github.com/Angelmygirlxlf/CityChoose

#import "ChooseCityController.h"
#import "LBSManager.h"
#import "CityModel.h"
@interface ChooseCityController ()<UISearchBarDelegate,LBSManagerDelegate>
/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;

/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 *  获取定位信息
 */
@property (strong, nonatomic) LBSManager *lbs;
/**
 *  是否直辖市
 */
@property (assign , nonatomic) BOOL  isGovernment;
@end

static NSString *CellIdentifer = @"UITableViewCell";
static NSString *searchCellIdentifer = @"searchCell";

@implementation ChooseCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == PlaceTypeState) {
        
        self.title = @"选择省份";
        
        _places = [NSMutableArray array];
        _places = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        self.isSearch = NO;
        [self.tableView reloadData];

        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissAnimated:)];
        self.navigationItem.leftBarButtonItem = backButton;
        
        UIBarButtonItem *barItem = [UIBarButtonItem appearance];
        //将返回按钮的文字position设置不在屏幕上显示
        [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        UINavigationBar *nBar = [UINavigationBar appearance];
        nBar.tintColor = [UIColor grayColor];
        //获取lbs信息
        if ([Config isStringNilOrEmpty:self.userlocation]) {
            
            self.lbs  = [LBSManager startGetLBSWithDelegate:self];
            _userlocation = [LBSManager getUserLocationCityInfo];
        }
        

    }

}

- (void)initView
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"城市名称或首字母";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.searchBar.layer setBorderWidth:0.5f];
    [self.searchBar.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.tableView setTableHeaderView:self.searchBar];

}
#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}


- (NSMutableArray *) recordCityData
{
    if (_recordCityData == nil) {
        _recordCityData = [[NSMutableArray alloc] init];
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        for (NSDictionary *groupDic in array) {
 
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                CityModel *city = [[CityModel alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [self.recordCityData addObject:city];
            }
        }
    }
    return _recordCityData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearch) {
        return 1;
    }else{
        if (self.type == PlaceTypeState) {
            [self initView];
            return 2;
        }else{
            return 1;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return self.searchCities.count;
    }else{
        if (section == 0 && self.type == PlaceTypeState) {
            return 1;
        }else if(section == 1 && self.type == PlaceTypeState){
            return _places.count;
        }else{
            return self.dataCount;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (self.isSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        }
        [cell setBackgroundColor:SetColor(241, 241, 242)];
        CityModel *city =  [self.searchCities objectAtIndex:indexPath.row];
        [cell.textLabel setText:city.cityName];
        return cell;
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    [cell setBackgroundColor:SetColor(241, 241, 242)];
    if (self.chooseType == ChooseTypeCity) {
        self.isGovernment = YES;
    }
    switch (self.type) {
        case PlaceTypeState:
            if (indexPath.section == 0) {
                
                cell.textLabel.text = _userlocation.length > 0 ? [NSString stringWithFormat:@"%@",_userlocation] : @"正在定位...";
                cell.imageView.image = [UIImage imageNamed:@""];
            }else{
                cell.textLabel.text = _places[indexPath.row][@"state"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case PlaceTypeCity:
            cell.textLabel.text = _places[indexPath.row][@"city"];
            if (!self.isGovernment) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        case PlaceTypeArea:
            cell.textLabel.text = _places[indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearch || self.type == PlaceTypeCity || self.type == PlaceTypeArea) {
        return 0;
    }
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearch || self.type == PlaceTypeCity || self.type == PlaceTypeArea) {
        return nil;
    }
    
    UIView* myView = [[UIView alloc] init] ;
    myView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 22)];
    titleLabel.textColor=SetColor(80, 80, 80);
    titleLabel.backgroundColor = [UIColor clearColor];
    [myView addSubview:titleLabel];
    if (self.type == PlaceTypeState) {
        switch (section) {
            case 0:
                
                titleLabel.text = @"当前位置";
                break;
            case 1:
                titleLabel.text = @"全部";
                break;
            default:
                break;
        }
    }
    return myView;
}
#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        CityModel *city =  [self.searchCities objectAtIndex:indexPath.row];
        [self didSelctedCity:city];
    }else{
        
        
        ChooseCityController *nextPicker = [[ChooseCityController alloc]initWithStyle:UITableViewStylePlain];
        nextPicker.delegate = self.delegate;
        
        switch (self.type) {
            case PlaceTypeState:
                if (indexPath.section == 0) {
                    
                }else{
                    nextPicker.places    =  _places[indexPath.row][@"cities"];
                    nextPicker.type = PlaceTypeCity;
                    nextPicker.placeName = _places[indexPath.row][@"state"];
                    nextPicker.dataCount = nextPicker.places.count;
                    if (self.chooseType == ChooseTypeArea) {
                        nextPicker.chooseType = ChooseTypeArea;
                    }else if (self.chooseType == ChooseTypeCity){
                        nextPicker.chooseType = ChooseTypeCity;
                    }
                    NSArray *governmentArr = @[@"北京",@"上海",@"天津",@"重庆",@"台湾",@"香港",@"澳门",@"国外"];
                    for (NSString *str in governmentArr) {
                        if ([nextPicker.placeName isEqualToString:str]) {
                            nextPicker.isGovernment = YES;
                            nextPicker.title = @"选择地区";
                            break;
                        }else{
                            nextPicker.isGovernment = NO;
                            nextPicker.title =  @"选择城市";
                        }
                    }

                }
                break;
            case PlaceTypeCity:
                
                nextPicker.places   = _places[indexPath.row][@"areas"];
                nextPicker.type = PlaceTypeArea;
                nextPicker.title =  @"选择地区";
                nextPicker.dataCount = nextPicker.places.count;
                nextPicker.placeName = [NSString stringWithFormat:@"%@ %@",_placeName,_places[indexPath.row][@"city"]];
                if (self.chooseType == ChooseTypeArea) {
                    nextPicker.chooseType = ChooseTypeArea;
                }else if (self.chooseType == ChooseTypeCity){
                    nextPicker.chooseType = ChooseTypeCity;
                }
                break;
            case PlaceTypeArea:
                break;
            default:
                break;
        }
        
        if (nextPicker.places.count>0) {
            if (self.chooseType == ChooseTypeCity && self.type == PlaceTypeCity) {
                [self addRightBarButtonItem];
                
            }else{
                [self.navigationController pushViewController:nextPicker animated:YES];
            }
        }else{
            [self addRightBarButtonItem];
        }
  }
}

#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
    
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (CityModel *city in self.recordCityData){
            NSRange chinese = [city.cityName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  initials = [city.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                [self.searchCities addObject:city];
            }
        }
    }
    [self.tableView reloadData];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    self.isSearch = NO;
    [self.tableView reloadData];
}

#pragma mark - Private Methods
#pragma mark -- Action

/**
 *	@brief	选定地区事件
 *
 *	@param 	sender 	    事件传递值
 */
- (void)comfirmAction:(id)sender {
    
    NSString *place;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    switch (self.type) {
        case PlaceTypeState:
        {
            if (indexPath.section == 1) {
                place =  _places[indexPath.row][@"state"];
            }else{
                place = _userlocation;
                self.placeName = _userlocation;
                self.cityName = @" ";
                self.areaName = @" ";
            }
            
            break;
        }
        case PlaceTypeCity:
        {
            place = [NSString stringWithFormat:@"%@ %@",_placeName,_places[indexPath.row][@"city"]];
            self.cityName = _places[indexPath.row][@"city"];
            self.areaName = @" ";
            break;
        }
        case PlaceTypeArea:
        {
            place = [NSString stringWithFormat:@"%@ %@",_placeName,_places[indexPath.row]];
            NSArray *array = [place componentsSeparatedByString:@" "];
            self.placeName = array[0];
            self.cityName = array[1];
            self.areaName = _places[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(areaPicker:didSelectAddress:andCityValue:andAreaValue:)]) {
        
        [_delegate areaPicker:self didSelectAddress:self.placeName andCityValue:self.cityName andAreaValue:self.areaName];
        
    }
}

- (void)dismissAnimated:(UIBarButtonItem *)item
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) didSelctedCity:(CityModel *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(areaPicker:didSelectAddress:andCityValue:andAreaValue:)]) {
        
        [_delegate areaPicker:self didSelectAddress:@" " andCityValue:city.cityName andAreaValue:@" "];
    }
}
- (void) addRightBarButtonItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(comfirmAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
@end
