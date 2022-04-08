//
//  DetailViewController.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import UIKit
import RxSwift
import Charts

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(
                UINib(nibName: "\(DetailTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(DetailTableViewCell.self)"
            )
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var otherCurrencytableView: UITableView! {
        didSet {
            otherCurrencytableView.register(
                UINib(nibName: "\(DetailTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(DetailTableViewCell.self)"
            )
        }
    }
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var otherCurrencyBGView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    
    var viewModel = DetailViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTableViewData()
    }
    
    @IBAction func dateSelectionAction(_ sender: UIButton) {
        showDateSelectionOptions()
    }
}
