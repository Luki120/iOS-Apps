import UIKit


final class AuroraVC: UIViewController {

	private let lengthSlider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 10
		slider.maximumValue = 25
		slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
		return slider
	}()

	private lazy var settingsButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "gear"), for: .normal)
		button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
		return button
	}()

	private var verticalStackView: UIStackView!
	private var horizontalStackView: UIStackView!
	private var regenerateButton: UIButton!
	private var copyButton: UIButton!
	private var randomLabel: UILabel!
	private var sliderValueLabel: UILabel!

	private let numbersAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemTeal]
	private let symbolsAttribute = [NSAttributedString.Key.foregroundColor: UIColor.salmonColor]

	// MARK: Lifecycle

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init() {
		super.init(nibName: nil, bundle: nil)
		setupUI()
		NotificationCenter.default.addObserver(self, selector: #selector(setAttributedString), name: Notification.Name("switchValueChanged"), object: nil)
	}

	deinit { NotificationCenter.default.removeObserver(self) }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		view.backgroundColor = .systemBackground
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layoutUI()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		lengthSlider.value = UserDefaults.standard.float(forKey: "sliderValue")
		sliderValueLabel.text = "\(Int(lengthSlider.value))"

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
			self.setAttributedString()
		}
	}

	private func setupUI() {

		verticalStackView = createStackView(withAxis: .vertical)
		verticalStackView.translatesAutoresizingMaskIntoConstraints = false
		horizontalStackView = createStackView(withAxis: .horizontal)

		regenerateButton = createButton(withTitle:"Regenerate password", forSelector: #selector(didTapRegenerateButton))
		copyButton = createButton(withTitle: "Copy password", forSelector: #selector(didTapCopyButton))

		randomLabel = createLabel(withFontSize: 22)
		randomLabel.adjustsFontSizeToFitWidth = true

		sliderValueLabel = createLabel(withFontSize: 10)
		sliderValueLabel.textColor = .gray

		view.addSubview(verticalStackView)
		verticalStackView.addArrangedSubview(randomLabel)
		verticalStackView.addArrangedSubview(regenerateButton)
		verticalStackView.addArrangedSubview(copyButton)
		verticalStackView.addArrangedSubview(horizontalStackView)
		horizontalStackView.addArrangedSubview(lengthSlider)
		horizontalStackView.addArrangedSubview(sliderValueLabel)

		verticalStackView.setCustomSpacing(5, after: regenerateButton)

		let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
		navigationItem.rightBarButtonItem = settingsButtonItem

	}

	private func layoutUI() {

		let guide = view.safeAreaLayoutGuide

		verticalStackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20).isActive = true
		verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		setupSizeConstraintsForView(regenerateButton)
		setupSizeConstraintsForView(copyButton)

	}

	private func randomString(length: Int) -> String {

		var characters = "abcdefghijklmnopqrstuvwxyz"

		let switchState1 = UserDefaults.standard.bool(forKey: "switchState1")
		let switchState2 = UserDefaults.standard.bool(forKey: "switchState2")
		let switchState3 = UserDefaults.standard.bool(forKey: "switchState3")

		let numbers = "0123456789"
		let specialCharacters = "!@#$%^&*()_+-=[]{}|;':,./<>?`~"
		let uppercaseCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

		if switchState1 { characters += uppercaseCharacters }
		if switchState2 { characters += numbers }
		if switchState3 { characters += specialCharacters }
		else if !switchState1 && !switchState2 && !switchState3 { characters = "abcdefghijklmnopqrstuvwxyz" }

		return String((0..<length).map { _ in characters.randomElement() ?? "c" })

	}

	// MARK: Selectors

	@objc private func didTapRegenerateButton() { setAttributedString() }
	@objc private func didTapCopyButton() { UIPasteboard.general.string = randomLabel.text }

	@objc private func sliderValueDidChange() {

		setAttributedString()
		sliderValueLabel.text = "\(Int(lengthSlider.value))"
		UserDefaults.standard.set((lengthSlider.value), forKey: "sliderValue")

	}

	@objc private func didTapSettingsButton() {

		let vc = SettingsVC()
		present(vc, animated: true, completion: nil)

	}

	// MARK: Attributed String

	private func findRangesInString(_ string: String, withPattern pattern: String) -> [NSRange] {
		let nsString = string as NSString
		let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
		let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, nsString.length))
		return matches?.map { $0.range } ?? []
	}

	private func attributedString(
		string: String,
		numbersAttribute: [NSAttributedString.Key : Any],
		symbolsAttribute: [NSAttributedString.Key : Any]
	) -> NSAttributedString {

		let symbolRanges = findRangesInString(string, withPattern: "[!@#$%^&*()_+-=\\[\\\\\\]{}|;':,./<>?`~]+")
		let numberRanges = findRangesInString(string, withPattern: "[0-9]+")

		let attributedString = NSMutableAttributedString(string: string)

		for range in symbolRanges {
			attributedString.addAttributes(symbolsAttribute, range: range)
		}
		for range in numberRanges {
			attributedString.addAttributes(numbersAttribute, range: range)
		}
		return attributedString
	}

	@objc private func setAttributedString() {
  		let crossDissolve = CATransition()
		crossDissolve.type = CATransitionType.fade
		crossDissolve.duration = 0.5
		crossDissolve.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		randomLabel.layer.add(crossDissolve, forKey: nil)

		randomLabel.attributedText = attributedString(
			string: randomString(length: Int(lengthSlider.value)),
			numbersAttribute: numbersAttribute,
			symbolsAttribute: symbolsAttribute
		)
	}

	// MARK: Reusable

	private func createButton(withTitle title: String, forSelector selector: Selector) -> UIButton {
		let button = UIButton()
		button.backgroundColor = UIColor.auroraColor
		button.setTitle(title, for: .normal)
		button.setTitleColor(.label, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		button.addTarget(self, action: selector, for: .touchUpInside)
		button.layer.cornerCurve = .continuous
		button.layer.cornerRadius = 22
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}

	private func createLabel(withFontSize size: CGFloat) -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: size)
		label.textAlignment = .center
		return label
	}

	private func createStackView(withAxis axis: NSLayoutConstraint.Axis) -> UIStackView {
		let stackView = UIStackView()
		stackView.axis = axis
		stackView.spacing = 10
		stackView.distribution = .fill
		return stackView
	}

	private func setupSizeConstraintsForView(_ view: UIView) {
		view.widthAnchor.constraint(equalToConstant: 220).isActive = true
		view.heightAnchor.constraint(equalToConstant: 44).isActive = true
	}

}

extension UIColor {
	static let auroraColor = UIColor(red: 0.74, green: 0.78, blue: 0.98, alpha: 1.0)
	static let salmonColor = UIColor(red: 1.0, green: 0.55, blue: 0.51, alpha: 1.0)
}
