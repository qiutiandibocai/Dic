//
//  USViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/20.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "USViewController.h"
#import "aboutViewController.h"
@interface USViewController ()

@end

@implementation USViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:imageView];
    
    [self leftAndRightBar];
    [self upSource];
    [self centerLabel];
    [self bottomLabel];
}
-(void)leftAndRightBar{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 20, 60, 50)];
    label.text = @"关于我们";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToNext)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)upSource{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, WIDTH-20, 60)];
    imageView.image = [UIImage imageNamed:@"z"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 120, 40)];
    label.text = @"指掌无线";
    label.font = [UIFont systemFontOfSize:20];
    [imageView addSubview:label];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, 150, 80, 30)];
    nameLabel.text = @"汉语字典";
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:nameLabel];
    
    UIImageView *dicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-40, 200, 80, 80)];
    dicImageView.image = [UIImage imageNamed:@"zidian"];
    [self.view addSubview:dicImageView];
}
-(void)centerLabel{
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, WIDTH-50, 200)];
    centerLabel.numberOfLines = 0;
    centerLabel.text = @"   汉语是世界上最精密的语言之一，语义丰富，耐人寻味。本词典篇幅简短，内容丰富，即求融科学性、知识性、规范性于一体，又注意突出时代特色。";
    centerLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:centerLabel];
}
-(void)bottomLabel{
    UILabel *aBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 500, WIDTH-100, 40)];
    aBottomLabel.text = @"官方网站:www.gouzizhang.com";
    aBottomLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:aBottomLabel];
    
    UILabel *bBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 540, WIDTH-100, 40)];
    bBottomLabel.text = @"官方微博:e.weibo.com/u/110";
    bBottomLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:bBottomLabel];
    
    UILabel *cBottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 580, WIDTH-100, 40)];
    cBottomLabel.text = @"微信公众号:扫我试试";
    cBottomLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:cBottomLabel];
}
-(void)pushToNext{
    NSLog(@"逗你玩呢，还真点啊");
}
-(void)popToRoot{
    
    [self.navigationController popViewControllerAnimated:YES];
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
