//
//  DetailViewController+Graph.swift
//  Currency
//
//  Created by Mohd Maruf on 08/04/22.
//

import Foundation
import Charts

extension DetailViewController {
    
    func configureChart() {
        chartView.chartDescription?.enabled = false
        
        chartView.maxVisibleCount = 40
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.highlightFullBarEnabled = false
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        let leftAxis = chartView.leftAxis
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formToTextSpace = 4
        l.xEntrySpace = 6
        
        updateChartData()
    }
    
    func updateChartData() {
        self.setChartData(count: 10, range: 10)
    }
    
    func setChartData(count: Int, range: UInt32) {
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val1 = Double(arc4random_uniform(mult) + mult / 3)
            
            return BarChartDataEntry(x: Double(i), yValues: [val1])
        }
        
        let set = BarChartDataSet(entries: yVals, label: "")
        set.drawIconsEnabled = false
        set.colors = [ChartColorTemplates.material()[0]]
        set.stackLabels = ["USD"]
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 12, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.fitBars = false
        chartView.data = data
    }
}
