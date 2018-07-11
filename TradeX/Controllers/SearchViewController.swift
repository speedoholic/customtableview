//
//  SearchViewController.swift
//  TradeX
//
//  Created by Kushal Ashok on 7/11/18.
//  Copyright © 2018 tradex. All rights reserved.
//

import UIKit

class SearchViewController: YNSearchViewController {

    fileprivate var topMargin:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if let navHeight = self.navigationController?.navigationBar.frame.size.height {
            topMargin = navHeight + UIApplication.shared.statusBarFrame.size.height
        }
        setupData()
    }
    
    func setupData() {
        let datas = realmHelper.realm().objects(Coindata.self)
        var dataArray = [Any]()
        for data in datas {
            let searchModel = Coindata()
            searchModel.quoteAsset = data.quoteAsset
            searchModel.baseAsset = data.baseAsset
            searchModel.symbol = data.symbol
            searchModel.volume = data.volume
            searchModel.high = data.high
            searchModel.low = data.low
            dataArray.append(searchModel)
        }
        
        let distinctQuoteAssets = Set(realmHelper.realm().objects(Coindata.self).value(forKey: "quoteAsset") as! [String])
        self.ynSerach.setCategories(value: Array(distinctQuoteAssets))
        self.ynSearchinit(topMargin)
        
        self.ynSearchView.delegate = self
        self.initData(database: dataArray)
        
//        self.ynSearchTextfieldView.frame.origin.y += topMargin
//        self.ynSearchView.frame.origin.y += topMargin
//        self.ynSearchView.frame.size.height -= topMargin
        
        self.ynSearchView.ynSearchListView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        if self.ynSearchView.ynSearchMainView.searchHistoryLabel != nil {
            self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SearchViewController : YNSearchDelegate {
    func performSearch(_ searchText: String) {
        self.ynSearchTextfieldView.ynSearchTextField.text = searchText
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = searchText
        self.ynSearchTextfieldView.ynSearchTextField.becomeFirstResponder()
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func ynCategoryButtonClicked(text: String) {
        performSearch(text)
    }
    
    func ynSearchHistoryButtonClicked(text: String) {
        performSearch(text)
    }
    
    func ynSearchListViewClicked(key: String) {
        print(key)
    }
    
    func ynSearchListView(_ ynSearchListView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.ynSearchView.ynSearchListView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell, let coinData = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? Coindata else {return UITableViewCell()}
            cell.quoteAssetLabel.text = coinData.quoteAsset
            cell.baseAssetLabel.text = "/"  + coinData.baseAsset
            cell.volumenLabel.text = "Vol " + coinData.volume
            cell.decimalLabel.text = coinData.high
            cell.priceLabel.text = "$ " + coinData.low
            return cell
    }
}
