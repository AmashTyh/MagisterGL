import UIKit

protocol SettingsViewControllerDelegate: class
{
  func updateSettings(isSurfaceEnabled: Bool,
                      isChartsEnabled: Bool)
}

class SettingsViewController: UIViewController,
                              UITableViewDataSource,
                              UITableViewDelegate,
                              SettingsTableViewCellDelegate,
                              UIPopoverPresentationControllerDelegate
{
  weak var delegate: SettingsViewControllerDelegate?
  private var cellID: String = "kReuseSettingsCellID"
  var isSurfaceEnabled: Bool = true
  var isChartsEnabled: Bool = true
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func saveTouch(_ sender: Any)
  {
    self.delegate?.updateSettings(isSurfaceEnabled: isSurfaceEnabled, isChartsEnabled: isChartsEnabled)
    self.dismiss(animated: true, completion: nil)
  }
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.tableView.register(UINib.init(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return 2
  }
  
  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                             for: indexPath) as! SettingsTableViewCell
    if (indexPath.row == 0) {
      cell.configureWithSettings(switcher: isSurfaceEnabled, name: "Receivers Surface")
    }
    else {
      cell.configureWithSettings(switcher: isChartsEnabled, name: "Charts")
    }
    cell.delegate = self
    return cell
  }
  
  // MARK: SettingsTableViewCellDelegate
  func updateSettings(value: Bool, labelText: String)
  {
    if labelText == "Receivers Surface" {
      isSurfaceEnabled = value
    }
    else if labelText == "Charts" {
      isChartsEnabled = value
    }
    //self.delegate?.updateSettings(isSurfaceEnabled: isSurfaceEnabled, isChartsEnabled: isChartsEnabled)
  }
}
