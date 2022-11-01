//
//  ValidationViewController.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/27.
//

import UIKit
import RxCocoa
import RxSwift


class ValidationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameValidationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        observableVSSubject()
    }
    
    func bind() {
        
        // MARK: - After
        
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap) // ViewModel로 보내줌
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(nameValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, nameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, nameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
                vc.stepButton.isEnabled = value ? true : false
//                vc.nameValidationLabel.isHidden = value ? false : true
//                vc.nameValidationLabel.text = value ? "8자 이상입니다.!!!" : ""
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
        // MARK: - Before
        
        viewModel.validText // Output
            .asDriver()
            .drive(nameValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text // String? (Input)
            .orEmpty // String
            .map { $0.count >= 8 } // Bool
            .share()

        validation
            .bind(to: stepButton.rx.isEnabled, nameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)

        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
                vc.stepButton.isEnabled = value ? true : false
//                vc.nameValidationLabel.isHidden = value ? false : true
//                vc.nameValidationLabel.text = value ? "8자 이상입니다.!!!" : ""
            }
            .disposed(by: disposeBag)
        
        stepButton.rx.tap // Input
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
    }
    
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
        
        testA
            .drive(nameValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
    }
    
    
}
