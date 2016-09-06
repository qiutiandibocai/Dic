//
//  INFOViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/23.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#import "INFOViewController.h"
#import "SCViewController.h"
#import <sqlite3.h>
#import "SQLD.h"
#import "SQLData.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@interface INFOViewController ()
{
    
    UILabel *hanziLabel;
    UILabel *pinyinLabel;
    UILabel *fantiLabel;
    UILabel *bushouLabel;
    UILabel *bishunLabel;
    UILabel *zhuyinLabel;
    UILabel *jiegouLabel;
    UILabel *bushoubihuaLabel;
    UILabel *bihuaLabel;
    UIView *INFOView;
    UIImageView *baseImageView;
    UILabel *baseLabel;
    UIView *hanyuView;
    UILabel *hanyuLabel;
    UIImageView *hanyuImageView;
    UIView *chengyuView;
    UILabel *chengyuLabel;
    UIImageView *chengyuImageView;
    UIView *fanyiView;
    UILabel *fanyiLabel;
    UIImageView *fanyiImageView;
    NSInteger index;
    UIView *myView;
    UILabel *myLabel;
    UIView *tishiView;
    UILabel *tishiLabel;
}
@property(nonatomic,strong)NSString *str;
@end

@implementation INFOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 0;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:imageView];
    NSLog(@"_str = %@",_string);
    self.title = _string;
//    self.title = _hanziString;
    [self leftAndRightBar];
    [self headView];
    [self initData];
    [self addSegment];
    [self fanyiView];
    [self chengyuView];
    [self hanyuView];
    [self setView];
    [self baseView];
    [self setToolBar];
   
    tishiView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-100, HEIGHT/2-100, 200, 50)];
    tishiView.backgroundColor =  RGBColor(200, 200, 200);
    tishiView.alpha = 0;
    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
//    tishiLabel.text = @"收藏成功,将进入收藏页面";
    tishiLabel.font = [UIFont systemFontOfSize:16];
    [tishiView addSubview:tishiLabel];
    [self.view addSubview:tishiView];
    
}
-(void)setToolBar{
    self.navigationController.toolbarHidden = YES;
    UIToolbar *toolBar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, 60)];
    toolBar.backgroundColor = RGBColor(140, 33, 43);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 60, 60)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    label1.text = @"书法家";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font =[UIFont fontWithName:@"Zapfino" size:15];
    [view1 addSubview:label1];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 60, 40);
    [button1 setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [view1 addSubview:button1];
    UIBarButtonItem *firstBar = [[UIBarButtonItem alloc]initWithCustomView:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake((WIDTH-220)/3, 0, 60, 60)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    label2.text = @"复制";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font =[UIFont fontWithName:@"Zapfino" size:15];
    [view2 addSubview:label2];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 60, 40);
    [button2 setImage:[UIImage imageNamed:@"document"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(fuzhi) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:button2];
    UIBarButtonItem *secondBar = [[UIBarButtonItem alloc]initWithCustomView:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake((WIDTH-220)/3*2, 0, 60, 60)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    label3.text = @"收藏";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font =[UIFont fontWithName:@"Zapfino" size:15];
    [view3 addSubview:label3];
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(0, 0, 60, 40);
    [button3 setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(shoucang) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:button3];
    UIBarButtonItem *thirdBar = [[UIBarButtonItem alloc]initWithCustomView:view3];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-80, 0, 60, 60)];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    label4.text = @"分享";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font =[UIFont fontWithName:@"Zapfino" size:15];
    [view4 addSubview:label4];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(0, 0, 60, 40);
    [button4 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
    [view4 addSubview:button4];
    UIBarButtonItem *fourBar = [[UIBarButtonItem alloc]initWithCustomView:view4];
    
    UIBarButtonItem *toolbarpadding = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[firstBar,toolbarpadding,secondBar,toolbarpadding,thirdBar,toolbarpadding,fourBar];
    [self.view addSubview:toolBar];
}
-(void)shufa{
    
}
-(void)fuzhi{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = hanziLabel.text;
    tishiView.alpha =1;
    tishiLabel.text = @"复制成功";
    [UIView animateWithDuration:2 animations:^{
        tishiView.alpha = 0;
    } completion:^(BOOL finished) {
        NSLog(@"复制好了");
    }];

}
-(void)fenxiang{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray *imageArray = @[image];
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    [shareDic SSDKSetupShareParamsByText:@"666" images:imageArray url:[NSURL URLWithString:@"http://mob.com"] title:@"无题" type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareDic onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:{
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"可以" style:UIAlertActionStyleDefault handler:nil];
                [alertView addAction:okAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }
                break;
            case SSDKResponseStateFail:{
                UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                [alertV addAction:okA];
                [self presentViewController:alertV animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
}
-(void)shoucang{
    SQLData *sqld = [SQLData new];
    sqld.Sname = hanziLabel.text;
    sqld.Spinyin = pinyinLabel.text;
    sqld.Sbushou = bushouLabel.text;
    sqld.Sbihua = bihuaLabel.text;
    [self insetSQLD:sqld];
    tishiView.alpha =1;
    tishiLabel.text = @"收藏成功,将进入收藏页面";
    [UIView animateWithDuration:3 animations:^{
        tishiView.alpha = 0;
    } completion:^(BOOL finished) {
        SCViewController *SCV = [[SCViewController alloc]init];
//        SCV.hzS = hanziLabel.text;
//        SCV.pyS = pinyinLabel.text;
//        SCV.bsS = bushouLabel.text;
//        SCV.bhS = bihuaLabel.text;
        [self.navigationController pushViewController:SCV animated:YES];
    }];
}
-(void)share{
    
}
-(void)addSegment{
    UISegmentedControl *chooseSeg = [[UISegmentedControl alloc]initWithItems:@[@"基本信息",@"汉语字典",@"组成成语",@"英文翻译"]];
    chooseSeg.frame =CGRectMake(30, 200, WIDTH-60, 60);
    chooseSeg.selectedSegmentIndex = 0;
    [[UISegmentedControl appearance] setTintColor:RGBColor(253, 235, 197)];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    [chooseSeg addTarget:self action:@selector(chooseSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:chooseSeg];
}
-(void)chooseSeg:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            INFOView.frame = CGRectMake(0, 270, WIDTH, HEIGHT-310);
            chengyuView.frame =CGRectMake(0, HEIGHT+20, 20, 20);
            hanyuView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
        }
            break;
        case 1:{
            chengyuView.frame =CGRectMake(0, HEIGHT+20, 20, 20);
            INFOView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
            hanyuView.frame =  CGRectMake(0, 270, WIDTH, HEIGHT-310);
        }
            break;
        case 2:{
            chengyuView.frame = CGRectMake(0, 270, WIDTH, HEIGHT-310);
            INFOView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
            hanyuView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
        }
            break;
        case 3:{
            chengyuView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
            INFOView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
            hanyuView.frame = CGRectMake(0, HEIGHT+20, 20, 20);
            fanyiView.frame = CGRectMake(0, 270, WIDTH, HEIGHT-310);
        }
            break;
        default:
            break;
    }
}
-(void)setView{
    INFOView = [[UIView alloc]initWithFrame:CGRectMake(0, 270, WIDTH, HEIGHT-330)];
    [self.view addSubview:INFOView];
    
    baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, INFOView.frame.size.width-20, INFOView.frame.size.height-20)];
    baseImageView.image = [UIImage imageNamed:@"informatianlow"];
    [INFOView addSubview:baseImageView];
    
    UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70, 7, 40, 60)];
    iView.image = [UIImage imageNamed:@"brooch"];
    [INFOView addSubview:iView];
}
-(void)baseView{
    baseLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, baseImageView.frame.size.width-40, baseImageView.frame.size.height)];
    baseLabel.font = [UIFont systemFontOfSize:16];
    baseLabel.numberOfLines = 0;
    [baseImageView addSubview:baseLabel];
}
-(void)hanyuView{
    hanyuView = [[UIView alloc]initWithFrame:CGRectMake(0, 270, WIDTH, HEIGHT-310)];
    [self.view addSubview:hanyuView];
    
    hanyuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, hanyuView.frame.size.width-20, hanyuView.frame.size.height-20)];
    hanyuImageView.image = [UIImage imageNamed:@"informatianlow"];
    [hanyuView addSubview:hanyuImageView];
    
    UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70, 7, 40, 60)];
    iView.image = [UIImage imageNamed:@"brooch"];
    [hanyuView addSubview:iView];
    
    hanyuLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, hanyuImageView.frame.size.width-40, hanyuImageView.frame.size.height)];
    hanyuLabel.font = [UIFont systemFontOfSize:16];
    hanyuLabel.numberOfLines = 0;
    [hanyuImageView addSubview:hanyuLabel];
}
-(void)chengyuView{
    chengyuView = [[UIView alloc]initWithFrame:CGRectMake(0, 270, WIDTH, HEIGHT-310)];
    [self.view addSubview:chengyuView];
    
    chengyuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, chengyuView.frame.size.width-20, chengyuView.frame.size.height-20)];
    chengyuImageView.image = [UIImage imageNamed:@"informatianlow"];
    [chengyuView addSubview:chengyuImageView];
    
    UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70, 7, 40, 60)];
    iView.image = [UIImage imageNamed:@"brooch"];
    [chengyuView addSubview:iView];
    
    chengyuLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, chengyuImageView.frame.size.width-40, chengyuImageView.frame.size.height)];
    chengyuLabel.font = [UIFont systemFontOfSize:16];
    chengyuLabel.numberOfLines = 0;
    [chengyuImageView addSubview:chengyuLabel];
}
-(void)fanyiView{
    fanyiView = [[UIView alloc]initWithFrame:CGRectMake(0, 270, WIDTH, HEIGHT-310)];
    [self.view addSubview:fanyiView];
    
    fanyiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, fanyiView.frame.size.width-20, fanyiView.frame.size.height-20)];
    fanyiImageView.image = [UIImage imageNamed:@"informatianlow"];
    [fanyiView addSubview:fanyiImageView];
    
    UIImageView *iView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-70, 7, 40, 60)];
    iView.image = [UIImage imageNamed:@"brooch"];
    [fanyiView addSubview:iView];
    
    fanyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, fanyiImageView.frame.size.width-40, fanyiImageView.frame.size.height)];
    fanyiLabel.font = [UIFont systemFontOfSize:16];
    fanyiLabel.numberOfLines = 0;
    [fanyiImageView addSubview:fanyiLabel];

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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)headView{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 60, 60)];
    imageView.image = [UIImage imageNamed:@"banmizige"];
    [self.view addSubview:imageView];
    
    hanziLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 60, 60)];
    hanziLabel.font = [UIFont systemFontOfSize:25];
    hanziLabel.textColor = RGBColor(140, 33, 43);
    hanziLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hanziLabel];    
    
    pinyinLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 80, 80, 20)];
    pinyinLabel.font = [UIFont systemFontOfSize:17];
    pinyinLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:pinyinLabel];
    
    fantiLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 100, 80, 20)];
    fantiLabel.font = [UIFont systemFontOfSize:17];
    fantiLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:fantiLabel];
    
    bushouLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 120, 80, 20)];
    bushouLabel.font = [UIFont systemFontOfSize:17];
    bushouLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:bushouLabel];
    
    bishunLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 150, 300, 40)];
    bishunLabel.font = [UIFont systemFontOfSize:17];
    bishunLabel.textColor = RGBColor(140, 33, 43);
    bishunLabel.numberOfLines = 0;
    [self.view addSubview:bishunLabel];
    
    zhuyinLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 80, 100, 20)];
    zhuyinLabel.font = [UIFont systemFontOfSize:17];
    zhuyinLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:zhuyinLabel];
    
    jiegouLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 100, 120, 20)];
    jiegouLabel.font = [UIFont systemFontOfSize:17];
    jiegouLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:jiegouLabel];
    
    bushoubihuaLabel =[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 120, 120, 20)];
    bushoubihuaLabel.font =[UIFont systemFontOfSize:17];
    bushoubihuaLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:bushoubihuaLabel];
    
    bihuaLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+120, 120, 80, 20)];
    bihuaLabel.font = [UIFont systemFontOfSize:17];
    bihuaLabel.textColor = RGBColor(140, 33, 43);
    [self.view addSubview:bihuaLabel];
}

-(void)initData{
//    dataSource = [NSMutableArray array];
    //    NSString *pinyinString =@"http://www.chazidian.com/service/pinyin/ban/0/2";
//    NSString *strr = @"http://www.chazidian.com/service/word/办";
    NSString *strr = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.title];
    NSString *pinyinString = [strr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *pinyinString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/100",self.string];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pinyinString]];
//    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *myDic=dic[@"data"];
        NSDictionary *mdic = myDic[@"baseinfo"];
        //NSLog(@"myDic = %@",myDic);
        NSString *hanziS = mdic[@"simp"];
        NSString *pinyinS = mdic[@"yin"][@"pinyin"];
        NSString *fantiS = mdic[@"tra"];
        NSString *bushouS = mdic[@"bushou"];
        NSString *bishunS = mdic[@"seq"];
        NSString *zhuyinS = mdic[@"yin"][@"zhuyin"];
        NSString *jiegouS = mdic[@"frame"];
        NSString *bushoubihuaS = mdic[@"bsnum"];
        NSString *bihuaS = mdic[@"num"];
        NSString *baseStr = myDic[@"base"];
        NSString *hanyuS = myDic[@"hanyu"];
        NSString *chengyuS = myDic[@"idiom"];
        NSString *fanyiS =myDic[@"english"];
        dispatch_async(dispatch_get_main_queue(), ^{
             hanziLabel.text = hanziS;
            pinyinLabel.text = [NSString stringWithFormat:@"拼音:%@",pinyinS];
            fantiLabel.text = [NSString stringWithFormat:@"繁体:%@",fantiS];
            bushouLabel.text = [NSString stringWithFormat:@"部首:%@",bushouS];
            bishunLabel.text = [NSString stringWithFormat:@"笔顺:%@",bishunS];
            zhuyinLabel.text = [NSString stringWithFormat:@"注音:%@",zhuyinS];
            jiegouLabel.text = [NSString stringWithFormat:@"结构:%@",jiegouS];
            bushoubihuaLabel.text = [NSString stringWithFormat:@"部首笔画:%@",bushoubihuaS];
            bihuaLabel.text = [NSString stringWithFormat:@"笔画:%@",bihuaS];
            baseLabel.text = [NSString stringWithFormat:@"%@",baseStr];
            hanyuLabel.text = [NSString stringWithFormat:@"%@",hanyuS];
            chengyuLabel.text =[NSString stringWithFormat:@"%@",chengyuS];
            fanyiLabel.text = [NSString stringWithFormat:@"%@",fanyiS];
            
        });
    }];
    [dataTask resume];
}
-(BOOL)insetSQLD:(SQLData *)sqld{
    BOOL flag = NO;
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"S.sqlite"];
    sqlite3 *db;
    sqlite3_open(dbPath.UTF8String, &db);
    NSString *sql = @"insert or replace into SQLD (Sname ,Spinyin,Sbushou,Sbihua) values (?,?,?,?)";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db,sql.UTF8String,-1,&stmt,nil) == SQLITE_OK ) {
        sqlite3_bind_text(stmt,1,sqld.Sname.UTF8String,-1,NULL);
        sqlite3_bind_text(stmt,2,sqld.Spinyin.UTF8String,-1,NULL);
        sqlite3_bind_text(stmt,3,sqld.Sbushou.UTF8String,-1,NULL);
        sqlite3_bind_text(stmt,4,sqld.Sbihua.UTF8String,-1,NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            flag = YES;
        }
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return  flag;
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
