//
//  StrokeViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/18.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define WIDTH self.view.frame.size.width
#import "StrokeViewController.h"
#import "ViewController.h"
#import "BSModel.h"
#import <sqlite3.h>
#import "PYJSViewController.h"
@interface StrokeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *array;
    NSMutableArray *aa;
    NSMutableArray *nsArray;
}
@property(nonatomic,strong)NSArray *sectionArray;
@property(nonatomic,strong)NSArray *numberArray;
@end

@implementation StrokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
  
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    UITableView *myTableView =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    myTableView.rowHeight = 40;
    myTableView.backgroundView = imageView;
    myTableView.sectionIndexColor = [UIColor redColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sectionArray = [NSArray arrayWithObjects:@"笔画一", @"笔画二", @"笔画三", @"笔画四",@"笔画五",@"笔画六", @"笔画七", @"笔画八", @"笔画九",@"笔画十",@"笔画十一", @"笔画十二", @"笔画十三", @"笔画十四",@"笔画十五",@"笔画十六", @"笔画十七", nil];
    self.numberArray = [NSArray arrayWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",nil];
    
   
    [self leftBar];
    [self headTitle];
    [self findAll];
    [self initData];
    
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:_index];
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(NSArray *)findAll{
    array = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"aaaaa2" ofType:@"sqlite"];
//    NSLog(@"path = %@",path);
    sqlite3 *db;
    sqlite3_open(path.UTF8String, &db);
    NSString *sql = @"select * from ol_bushou";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            BSModel *BSM = [BSModel new];
            BSM.bihua = sqlite3_column_int(stmt,1);
            BSM.title = [NSString stringWithCString:(char *)sqlite3_column_text(stmt,2) encoding:4];
            [array addObject:BSM];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
//    NSLog(@"array = %@",array);
    return array;
}
-(void)initData{
//    NSLog(@"array = %@",array);
    nsArray = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        aa = [NSMutableArray array];
        
        for (BSModel *BSM in array) {
            if (BSM.bihua == i+1) {
                [aa addObject:BSM.title];
            }
        }
        [nsArray addObject:aa];        
    }
//    NSLog(@"sec = %@",nsArray);


}
-(void)leftBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)headTitle{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 20, 60, 50)];
    label.text = @"拼音检索";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

-(void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 17;
}
-(NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.numberArray;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionArray[section];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    for (BSModel *BSM in array) {
        if (BSM.bihua == section+1) {
            number++;
        }
    }
    return number;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
    NSString *str;
    NSMutableArray *aarr = [NSMutableArray array];
    aarr = nsArray[indexPath.section];
    str = aarr[indexPath.row];
    //NSLog(@"str = %@",str);
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.textLabel.text = str;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PYJSViewController *PYJS = [PYJSViewController new];
    PYJS.type = @"boushou";
    PYJS.string = cell.textLabel.text;
    PYJS.title = cell.textLabel.text;
    int number = 1;
    for (BSModel *BSM in array) {
        if (![BSM.title isEqualToString:cell.textLabel.text]) {
            number++;
        }else{
            break;
        }
    }
    NSLog(@"num = %d",number);
    PYJS.index = number;
    [self.navigationController pushViewController:PYJS animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
