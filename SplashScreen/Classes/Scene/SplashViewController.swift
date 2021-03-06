//
//  SplashViewController.swift
//  SmartMic
//
//  Created by Marcel Mendes Filho on 09/08/19.
//  Copyright (c) 2019 Marcel Mendes Filho. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SplashDisplayLogic: class
{
    func updateSplash()
    func showAlert(title: String, message: String, buttonLabel: String)
    func dismissSplashScreen()
}

open class SplashViewController: UIViewController, SplashDisplayLogic
{
    private var interactor: SplashBusinessLogic?
    private var router: (NSObjectProtocol & SplashRoutingLogic & SplashDataPassing)?
    
    // splash screen drivers
    public var app = ""
    public var version = ""
    public var key = ""
    public var localization = ""
    
    // splash screen remote config
    public var hostName = ""
    public var retrieveSplashEndpoint = ""
    public var serverHTTPHeader = ""
    
    public var imageHostName = ""
    public var imagePath = ""

    // MARK: Object lifecycle
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup

    private func setup()
    {
        let viewController = self
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
    // MARK: View lifecycle
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        setupUI()
        interactor?.getSplash(app: app,
                              version: version,
                              key: key,
                              localization: localization,
                              hostName: hostName,
                              splashEndpoint: retrieveSplashEndpoint,
                              httpHeader: serverHTTPHeader,
                              imageHostName: imageHostName,
                              imagePath: imagePath)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func tappedContinue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Support methods
    func setupUI(){
        tableView.isHidden = true
        loading.startAnimating()
        loading.isHidden = false
        continueButton.isHidden = true
        continueButton.layer.cornerRadius = 4
        continueButton.layer.masksToBounds = true
    }
    
    func updateSplash() {
        DispatchQueue.main.async {
            self.loading.stopAnimating()
            self.loading.isHidden = true
            
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
            self.continueButton.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String, buttonLabel: String) {
        DispatchQueue.main.async {
            self.loading.stopAnimating()
            self.loading.isHidden = true

            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: buttonLabel, style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func dismissSplashScreen(){
        DispatchQueue.main.async{
            self.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: TablewView delegates and datasource
extension SplashViewController: UITableViewDataSource, UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 50
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        switch section{
        case 0:
            if let title = self.router?.dataStore?.splash?.main_title{
                let headerLabel = Worker.getHeaderViewLabel(width: tableView.bounds.size.width)
                headerLabel.textAlignment = .center
                headerLabel.text = title
                return headerLabel
            } else {
                return nil
            }
        default:
            return nil
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return router?.dataStore?.splash?.splashItems.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SplashCell", for: indexPath) as? SplashTableViewCell{
            if let splashItem = router?.dataStore?.splash?.splashItems[index]{
                cell.title.text = splashItem.title
                cell.detail.text = splashItem.text
                
                if let iconImages = router?.dataStore?.splashImages{
                    if iconImages.indices.contains(index){
                        cell.icon.image = iconImages[index]
                    }
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
}
