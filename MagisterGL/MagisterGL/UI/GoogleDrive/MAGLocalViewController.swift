import UIKit

class MAGLocalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let cellReuseIdentifier = "kLocalReuseCellID"
  private var filesCount: Int = 0
  private var localFileManager: MAGLocalFileManager = MAGLocalFileManager()
  
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    filesCount = Int(localFileManager.findFilesInLocalDirectory())
    
    
    
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    
    
  }
  
  // MARK: TableView
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return filesCount
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    // create a new cell if needed or reuse an old one
    let cell : UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
    
    cell.textLabel?.text = localFileManager.filesnameArray[indexPath.row].components(separatedBy: "/").last;
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath)
  {
    
  }

}
