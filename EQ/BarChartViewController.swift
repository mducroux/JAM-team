//
//  BarChartViewController.swift
//  EQ
//
//  Created by Alexander Sanchez de la Cerda on 12.11.17.
//  Copyright © 2017 Alexander Sanchez de la Cerda. All rights reserved.
//

import Foundation
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    var months: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [5.0, 4.0, 2.0, 3.0, 1.0, 5.0, 5.0, 4.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
    }
    

    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .bottom
        chartDataSet.colors = [UIColor(red: 230/255, green: 200/255, blue: 34/255, alpha: 1)]
        barChartView.chartDescription?.text = ""
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        let ll = ChartLimitLine(limit: 5.0, label: "Target")
        barChartView.rightAxis.addLimitLine(ll)
        
    }
    
}
