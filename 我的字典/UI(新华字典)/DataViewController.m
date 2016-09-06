//
//  DataViewController.m
//  UI(新华字典)
//
//  Created by Ibokan2 on 16/7/23.
//  Copyright © 2016年 ibokan. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()
{
    NSString *str;
}
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSString *)inithanziData{
    NSString *hanString =@"http://www.chazidian.com/service/word/汉";
    NSString *hanziString = [hanString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //    NSString *hanziString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/100",self.string];
    NSLog(@"str = %@",hanziString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:hanziString]];
    NSLog(@"%@",request);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary *mDicc=dic[@"data"];
        NSDictionary *mDic = mDicc[@"baseinfo"];
        NSLog(@"%@",mDic);
        str = mDic[@"simp"];
        NSLog(@"str = %@",str);
        
    }];
    [dataTask resume];
    return str;
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
