//
//  ViewController.swift
//  fiber-calculator
//
//  Created by Vu Manh Thang on 2019/08/24.
//  Copyright © 2019 Vu Manh Thang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var diameterTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    let disposeBag = DisposeBag()
    let ERR_RESULT = "E"
    
    let formula = "(diameter * 3.14 / 1000 + 0.02) * (length / 1000 + 0.4) *  unitPrice + length * 0.15 / 1000 + 0.2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaLabel.text = formula
        bind()
    }

    func bind() {
        Observable.combineLatest(
            diameterTextField.rx.text,
            lengthTextField.rx.text,
            unitPriceTextField.rx.text
        )
        .map {[unowned self] diameterStr, lengthStr, unitPriceStr -> String? in
            guard let diameterStr = diameterStr, let lengthStr = lengthStr, let unitPriceStr = unitPriceStr else { return self.ERR_RESULT }
            guard let diameter = Double(diameterStr), let length = Double(lengthStr), let unitPrice = Double(unitPriceStr) else { return self.ERR_RESULT }
            
            let dict = [
                "diameter": diameter,
                "length": length,
                "unitPrice": unitPrice
            ]
            guard let result = self.formula.expression.expressionValue(with: dict, context: nil) as? Double else { return self.ERR_RESULT }
            
            return String(result)
        }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag);
    }

    @IBAction func clear(_ sender: Any) {
        diameterTextField.text = nil
        diameterTextField.sendActions(for: .allEditingEvents)
        lengthTextField.text = nil
        lengthTextField.sendActions(for: .allEditingEvents)
        unitPriceTextField.text = nil
        unitPriceTextField.sendActions(for: .allEditingEvents)
    }
}

extension String {
    var expression: NSExpression {
        return NSExpression(format: self)
    }
}
