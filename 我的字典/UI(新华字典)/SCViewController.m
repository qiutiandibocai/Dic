//
//  SCViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/25.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "SCViewController.h"
#import "PYJSTableViewCell.h"
#import <sqlite3.h>
#import "SQLD.h"
#import "MyData.h"
#import "INFOViewController.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@interface SCViewController ()<UITableViewDelegate,UITableViewDataSource,IFlySpeechSynthesizerDelegate>
{
    UITableView *myTableView;
    PYJSTableViewCell *cell;
    NSMutableArray *myData;
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
}
@end

@implementation SCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    [self leftAndRightBar];

    myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource =self;
    myTableView.backgroundView = imageView;
    [self.view addSubview:myTableView];
    [myTableView registerNib:[UINib nibWithNibName:@"PYJSTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([PYJSTableViewCell class])];
    myTableView.rowHeight = 120;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self findAll];
    
}
-(void)leftAndRightBar{
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];    
}
-(void)popToRoot{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",myData.count);
    return myData.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str = [NSString stringWithFormat:@"共收藏%ld个汉字",myData.count];
    return str;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = (PYJSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PYJSTableViewCell class])];
    MyData *mydata = myData[indexPath.row];
    cell.wordImageView.image = [UIImage imageNamed:@"mizige"];
    cell.wordNameLabel.text = mydata.SN;
    cell.duyinLabel.text =mydata.SPY;
    cell.bushouLabel.text =mydata.SBS;
    cell.bihuaLabel.text =mydata.SBH;
    [cell.cellButton setImage:[UIImage imageNamed:@"loud"] forState:UIControlStateNormal];
    cell.backgroundColor = [UIColor clearColor];
    cell.cellButton.tag = 100+indexPath.row;
    [cell.cellButton addTarget:self action:@selector(BAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    return cell;
}
-(void)BAction:(UIButton *)sender{
    NSString *str;
    int a = (int)sender.tag-100;
    MyData *MD = myData[a];
    str = MD.SN;
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate =self;
    //2.设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音速
    [_iFlySpeechSynthesizer setParameter:@"0" forKey:[IFlySpeechConstant SPEED]];
    //音量,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@"nannan" forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
    [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //3.启动合成会话
    [_iFlySpeechSynthesizer startSpeaking:str];
}
- (void) onCompleted:(IFlySpeechError *) error{
}
//合成开始
- (void) onSpeakBegin{
}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{
} //合成播放进度
- (void) onSpeakProgress:(int) progress{
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    INFOViewController *INFOV = [[INFOViewController alloc]init];
    INFOV.string = cell.wordNameLabel.text;
    [self.navigationController pushViewController:INFOV animated:YES];
}

-(NSArray *)findAll{
    myData = [NSMutableArray array];
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"S.sqlite"];
    NSLog(@"dbPath = %@",dbPath);
    sqlite3 *db;
    sqlite3_open(dbPath.UTF8String, &db);
    NSString *sql = @"select * from SQLD";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            MyData *MYD = [MyData new];
            MYD.SN = [NSString stringWithCString:(char *)sqlite3_column_text(stmt,0) encoding:4];
            MYD.SPY =[NSString stringWithCString:(char *)sqlite3_column_text(stmt,1) encoding:4];
            MYD.SBS = [NSString stringWithCString:(char *)sqlite3_column_text(stmt,2) encoding:4];
            MYD.SBH = [NSString stringWithCString:(char *)sqlite3_column_text(stmt,3) encoding:4];
            [myData addObject:MYD];            
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    NSLog(@"mydata = %@",myData);
    return myData;
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
