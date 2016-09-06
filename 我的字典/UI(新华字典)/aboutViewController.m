//
//  aboutViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/20.
//  Copyright © 2016年 ibokan. All rights reserved.
//
#define WIDTH self.view.frame.size.width
#define  RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#import "aboutViewController.h"
#import "aboutTableViewCell.h"
#import "More.h"
#import "USViewController.h"
#import "IdeaViewController.h"
#import "SCViewController.h"
#import "ShareViewController.h"
@interface aboutViewController ()<UITableViewDelegate,UITableViewDataSource>
{
   
    NSMutableArray *array;
    
}
@end

@implementation aboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor =  RGBColor(140, 33, 43);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"beijing"];
    [self leftBar];
    [self headTitle];
    [self getArray];
    UITableView *myTableView =[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundView = imageView;
    [self.view addSubview:myTableView];
    
    [myTableView registerNib:[UINib nibWithNibName:@"aboutTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([aboutTableViewCell class])];
       myTableView.rowHeight = 100;
    
     self.edgesForExtendedLayout = UIRectEdgeNone;

}
-(void)leftBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popToRoot)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}
-(void)headTitle{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 20, 60, 50)];
    label.text = @"汉语字典";
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}
-(void)popToRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getArray{
    array = [NSMutableArray array];
    NSArray *newArray = @[@"我的收藏",@"分享",@"意见反馈",@"精品应用",@"应用打分",@"关于我们"];
    for (int i = 0; i < 6; i++) {
        More *more = [More new];
        more.imageName = [NSString stringWithFormat:@"continue"];
        more.cellName = newArray[i];
        [array addObject:more];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    aboutTableViewCell *cell =(aboutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([aboutTableViewCell class])];
    More *more = array[indexPath.row];
    cell.headLabel.text = more.cellName;
    cell.lastImageView.image = [UIImage imageNamed:more.imageName];
    cell.backgroundColor =[UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:25];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row){
        case 0:{
            SCViewController *SCV = [[SCViewController alloc]init];
            [self.navigationController pushViewController:SCV animated:YES];
        }
            break;
        case 1:{
            ShareViewController *ShareV = [ShareViewController new];
            [self.navigationController pushViewController:ShareV animated:YES];
        }
            break;
        case 2:{
            IdeaViewController *IDV = [IdeaViewController new];
            [self.navigationController pushViewController:IDV animated:YES];
        }
            break;
        case 3:{
            
        }
            break;
        case 4:{
            
        }
            break;
        case 5:{
            USViewController *USV = [USViewController new];
            [self.navigationController pushViewController:USV animated:YES];
        }
            break;
        default:
            break;
    }
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
