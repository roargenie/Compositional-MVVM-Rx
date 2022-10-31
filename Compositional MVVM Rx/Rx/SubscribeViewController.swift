//
//  SubscribeViewController.swift
//  Compositional MVVM Rx
//
//  Created by 이명진 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, indexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testRxAlamofire()
        testRxDataSource()
        bindData()
    }
    
    func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "Title 1", items: [1, 2, 3]),
            SectionModel(model: "Title 2", items: [1, 2, 3]),
            SectionModel(model: "Title 3", items: [1, 2, 3])
        ])
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
    }
    
    func testRxAlamofire() {
        // Success와 Error => <Single> 드라이버 객체 존재함.
        let url = APIKey.searchURL + "apple"
        
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value.results[0].likes)
            })
            .disposed(by: disposeBag)
    }
    
    func bindData() {
        
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
            .skip(3)
            .filter { $0 % 2 == 0 }
            .map { $0 * 2 }
            .subscribe { value in
                
            }
            .disposed(by: disposeBag)
        
        let sample = button.rx.tap
        
            sample
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 네트워크 통신이나 파일 다운로드 중 백그라운드 작업
        button.rx.tap
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // bind: Subscribe, MainScheduler, Error X
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // operator로 데이터의 stream 조작
        button.rx.tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // driver traits: bind + stream 공유(리소스 낭비 방지, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
    }
}
