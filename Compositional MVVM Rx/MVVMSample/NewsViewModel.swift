//
//  NewsViewModel.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa


class NewsViewModel {
    
    //var pageNumber: CObservable<String> = CObservable("3000")
//    var pageNumber = BehaviorSubject<String>(value: "3,000")
    var pageNumber = BehaviorRelay(value: "3000")
    
    //var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
//    var sample = BehaviorSubject(value: News.items)
    var sample = BehaviorRelay(value: News.items)
    
    func changePageNumberFormat(text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
//        pageNumber.value = result
//        pageNumber.onNext(result)
        pageNumber.accept(result)
    }
    
    func resetSample() {
//        sample.value = []
//        sample.onNext([])
        sample.accept([])
    }
    
    func loadSample() {
//        sample.value = News.items
//        sample.onNext(News.items)
        sample.accept(News.items)
    }
}




