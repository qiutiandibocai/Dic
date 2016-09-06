//
//  ViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/18.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#import "ViewController.h"
#import "SpellViewController.h"
#import "StrokeViewController.h"
#import "aboutViewController.h"
#import <sqlite3.h>
#import "SQLData.h"
#import "SQLD.h"
#import "INFOViewController.h"
@interface ViewController ()
{    
    CGFloat width;
    CGFloat height;
    UILabel *chooseLabel;
    UIView *chooseView;
    UIView *chooseView1;
    UIButton *spellButton;
    UIButton *aspellButton;
    CGFloat chooseViewWidth;
    CGFloat chooseViewHeight;
    UITextField *textField;
    UIView *alterView;
    UILabel *alterLabel;
    UIView *recentView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    [self addSegment];
    [self addTextField];
    [self addRecent];
    [self choose];
    [self first];
    [self secend];
    [self rightBar];
    [self creatDataBase];
//    [self addRecendSearch];
    [self addButtonToRecentView];
    
    alterView = [[UIView alloc]initWithFrame:CGRectMake(150, 200, 150, 40)];
    alterView.backgroundColor = RGBColor(200, 200, 200);
    alterView.alpha = 0;
    alterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 50)];
    alterLabel.textAlignment = NSTextAlignmentCenter;
    alterLabel.font = [UIFont systemFontOfSize:16];
    [alterView addSubview:alterLabel];
    [self.view addSubview:alterView];
}
-(void)rightBar{
    //title
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 20, 60, 50)];
    label.text = @"汉语字典";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToNext)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)pushToNext{
    aboutViewController *aboutV = [aboutViewController new];
    [self.navigationController pushViewController:aboutV animated:YES];
}
-(void)addSegment{
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UISegmentedControl *chooseSeg = [[UISegmentedControl alloc]initWithItems:@[@"拼音检索",@"部首检索"]];
    chooseSeg.frame =CGRectMake(30, 100, width-60, 40);
    chooseSeg.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:RGBColor(253, 235, 197)];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    [chooseSeg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:chooseSeg];
}
-(void)addTextField{
    textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 150, width-100, 40)];
    textField.placeholder = @"请输入..";
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearsOnBeginEditing = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.cornerRadius=12;
    textField.layer.masksToBounds = YES;
    [self.view addSubview:textField];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(width-70, 150, 40, 40);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)search{
    [textField resignFirstResponder];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"recentS"]];
    if (!mArray) {
        [userDefaults setObject:[NSArray array] forKey:@"recentS"];
    }
    int a = 0;
    for (NSString *str in mArray) {
        if ([textField.text isEqualToString:str]) {
            a++;
        }
    }
    if (a == 0) {
        [mArray insertObject:textField.text atIndex:0];
    }
    
    
    if (mArray.count == 8) {
        [mArray removeLastObject];
    }
    [userDefaults setObject:mArray forKey:@"recentS"];
    [userDefaults synchronize];
    [self addButtonToRecentView];
    alterView.alpha = 1;
    if ([textField.text isEqualToString:@""]) {
        [UIView animateWithDuration:3 animations:^{
            alterLabel.text = @"输入啊哥";
            alterView.alpha = 0;
        } completion:^(BOOL finished) {
            alterView.alpha = 0;
        }];
    }else if (textField.text.length == 1){
        int a = [textField.text characterAtIndex:0];
        if (a >= 0x4e00 && a <= 0x9fff) {
            alterView.alpha = 0;
            INFOViewController *INFO = [[INFOViewController alloc]init];
            INFO.string = textField.text;
            [self.navigationController pushViewController:INFO animated:YES];
        }else{
            [UIView animateWithDuration:3 animations:^{
                alterLabel.text = @"输入中文啊";
                alterView.alpha = 0;
            } completion:^(BOOL finished) {
                alterView.alpha = 0;
            }];
        }
 
    }else{
        [UIView animateWithDuration:3 animations:^{
            alterLabel.text = @"输入一个中文";
            alterView.alpha = 0;
        } completion:^(BOOL finished) {
            alterView.alpha = 0;
        }];
    }
}
//最近搜索
-(void)addRecent{
    UILabel *recentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 200, width-60, 40)];
    recentLabel.text = @"最近搜索:";
    [recentLabel setTextColor:RGBColor(110, 56, 51)];
    [self.view addSubview:recentLabel];
    
    recentView = [[UIView alloc]initWithFrame:CGRectMake(30, 250, width-60, 40)];
    recentView.backgroundColor = RGBColor(200, 200, 200);
    recentView.layer.borderWidth = 0.3;
    recentView.layer.cornerRadius = 5;
    recentView.layer.masksToBounds = YES;
    [self.view addSubview:recentView];
}
-(void)addButtonToRecentView{
    for (UIView *view in recentView.subviews) {
        [view removeFromSuperview];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:@"recentS"]];
    float buttonWidth = (recentView.frame.size.width-60)/7;
    for (int i = 0; i < mArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10*i+buttonWidth*i, 0, buttonWidth, 40);
        [button setTitle:mArray[i] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(110, 56, 51) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushTOInfo:) forControlEvents:UIControlEventTouchUpInside];
        [recentView addSubview:button];
    }
}
-(void)pushTOInfo:(UIButton *)sender{
    INFOViewController *INFO = [[INFOViewController alloc]init];
    INFO.string = sender.titleLabel.text;
    [self.navigationController pushViewController:INFO animated:YES];
}
//按照拼音或者部首
-(void)choose{
    chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, width-60, 40)];
    [chooseLabel setTextColor:RGBColor(110, 56, 51)];
    chooseLabel.text = @"按照拼音字母检索:";
    [self.view addSubview:chooseLabel];
    
    chooseView1 = [[UIView alloc]initWithFrame:CGRectMake(30, 350, width-60, height-350-40)];
    chooseView1.backgroundColor = RGBColor(200, 200, 200);
    chooseView1.layer.borderWidth = 0.3;
    chooseView1.layer.cornerRadius=8;
    chooseView1.layer.masksToBounds = YES;
    chooseView1.hidden = YES;
    
    chooseView = [[UIView alloc]initWithFrame:CGRectMake(30, 350, width-60, height-350-40)];
    chooseView.backgroundColor = RGBColor(200, 200, 200);
    chooseView.layer.borderWidth = 0.3;
    chooseView.layer.cornerRadius=8;
    chooseView.layer.masksToBounds = YES;
    [self.view addSubview:chooseView];
    
    chooseViewWidth = width-60;
    chooseViewHeight = height-390;
    chooseView.hidden = NO;
}
-(void)first{
    NSArray *array =[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",nil];
//    chooseLabel.text = @"按照拼音字母检索:";
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 8; j++) {
            spellButton = [UIButton buttonWithType:UIButtonTypeSystem];
            spellButton.frame = CGRectMake(10+(chooseViewWidth/9*j), 60+(chooseViewHeight/6*i), 35, 35);
            [spellButton setTitle:array[8*i+j] forState:UIControlStateNormal];
            [spellButton setTintColor:RGBColor(110, 56, 51)];
            spellButton.titleLabel.font = [UIFont systemFontOfSize:20];
            [spellButton addTarget:self action:@selector(spellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            spellButton.tag = 100+8*i+j;
            [chooseView addSubview:spellButton];
        }
    }
    UIButton *spellButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    spellButton1.frame = CGRectMake(10, chooseViewHeight/2+60, 35, 35);
    [spellButton1 setTitle:@"Y" forState:UIControlStateNormal];
    spellButton1.titleLabel.font =[UIFont systemFontOfSize:20];
    [spellButton1 setTintColor:RGBColor(110, 56, 51)];
    [spellButton1 addTarget:self action:@selector(spellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    spellButton1.tag = 124;
    [chooseView addSubview:spellButton1];
    
    UIButton *spellButton2 = [UIButton buttonWithType:UIButtonTypeSystem];
    spellButton2.frame = CGRectMake(10+chooseViewWidth/9, chooseViewHeight/2+60, 35, 35);
    [spellButton2 setTitle:@"Z" forState:UIControlStateNormal];
    spellButton2.titleLabel.font = [UIFont systemFontOfSize:20];
    [spellButton2 setTintColor:RGBColor(110, 56, 51)];
    [spellButton2 addTarget:self action:@selector(spellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    spellButton2.tag =125;
    [chooseView addSubview:spellButton2];
    [self.view addSubview:chooseView];
}
-(void)secend{
//    chooseLabel.text = @"按照部首笔画检索:";
    for (int j = 0; j < 9; j++) {
        aspellButton = [UIButton buttonWithType:UIButtonTypeSystem];
        int a = j+1;
        aspellButton.frame = CGRectMake(3+(chooseViewWidth/9*j), 60, 35, 35);
        [aspellButton setTitle:[NSString stringWithFormat:@"%d",a] forState:UIControlStateNormal];
        aspellButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [aspellButton setTintColor:RGBColor(110, 56, 51)];
        [aspellButton addTarget:self action:@selector(aspellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        aspellButton.tag =200+j;
        [chooseView1 addSubview:aspellButton];
    }
    for (int j = 0; j < 6; j++) {
        aspellButton = [UIButton buttonWithType:UIButtonTypeSystem];
        int a = 6+j+4;
        aspellButton.frame = CGRectMake(20+(chooseViewWidth/9*j), 60+(chooseViewHeight/6), 35, 35);
        [aspellButton setTitle:[NSString stringWithFormat:@"%d",a] forState:UIControlStateNormal];
        aspellButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [aspellButton setTintColor:RGBColor(110, 56, 51)];
        [aspellButton addTarget:self action:@selector(aspellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        aspellButton.tag = 209+j;
        [chooseView1 addSubview:aspellButton];
    }
    UIButton *aspellButton1 = [UIButton buttonWithType:UIButtonTypeSystem];
    aspellButton1.frame = CGRectMake(30, chooseViewHeight/3+60, 35, 35);
    [aspellButton1 setTitle:@"16" forState:UIControlStateNormal];
    aspellButton1.titleLabel.font = [UIFont systemFontOfSize:20];
    [aspellButton1 setTintColor:RGBColor(110, 56, 51)];
    [aspellButton1 addTarget:self action:@selector(aspellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    aspellButton1.tag = 215;
    [chooseView1 addSubview:aspellButton1];
    
    UIButton *spellButton3 = [UIButton buttonWithType:UIButtonTypeSystem];
    spellButton3.frame = CGRectMake(30+chooseViewWidth/9, chooseViewHeight/3+60, 35, 35);
    [spellButton3 setTitle:@"17" forState:UIControlStateNormal];
    spellButton3.titleLabel.font = [UIFont systemFontOfSize:20];
    [spellButton3 setTintColor:RGBColor(110, 56, 51)];
    [spellButton3 addTarget:self action:@selector(aspellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    spellButton3.tag = 216;
    [chooseView1 addSubview:spellButton3];
    [self.view addSubview:chooseView1];
}
-(void)chooseSeg:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            chooseLabel.text = @"按照拼音字母检索:";
            chooseView1.hidden = YES;
            chooseView.hidden = NO;
        }
            break;
        case 1:{
            chooseLabel.text = @"按照部首笔画检索:";
            chooseView1.hidden = NO;
            chooseView.hidden = YES;
        }
            break;
        default:
            break;
    }
}
-(void)spellButtonAction:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    SpellViewController *spellView = [SpellViewController new];
    spellView.index = (int)sender.tag-100;
    [self.navigationController pushViewController:spellView animated:YES];
}
-(void)aspellButtonAction:(UIButton *)sender{
    StrokeViewController *strokeView = [StrokeViewController new];
    strokeView.index = (int)sender.tag-200;
    [self.navigationController pushViewController:strokeView animated:YES];
}
-(void)creatDataBase{
   NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"S.sqlite"];
    sqlite3 *db;
    if( sqlite3_open(dbPath.UTF8String,&db) == SQLITE_OK){
        NSLog(@"打开数据库成功");
    }else{
        NSAssert(NO, @"数据库打开失败");
    }
    NSString *sql = @"create table if not exists SQLD(Sname text primary key,Spinyin text,Sbushou text,Sbihua text)";
    if (sqlite3_exec(db,sql.UTF8String,NULL,NULL,NULL) == SQLITE_OK){
        NSLog(@"创表成功");
    }
    sqlite3_close(db);    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
