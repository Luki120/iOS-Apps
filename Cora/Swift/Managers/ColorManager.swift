import UIKit


final class ColorManager {

    static let sharedInstance = ColorManager()

    var accentColor:UIColor = .green

    init() {}

    func loadInitialAccentColor() {

        do {

            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: accentColor, requiringSecureCoding: false)
            let defaultAccentColor:[String:Any] = ["accentColor": encodedData]
            UserDefaults.standard.register(defaults: defaultAccentColor)

        }

        catch {

            print("handling the fucking error so this shit lets me compile")
            return

        }

    }

}
