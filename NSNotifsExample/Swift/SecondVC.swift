import UIKit


class SecondVC: UIViewController {

	/*--- these look like variables but they really aren't.
	Since they are declared within the context of our class
	they are called properties ---*/

	/*--- Swift has something cool called type inference,
	which means that you don't need to specify the data type
	for your constants, properties or variables, Swift is
	smart and will assign it's data type properly, but
	you can still do it manually, e.g, counter is an int
	so it'd be something like this:

	var counter:Int = 0

	however in Objective-C this is required,
	so it'd be like this:

	int counter = 0;

	---*/

	var counter = 0

	/*--- instantiate UITextField and UILabel so we can access all 
	of it's properties and create our views ---*/

	var textField = UITextField()
	var hiddenLabel = UILabel()

	override func viewDidLoad() {

		super.viewDidLoad() // call the original implementation of viewDidLoad()

		// customize our navigation bar color

		/*--- the ? means navigationController is an optional,
		meaning it couldve a nil value, so in this case
		this is called optional chaining, which is safer than
		force unwrapping (using a ! instead), because if it were
		to be nil and we force unwrap, the app would crash ---*/

		// nav bar color

		navigationController?.navigationBar.barTintColor = UIColor.black
		navigationController?.navigationBar.isTranslucent = false

		// get rid of the border (the gray line)

		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		navigationController?.navigationBar.shadowImage = UIImage()

		// Create our text field

		textField = UITextField()
		textField.isEnabled = false
		textField.placeholder = ":peek:"
		textField.textAlignment = .center
		textField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(textField)

		// create our label

		hiddenLabel = UILabel()
		hiddenLabel.text = "The power of Notifications :fr: Learn them, embrace them, and use them to make awesome stuff"
		hiddenLabel.font = UIFont.systemFont(ofSize:18)
		hiddenLabel.alpha = 0
		hiddenLabel.textColor = .systemPurple
		hiddenLabel.textAlignment = .center
		hiddenLabel.numberOfLines = 0
		hiddenLabel.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(hiddenLabel)

		setupLayout() // call our setupLayout function

		/*--- create notifications observers, aka the magic :fr:
		observers are listeners, they'll be waiting and listening in this case
		for the notification called "fireNotificationDone". Once a notification 
		with that name fires, the observers will tell self to call the receiveNotification
		function where our fancy code will get executed ---*/

		/*--- we remove ourselves as the observer to prevent further
		notifications from being sent after the object gets deallocated ---*/

		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: Notification.Name("fireNotificationDone"), object: nil)

	}

	private func setupLayout() {

		// proper UILayout

		/*--- our dictionary which contains the views
		we want to constrain ---*/

		let views = [
		
			"textField": textField,
			"superview": self.view!
		
		]

		/*--- Understanding Visual Format Language syntax:

		H: (Horizontal) // horizontal constraints
		V: (Vertical) // vertical constraints
		| (pipe) // superview
		- (dash) // standard spacing (generally 8-10 points)
		[] (brackets) // pass the name of our view
		() (parentheses) // pass the size of the view
		== equal widths // can be omitted
		-16- non standard spacing (16 points, can be anything you want)
		<= less than or equal to
		>= greater than or equal to
		@250 priority of the constraint // can have any value between 0 and 1000 ---*/

		// credits: https://stackoverflow.com/a/54049893

		let formatWidth = "H:[textField(==150)]"
		let formatHeight = "V:[textField(==40)]"
		let formatCenterX = "V:[superview]-(<=1)-[textField]"
		let formatCenterY = "H:[superview]-(<=1)-[textField]"

		let widthConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatWidth, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
		let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatHeight, options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
		let centerXConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCenterX, options: .alignAllCenterX, metrics: nil, views: views)
		let centerYConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCenterY, options: .alignAllCenterY, metrics: nil, views: views)

		NSLayoutConstraint.activate(widthConstraint)
		NSLayoutConstraint.activate(heightConstraint)
		NSLayoutConstraint.activate(centerXConstraint)
		NSLayoutConstraint.activate(centerYConstraint)

		hiddenLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		hiddenLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant : -15).isActive = true
		hiddenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant : 10).isActive = true
		hiddenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -10).isActive = true

	}

	// random color function
	// https://stackoverflow.com/questions/33882130/button-that-will-generate-a-random-background-color-xcode-swift

	private func randomCGFloat() -> CGFloat {

		return CGFloat(arc4random()) / CGFloat(UInt32.max)

	}

	/*--- we use @objc because "selector" is an Objective-C concept only,
	so we need to make it visible to the Objective-C runtime ---*/

	@objc private func receiveNotification() {

		// start increasing the counter when the user is pressing the button

		counter += 1

		let r = randomCGFloat()
		let g = randomCGFloat()
		let b = randomCGFloat()

		// cast our counter value to a string, since it's an integer

		self.textField.text = String(counter)
		self.textField.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)

		/*--- start one second timers when the conditions are met to wait 
		and then start cross dissolving the labels' alpha from 0 to 1 and viceversa ---*/

		if counter == 14 {

			Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fadeIn), userInfo: nil, repeats: false)

		}

		else if counter == 15 {

			Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fadeOut), userInfo: nil, repeats: false)

		}

	}

	@objc private func fadeIn() {

		UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in

			self.hiddenLabel.alpha = 1

		}, completion: nil)

	}

	@objc private func fadeOut() {

		UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in

			self.hiddenLabel.alpha = 0

		}, completion: {(finished)-> Void in // this a closure I think, something I haven't learned about yet

			self.hiddenLabel.isHidden = true // hide our label after the animation finishes so it doesn't reappear

		})

	}

}
