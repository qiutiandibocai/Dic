//
//  SpellViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/18.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#import "SpellViewController.h"
#import "PYModel.h"
#import <sqlite3.h>
#import "PYJSViewController.h"
@interface SpellViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *array;
    NSMutableArray *aa;
    NSMutableArray *nsArray;
}

@property(nonatomic,strong)NSMutableArray *cellArray;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)NSArray *ab;
@property(nonatomic,strong)NSArray *sections;

@end

@implementation SpellViewController

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
    self.ab = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    self.sections =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    [self leftBar];
    [self headTitle];
    [self findAll];
    [self initData];
    if (_index ==8 || _index == 21 ) {
        _index++;
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:_index];
        [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else if (_index ==20){
        _index = 22;
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:_index];
        [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }else{
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:_index];
        [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    
}
-(NSArray *)findAll{
    array = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"aaaaa2" ofType:@"sqlite"];
    NSLog(@"path = %@",path);
    sqlite3 *db;
    sqlite3_open(path.UTF8String, &db);
    NSString *sql = @"select * from ol_pinyins";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            PYModel *PYM = [PYModel new];
            PYM.pinyin = [NSString stringWithCString:(char *)sqlite3_column_text(stmt,1) encoding:4];
            [array addObject:PYM];
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return array;
}
-(void)initData{
//    NSLog(@"array = %@",array);
    nsArray = [NSMutableArray array];
    for (int i = 0; i < 26; i++) {
        aa = [NSMutableArray array];
        int a = 0;
        for (PYModel *PY in array) {
            a++;
            if (a <= 26) {
                continue;
            }
            if ([PY.pinyin hasPrefix:self.ab[i]]) {
                [aa addObject:PY.pinyin];                
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
    return self.sections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int a = 0;
    NSInteger i = 0;
    for (PYModel *PY in array) {
        a++;
        if (a <= 26) {
            continue;
        }
        if ([PY.pinyin hasPrefix:self.ab[section]]) {
            i++;
        }
    }
    return i;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
//    PYModel *PYM = [PYModel new];
    NSString *str;
    NSMutableArray *aarr = [NSMutableArray array];
    aarr = nsArray[indexPath.section];
    str = aarr[indexPath.row];
//    NSLog(@"str = %@",str);
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
-(NSArray<NSString *>*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sections;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sections[section];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PYJSViewController *PYJS = [PYJSViewController new];
    PYJS.type = @"pinyin";
    PYJS.string = cell.textLabel.text;
    PYJS.title = cell.textLabel.text;
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
