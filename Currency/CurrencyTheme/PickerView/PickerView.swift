//
//  PickerView.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import UIKit

class PickerView: UIView {

    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.backgroundColor = .white
        }
    }
    @IBOutlet var picker: UIPickerView!
    @IBOutlet weak var pickerBottomConstraint: NSLayoutConstraint!
   
    static var shared: PickerView {
        guard let pickerView = Bundle.main.loadNibNamed("PickerView", owner: self, options: nil)?.first as? PickerView else {
            return PickerView()
        }
        return pickerView
    }
    var contentArray = [Any]()
    var selectedObject: Any?
    var dataBlock:((_ object: Any?) -> Void)?
    
    @IBAction func cancelAction(_ sender: Any) {
        remove(superview)
        dataBlock?(nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        remove(superview)
        if picker.isHidden {
            dataBlock?(datePicker.date)
        } else {
            dataBlock?(selectedObject == nil ? contentArray.first : selectedObject)
        }
    }
    
    func showPicker(_ data: [String], selectedValue: String? = nil,  completion: @escaping (Any) -> Void) {
        contentArray = data
        datePicker.isHidden = true
        picker.isHidden = false
        picker.delegate = self
        picker.dataSource = self
        if let value = selectedValue {
            let selectedElement = data.firstIndex(of: value)
            picker.selectRow(selectedElement ?? 0, inComponent: 0, animated: true)
            selectedObject = value.isEmpty ? nil : value
        }
        dataBlock = completion
        frame = UIScreen.main.bounds
        UIApplication.shared.windows.last?.addSubview(self)
    }
    
    func showDatePicker(_ minimumDate: Date = Date(), selectedDate: Date = Date(), datePickerMode: UIDatePicker.Mode, completion: @escaping (Any?) -> Void) {
        datePicker.isHidden = false
        picker.isHidden = true
        picker.delegate = nil
        picker.dataSource = nil
        datePicker.datePickerMode = datePickerMode
        datePicker.minimumDate = minimumDate
        datePicker.setDate(selectedDate, animated: false)
        dataBlock = completion
        frame = UIScreen.main.bounds
        UIApplication.shared.windows.last?.addSubview(self)
    }
    
    func remove(_ view: UIView?) {
        if let subViewArray = view?.subviews {
            for subView in subViewArray where subView is PickerView {
                subView.removeFromSuperview()
            }
        }
    }
}

extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contentArray.count
    }
}

extension PickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let rowInfo = contentArray[row]
        if let title = rowInfo as? String {
            return title
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedObject = contentArray[row]
    }
}
