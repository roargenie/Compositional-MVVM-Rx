//
//  SubjectViewController.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift


class SubjectViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 상태
    let behavior = BehaviorSubject(value: 100) // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 10) // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한번에 이벤트를 전달
    let async = AsyncSubject<Int>()
    
    var disposeBag = DisposeBag()
    var viewModel = SubjectViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
            
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // 1초 기다렸다가 검색되게끔
//            .distinctUntilChanged() // 같은 값을 받지 않음.
            .subscribe { (vc, value) in
                print("======\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
    }
    
    deinit {
        print("SubjectViewController")
    }
    
}


extension SubjectViewController {
    
    func publishSubject() {
        
        // 초기값이 없는 상태, subscribe 전/error/completed notification 이후 이벤트 무시
        // subscribe 후에 대한 이벤트는 처리됨.
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        
        publish.onCompleted()
        
        publish.onNext(6) // completed가 되고나면 방출안됨.
    }
    
    func behaviorSubject() {
        // 구독 전 가장 최근값을 emit
        
//        behavior.onNext(1)
//        behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
    }
    
    func replaySubject() {
        // BufferSize 메모리, array, 이미지
        // 무튼 너무 쓸데없이 많이 잡아두는건 좋지않다.
        
        replay.onNext(1)
        replay.onNext(2)
        replay.onNext(3)
        replay.onNext(100)
        replay.onNext(200)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(4)
        replay.onNext(5)
        replay.on(.next(6))
        
        replay.onCompleted()
        
        replay.onNext(7)
    }
    
    func asyncSubject() {
        
        async.onNext(1)
        async.onNext(2)
        async.onNext(3)
        async.onNext(100)
        async.onNext(200)
        
        async
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposeBag)
        
        async.onNext(4)
        async.onNext(5)
        async.on(.next(6))
        
        async.onCompleted()
        
        async.onNext(7)
    }
}
