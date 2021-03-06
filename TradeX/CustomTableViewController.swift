//
//  CustomTableViewController.swift
//  
//
//  Created by Kushal Ashok on 7/10/18.
//

import UIKit
import Alamofire

class CustomTableViewController: UITableViewController, Requestable {

    // MARK: - Properties
    
    fileprivate var coinsArray = [Coindata]()
    fileprivate var distinctQuoteAssets = Set<String>()
    fileprivate var tabBar: UITabBar?
    fileprivate var indicatorView: UIActivityIndicatorView?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.title = HOMEPAGETITLE
        self.tableView.register(UINib(nibName: String(describing:CustomTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:CustomTableViewCell.self))
        initIndicatorView()
        initRefreshControl()
        initTabBar()
        getData()
    }
    
    func initIndicatorView() {
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView?.frame = self.view.frame
        if let indicator = indicatorView {
            self.view.addSubview(indicator)
        }
    }
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        refreshControl?.attributedTitle = NSAttributedString(string: PULLTOREFRESH)
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
    }
    
    func initTabBar() {
        var tabFrame = self.tableView.bounds
        tabFrame.size.height = TABBARHEIGHT
        tabBar = UITabBar(frame: tabFrame)
        tabBar?.delegate = self
        tabBar?.enableDarkMode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Manipulation
    
    /// Makes service request to get data from server
    @objc func getData() {
        indicatorView?.startAnimating()
        _ = setupNetworkComponentWith(netapi: .getData(), mapType: LiveData.self, mappedObjectHandle: { (respone) in
            self.updateTabAndData()
        }, moreInfo: { (message) in
            switch message {
            case .success:
                print(DEFAULTSUCCESS)
            case .fail:
                print(DEFAULTERROR)
                UIAlertHelper.showAlertWithTitle(DEFAULTERROR, message: INTERNETERRORMESSAGE, completionBlock: nil, onController: self)
            }
            self.refreshControl?.endRefreshing()
            self.indicatorView?.stopAnimating()
        })
    }
    
    func updateTabAndData() {
        self.distinctQuoteAssets = Set(realmHelper.realm().objects(Coindata.self).value(forKey: QUOTEASSETKEY) as! [String])
        guard let tabItems = self.getTabBarItems() else {return}
        self.tabBar?.setItems(tabItems, animated: false)
        if let tabItem = tabBar?.items?.first {
            tabBar(self.tabBar!, didSelect: tabItem)
            self.tabBar?.selectedItem = tabItem
        }
    }
    
    func getTabBarItems() -> [UITabBarItem]? {
        let tabItems = distinctQuoteAssets.map { (quoteString) -> UITabBarItem in
            let tabItem = UITabBarItem(title: quoteString, image: nil, tag: 0)
            tabItem.enableDarkMode()
            return tabItem
        }
        return tabItems
    }
    
    
    func getFilteredCoinData(_ quote: String?) -> [Coindata]? {
        guard let quote = quote, let results = realmHelper.getObjects(Coindata.self, filterString: getFilterString(QUOTEASSETKEY, value: quote)) else {
            return nil
        }
        return Array(results)
    }
    
    func getFilterString(_ key: String, value: String) -> String {
        return "\(key) = '\(value)'"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:CustomTableViewCell.self), for: indexPath) as? CustomTableViewCell, indexPath.row < coinsArray.count else {return UITableViewCell()}
        let coinData = coinsArray[indexPath.row]
        cell.quoteAssetLabel.text = coinData.quoteAsset
        cell.baseAssetLabel.text = "/"  + coinData.baseAsset
        cell.volumeLabel.text = "Vol " + coinData.volume
        cell.decimalLabel.text = coinData.high
        cell.priceLabel.text = "$ " + coinData.low
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tabBar
    }
    
     override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TABBARHEIGHT
    }
    
    // MARK: - User Actions
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        let searchController = SearchViewController()
        searchController.categories = Array(distinctQuoteAssets)
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}

// MARK: - Tab bar delegate

extension CustomTableViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let filteredItems = getFilteredCoinData(item.title) else {return}
        self.coinsArray = filteredItems
        self.tableView.reloadData()
    }
}

