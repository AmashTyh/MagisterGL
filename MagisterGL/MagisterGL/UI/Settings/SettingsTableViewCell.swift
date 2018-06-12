import UIKit

protocol SettingsTableViewCellDelegate: class
{
  func updateSettings(value: Bool, labelText: String)
}

class SettingsTableViewCell: UITableViewCell
{
  weak var delegate: SettingsTableViewCellDelegate?
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var settingsSwitcher: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureWithSettings(switcher: Bool, name: String) {
    self.titleLabel.text = name
    self.settingsSwitcher.setOn(switcher, animated: false)
  }
  
  @IBAction func updateValues(_ sender: UISwitch) {
    delegate?.updateSettings(value: sender.isOn, labelText: self.titleLabel.text!)
  }
}
