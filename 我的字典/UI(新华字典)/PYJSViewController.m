//
//  PYJSViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/22.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "PYJSViewController.h"
#import "NETPYModel.h"
#import "PYJSTableViewCell.h"
#import "INFOViewController.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
@interface PYJSViewController ()<UITableViewDelegate,UITableViewDataSource,IFlySpeechSynthesizerDelegate>
{
    NSMutableArray *dataSource;
    UITableView *myTableView;
    UIActivityIndicatorView *act;
    PYJSTableViewCell *cell;
    NSMutableArray *dataS;
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;
}
@end

@implementation PYJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    
    [self leftAndRightBar];
    if ([self.type isEqualToString:@"pinyin"]) {
        [self initpinyinData];
    }
    if ([self.type isEqualToString:@"boushou"]) {
        [self initbushouData];
    }
    
    
    myTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource =self;
    [self.view addSubview:myTableView];
    myTableView.backgroundView = imageView;
    [myTableView registerNib:[UINib nibWithNibName:@"PYJSTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([PYJSTableViewCell class])];
    myTableView.rowHeight = 120;
    
    [self createActivityIndicatirView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}
-(void)leftAndRightBar{
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:20],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToNext)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)pushToNext{
    NSLog(@"686...");
}
-(void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createActivityIndicatirView{
    act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    act.center = self.view.center;
    act.hidesWhenStopped = YES;
    myTableView.hidden = YES;
    [self.view addSubview:act];
    [act startAnimating];
    
}

-(void)initpinyinData{
    dataSource = [NSMutableArray array];
//    NSString *pinyinString =@"http://www.chazidian.com/service/pinyin/ban/0/2";
    NSString *pinyinString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/100",self.string];
    NSLog(@"str = %@",pinyinString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pinyinString]];
    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         NSDictionary *myDic=dic[@"data"];
        NSArray *status = myDic[@"words"];
        NSLog(@"sta = %ld",status.count);
            for (NSDictionary *getDic in status) {
                    NETPYModel *netModel = [NETPYModel new];
                    netModel.chinaName = getDic[@"simp"];
                    netModel.pinyin = getDic[@"yin"][@"pinyin"];
                    netModel.bushou = getDic[@"bushou"];
                    netModel.bihua = getDic[@"num"];
                [dataSource addObject:netModel];
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                myTableView.hidden = NO;
                [act stopAnimating];
                [myTableView reloadData];
        });
    }];
    [dataTask resume];
}
-(void)initbushouData{
    dataSource = [NSMutableArray array];
//     NSString *bushouString =@"http://www.chazidian.com/service/bushou/1/0/2";
    NSString *bushouString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/0/300",self.index];
    NSLog(@"str = %@",bushouString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:bushouString]];
    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *myDic=dic[@"data"];
        NSArray *status = myDic[@"words"];
        NSLog(@"sta = %@",status);
        for (NSDictionary *getDic in status) {
            NETPYModel *netModel = [NETPYModel new];
            netModel.chinaName = getDic[@"simp"];
            NSLog(@"netM = %@",netModel);
            netModel.pinyin = getDic[@"yin"][@"pinyin"];
            netModel.bushou = getDic[@"bushou"];
            netModel.bihua = getDic[@"num"];
            [dataSource addObject:netModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            myTableView.hidden = NO;
            [act stopAnimating];
            [myTableView reloadData];
        });
    }];
    [dataTask resume];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",dataSource.count);
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     cell = (PYJSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PYJSTableViewCell class])];
    NETPYModel *netM = dataSource[indexPath.row];
    cell.wordImageView.image = [UIImage imageNamed:@"mizige"];
    cell.wordNameLabel.text = netM.chinaName;
    UIFont *myFont = [UIFont fontWithName:@"Zapfino" size:40];
    cell.wordNameLabel.font = myFont;
    cell.duyinLabel.text =[NSString stringWithFormat:@"[%@]",netM.pinyin];
    cell.bushouLabel.text =[NSString stringWithFormat:@"部首:%@",netM.bushou];
    cell.bihuaLabel.text =[NSString stringWithFormat:@"笔画:%@",netM.bihua] ;
//    cell.soundImageView.image = [UIImage imageNamed:@"loud"];
//    cell.soundImageView.userInteractionEnabled = YES;
    cell.cellButton.tag = 100+indexPath.row;
    [cell.cellButton setImage:[UIImage imageNamed:@"loud"] forState:UIControlStateNormal];
    [cell.cellButton addTarget:self action:@selector(BAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
-(void)BAction:(UIButton *)sender{
    NSString *str;
    int a = (int)sender.tag-100;
    NETPYModel *netM = dataSource[a];
    str = netM.chinaName;
    NSLog(@"sssssss = %@",str);
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
    NETPYModel *netM = dataSource[indexPath.row];
    cell.wordNameLabel.text = netM.chinaName;
    INFOViewController *INFOV = [[INFOViewController alloc]init];
    INFOV.string = cell.wordNameLabel.text;
    dataS= [NSMutableArray array];
    [self.navigationController pushViewController:INFOV animated:YES];

    
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
