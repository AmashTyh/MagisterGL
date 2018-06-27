import UIKit
import GoogleAPIClientForREST

protocol MAGGoogleTableViewControllerDelegate
{
  func savedFile(filePath: NSString)
}

class MAGGoogleTableViewController: UIViewController,
                                    UITableViewDelegate,
                                    UITableViewDataSource,
                                    GIDSignInDelegate,
                                    GIDSignInUIDelegate
{
  
  var completion : ((String) -> Void)?
  
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
  let cellReuseIdentifier = "kReuseCellID"
  var loginPassed: Bool = false
  var provider: MAGGoogleDriveProvider = MAGGoogleDriveProvider()
  var delegate: MAGGoogleTableViewControllerDelegate?
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var signInButton: GIDSignInButton!
  
  @IBAction func update(_ sender: Any)
  {
    activityIndicator.startAnimating()
    provider.listFiles(completionBlock: {
      (success: Bool) -> Void in
      self.tableView.reloadData()
      self.activityIndicator.stopAnimating()
//      print(self.provider.filesDictionary)
    })
  }
  
  @IBAction func closeVC(_ sender: Any)
  {
    self.dismiss(animated: true,
                 completion: nil)
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Configure Google Sign-in.
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveReadonly]
    GIDSignIn.sharedInstance().signInSilently()
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    //activityIndicator.hidesWhenStopped = true
    activityIndicator.color = UIColor.black
    view.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
    view.addConstraint(horizontalConstraint)
    
    let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
    view.addConstraint(verticalConstraint)
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    
    if (!loginPassed)
    {
      self.tableView.isHidden = true
      self.signInButton.isHidden = false
    }
    else
    {
      self.tableView.isHidden = false
      self.signInButton.isHidden = true
      self.update(self)
    }
  }
  
  // MARK: Google Drive
  func sign(_ signIn: GIDSignIn!,
            didSignInFor user: GIDGoogleUser!,
            withError error: Error!)
  {
    if let error = error
    {
      showAlert(title: "Authentication Error",
                message: error.localizedDescription)
      provider.service.authorizer = nil
    }
    else
    {
      loginPassed = true
      self.signInButton.isHidden = true
      self.tableView.isHidden = false
      provider.service.authorizer =  user.authentication.fetcherAuthorizer()
      self.update(self)
    }
  }
  
  // Helper for showing an alert
  func showAlert(title : String,
                 message: String)
  {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "OK",
                           style: UIAlertActionStyle.default,
                           handler: {
                            (alert: UIAlertAction!) in self.dismiss(animated: true,
                                                                    completion: nil)
    }
    )
    alert.addAction(ok)
    present(alert, animated: true,
            completion: nil)
  }
  
  
  // MARK: TableView
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int
  {
    return provider.filesDictionary.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // create a new cell if needed or reuse an old one
    let cell : UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    
    // set the text from the data model
    //print(Array(self.provider.filesDictionary.keys)[indexPath.row])
    cell.textLabel?.text = Array(provider.filesDictionary.keys)[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    activityIndicator.startAnimating()
    let filename = Array(provider.filesDictionary.keys)[indexPath.row]
    let fileId = provider.filesDictionary[filename]
    
    provider.downloadFile(withFileID: fileId!,
                          fileName: filename,
                          completionBlock: {_,filePath  in
                            
                            self.activityIndicator.stopAnimating()
                            if filePath != nil
                            {
                              self.completion!(filePath!)
                            }
                            self.dismiss(animated: true,
                                         completion: nil)
    })
  }

}
