//
//  RxCocoaExampleViewController.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift


class RxCocoaExampleViewController: UIViewController {
    
    @IBOutlet weak var sampleTableView: UITableView!
    @IBOutlet weak var samplePickerView: UIPickerView!
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var sampleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nickNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
        }
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    func setOperator() {
        
        Observable.repeatElement("Jack")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        // DisposeBag: 리소스 해제 관리
        // 1. 시퀀스가 끝날 때
        // 2. bind처럼 completed나 error를 방출하지 않는 경우 class deinit될 때 자동 해제
        // 3. dispose 직접 호출
        // dispose() 구독하는 것 마다 별도로 관리해야 해서 번거롭다.
        // 그래서 DisposeBag을 새롭게 할당하거나, nil을 전달.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            intervalObservable.dispose()
//            intervalObservable2.dispose()
//            intervalObservable3.dispose()
            self.disposeBag = DisposeBag()
        }
        
        let itemsA = [3.3, 2.2, 5.4, 3.6, 5.6, 7.6]
        let itemsB = [1.2, 2.1, 3.2]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        
        // TF1, TF2(Observable) -> 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty, resultSelector: { value1, value2 in
            return "이름은 \(value1)이고, 이메일은 \(value2)입니다."
        })
            .bind(to: sampleLabel.rx.text)
            .disposed(by: disposeBag)
        
        signName // UITextField
            .rx // Reactive
            .text // String?
            .orEmpty // String // 데이터의 흐름 Stream
            .map { $0.count < 4 } // Int, Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { [weak self] _ in  // bind할 객체가 없기 때문에 subscribe로 .withUnretained로도 가능
                self?.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: "ㅎㅎㅎ", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false)
            .bind(to: sampleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        
        sampleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: sampleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        sampleTableView.rx
            .modelSelected(String.self)// 모델 타입.
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: sampleLabel.rx.text)
//            .subscribe { value in // Observer
//                print(value) // 성공
//            } onError: { error in
//                print(error) // 실패
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            }
            .disposed(by: disposeBag)
        
    }
    
    func setPickerView() {
        
        let items = Observable.just([
                "Movie",
                "Animation",
                "Drama",
                "ETC"
            ])
     
        items
            .bind(to: samplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        samplePickerView.rx
            .modelSelected(String.self)
            .map { $0.description }
            .bind(to: sampleLabel.rx.text)
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
        
    }
    
}
