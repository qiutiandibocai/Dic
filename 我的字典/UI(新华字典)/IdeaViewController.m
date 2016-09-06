//
//  IdeaViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/20.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define APPIRATER   NSLocalizedString(@"我草死你个大嘴... ", nil)

#import "IdeaViewController.h"

@interface IdeaViewController ()<UITextViewDelegate>
{
    NSTimer *timer;
}
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UIView *aview;
@property(nonatomic,strong)UIView *bview;
@property(nonatomic,strong)UIView *cview;
@property(nonatomic,strong)UIView *dview;
@property(nonatomic,strong)UILabel *ageLabel;
@property(nonatomic,strong)UIButton *button;
@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:imageView];
    self.textView =[[UITextView alloc]initWithFrame:CGRectMake(20, 70, WIDTH-40, HEIGHT-170)];
    self.textView.textColor=[UIColor lightGrayColor];
    self.textView.font = [UIFont systemFontOfSize:20];
    self.textView.tintColor = RGBColor(110, 56, 51);
    self.textView.text=APPIRATER;
    self.textView.selectedRange=NSMakeRange(0,0) ;
    self.textView.delegate=self;
    [self.view addSubview:self.textView];
    
    [self leftAndRightBar];
    [self leftBottomAction];
    [self centerBootom];
    [self okButton];
}
-(void)leftAndRightBar{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 20, 60, 50)];
    label.text = @"意见反馈";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"magnifier"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToNext)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)pushToNext{
    NSLog(@"哥们，别点了");
}
-(void)popToRoot{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
    if ([text isEqualToString:@"\n"])
    {
        if ([textView.text isEqualToString:@""])
        {
            textView.textColor=[UIColor lightGrayColor];
            textView.text=APPIRATER;
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor=[UIColor lightGrayColor];
        textView.text=APPIRATER;
    }
}
-(void)leftBottomAction{
    self.aview = [[UIView alloc]initWithFrame:CGRectMake(20, HEIGHT-80, 80, 40)];
    self.aview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.aview];
    
    self.sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,40,40)];
    self.sexLabel.text = @"性别";
    self.sexLabel.tintColor = RGBColor(110, 56, 51);
    self.sexLabel.font = [UIFont systemFontOfSize:20];
    [self.aview addSubview:self.sexLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"downward"] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.aview addSubview:button];
    
}
-(void)moreAction{
    NSLog(@"点了一下");
    self.bview = [[UIView alloc]initWithFrame:CGRectMake(20, HEIGHT-160, 80, 80)];
    self.bview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.bview];
    
    UIButton *man = [UIButton buttonWithType:UIButtonTypeSystem];
    man.frame = CGRectMake(0, 0, 80, 40);
    [man setTitle:@"男" forState:UIControlStateNormal];
    [man addTarget:self action:@selector(manLabel) forControlEvents:UIControlEventTouchUpInside];
    [self.bview addSubview:man];
    
    
    UIButton *woman = [UIButton buttonWithType:UIButtonTypeSystem];
    woman.frame = CGRectMake(0, 40, 80, 40);
    [woman setTitle:@"女" forState:UIControlStateNormal];
    [woman addTarget:self action:@selector(womanLabel) forControlEvents:UIControlEventTouchUpInside];
    [self.bview addSubview:woman];
}
-(void)manLabel{
    self.sexLabel.text = @"男";
    [self.bview removeFromSuperview];
}
-(void)womanLabel{
   self.sexLabel.text = @"女";
    [self.bview removeFromSuperview];
}
-(void)centerBootom{
    self.cview = [[UIView alloc]initWithFrame:CGRectMake(130, HEIGHT-80, 80, 40)];
    self.cview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cview];
    
    self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,40,40)];
    self.ageLabel.text = @"年龄";
    self.ageLabel.tintColor = RGBColor(110, 56, 51);
    self.ageLabel.font = [UIFont systemFontOfSize:20];
    [self.cview addSubview:self.ageLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 0, 40, 40);
    [button setImage:[UIImage imageNamed:@"downward"] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(mmoreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cview addSubview:button];

}
-(void)mmoreAction{
    NSLog(@"点了一下");
    self.dview = [[UIView alloc]initWithFrame:CGRectMake(130, HEIGHT-280, 80, 200)];
    self.dview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.dview];
    for (int i = 0; i < 10; i++) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        self.button.frame = CGRectMake(0, 0+20*i, 80, 20);
        [self.button setTitle:[NSString stringWithFormat:@"%d",10+i] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(ageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.button.tag = 10+i;
        [self.dview addSubview:self.button];
    }
}
-(void)ageAction:(UIButton*)sender{
    NSLog(@"点尼玛");
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",sender.tag];
    [self.dview removeFromSuperview];
}
-(void)okButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = RGBColor(140, 33, 42);
    button.frame = CGRectMake(WIDTH-110, HEIGHT-80, 80, 40);
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)backAction{
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
