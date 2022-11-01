//
//  ValidationViewModel.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    struct Input {
        let text: ControlProperty<String?> // textField.rx.text
        let tap: ControlEvent<Void> // button.rx.tap
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share()
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}







