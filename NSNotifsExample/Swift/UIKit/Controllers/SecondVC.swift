import UIKit


final class SecondVC: UIViewController {

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

	int counter = 0; ---*/

	private var counter = 0

	/*--- instantiate UILabels so we can access all 
	of it's properties and create our views ---*/

	private let counterLabel: UILabel = {
		var label = UILabel()
		label.textAlignment = .center
		label.layer.cornerCurve = .continuous
		label.layer.cornerRadius = 20
		label.layer.masksToBounds = true
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	private let hiddenLabel: UILabel = {
		let label = UILabel()
		label.text = "The power of Notifications :fr: Learn them, embrace them, and use them to make awesome stuff"
		label.font = UIFont.systemFont(ofSize: 18)
		label.alpha = 0
		label.textColor = .systemPurple
		label.textAlignment = .center
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		// call our setupUI method, yes it's called method here because it's within the scope of our class

		setupUI()

		counterLabel.text = String(counter)
		counterLabel.backgroundColor = UIColor.randomColor()

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

	override func viewDidLoad() {

		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.

		view.backgroundColor = .systemBackground

	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

		layoutUI()

	}

	private func setupUI() {

		view.addSubview(counterLabel)
		view.addSubview(hiddenLabel)

	}

	private func layoutUI() {

		let safeInsetsBottom = view.safeAreaInsets.bottom + 15

		// proper UILayout

		// gotta unwrap view first

		guard let view = view else {
			return
		}

		/*--- our dictionary which contains the views
		we want to constrain ---*/

		let views = [

			"counterLabel": counterLabel,
			"hiddenLabel": hiddenLabel,
			"superview": view

		]

		let formatCounterLabelWidth = "H:[counterLabel(==150)]"
		let formatCounterLabelHeight = "V:[counterLabel(==40)]"
		let formatCounterLabelCenterX = "V:[superview]-(<=1)-[counterLabel]"
		let formatCounterLabelCenterY = "H:[superview]-(<=1)-[counterLabel]"

		let formatLabelBottom = "V:[hiddenLabel]-\(safeInsetsBottom)-|"
		let formatLabelCenterX = "V:[superview]-(<=1)-[hiddenLabel]"
		let formatLabelLeadingTrailing = "H:|-10-[hiddenLabel]-10-|"

		let widthConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCounterLabelWidth, options: [], metrics: nil, views: views)
		let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCounterLabelHeight, options: [], metrics: nil, views: views)
		let centerXConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCounterLabelCenterX, options: .alignAllCenterX, metrics: nil, views: views)
		let centerYConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatCounterLabelCenterY, options: .alignAllCenterY, metrics: nil, views: views)

		let labelBottomConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatLabelBottom, options: [], metrics: nil, views: views)
		let labelCenterXConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatLabelCenterX, options: .alignAllCenterX, metrics: nil, views: views)
		let labelLeadingTrailingConstraint = NSLayoutConstraint.constraints(withVisualFormat: formatLabelLeadingTrailing, options: .alignAllCenterX, metrics: nil, views: views)

		view.addConstraints(widthConstraint + heightConstraint + centerXConstraint + centerYConstraint)
		view.addConstraints(labelBottomConstraint + labelCenterXConstraint + labelLeadingTrailingConstraint)

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

	}

	/*--- we use @objc because "selector" is an Objective-C concept only,
	so we need to make it visible to the Objective-C runtime ---*/

	@objc private func receiveNotification() {

		// start increasing the counter when the user is pressing the button

		counter += 1

		// cast our counter value to a string, since it's an integer

		counterLabel.text = String(counter)
		counterLabel.backgroundColor = UIColor.randomColor()

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

		UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {

			/*--- unlike Objective-C, where you need the keyword self
			to access properties, Swift has very rare few cases for it,
			and this is one of them because it's in a closure ---*/

			self.hiddenLabel.alpha = 1

		}, completion: nil)

	}

	@objc private func fadeOut() {

		UIView.animate(withDuration: 0.5, delay: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {

			self.hiddenLabel.alpha = 0

		}, completion: { finished in

			self.hiddenLabel.isHidden = true // hide our label after the animation finishes so it doesn't reappear

		})

	}

}
