//
//  PresentationViewController.h
//  薛超APP框架
//
//  Created by 薛超 on 16/11/9.
//  Copyright © 2016年 薛超. All rights reserved.
//财务报告

#import "BaseViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
@interface PresentationViewController : BaseViewController<PNChartDelegate>
@property (nonatomic) PNLineChart * lineChart;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) PNRadarChart *radarChart;
@end
