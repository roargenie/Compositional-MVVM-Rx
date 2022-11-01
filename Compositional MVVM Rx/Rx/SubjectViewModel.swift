//
//  SubjectViewModel.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

// associated type == generic과 유사
protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel: CommonViewModel {
    
    var contactData: [Contact] = [
        Contact(name: "Metaverse Jack", age: 23, number: "01012341234"),
        Contact(name: "Hue", age: 21, number: "01012342345"),
        Contact(name: "Real Jack", age: 19, number: "01012342346"),
        Contact(name: "Brady", age: 29, number: "01012342345")
    ]
    
//    var list = PublishSubject<[Contact]>()
    var list = PublishRelay<[Contact]>()
    
    func fetchData() {
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func resetData() {
//        list.onNext([])
        list.accept([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        contactData.append(new)
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
//        list.onNext(result)
        list.accept(result)
        
    }
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText
            .orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // 1초 기다렸다가 검색되게끔
            .distinctUntilChanged() // 같은 값을 받지 않음.
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
}
