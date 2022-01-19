import UIKit


final class AuroraVC: UIViewController {

	private let verticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private let horizontalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 10
		stackView.distribution = .fill
		return stackView
	}()

	private var randomLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 22)
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let regenerateButton: UIButton = {
		let button = UIButton()
		button.setTitle("Regenerate password", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		button.addTarget(self, action: #selector(didTapRegenerateButton), for: .touchUpInside)
		button.layer.cornerCurve = .continuous
		button.layer.cornerRadius = 22
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private let copyButton: UIButton = {
		let button = UIButton()
		button.setTitle("Copy password", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18)
		button.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
		button.layer.cornerCurve = .continuous
		button.layer.cornerRadius = 22
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	private let lengthSlider: UISlider = {
		let slider = UISlider()
		slider.minimumValue = 0
		slider.maximumValue = 25
		slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
		return slider
	}()

	private let sliderValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 10)
		label.textColor = .gray
		label.textAlignment = .center
		return label
	}()

	private let settingsButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "gear"), for: .normal)
		return button
	}()

	required init?(coder aDecoder: NSCoder) {

		super.init(coder: aDecoder)

	}

	init() {

		super.init(nibName: nil, bundle: nil)

		setupUI()

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

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		lengthSlider.value = UserDefaults.standard.float(forKey: "sliderValue")

		self.randomLabel.text = self.randomString(length: Int(lengthSlider.value))
		sliderValueLabel.text = "\(Int(lengthSlider.value))"

	}

	private func setupUI() {

		view.addSubview(verticalStackView)
		verticalStackView.addArrangedSubview(randomLabel)
		verticalStackView.addArrangedSubview(regenerateButton)
		verticalStackView.addArrangedSubview(copyButton)
		verticalStackView.addArrangedSubview(horizontalStackView)
		horizontalStackView.addArrangedSubview(lengthSlider)
		horizontalStackView.addArrangedSubview(sliderValueLabel)

		verticalStackView.setCustomSpacing(5, after: regenerateButton)

		settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)

		view.addSubview(settingsButton)

		let settingsButtonItem = UIBarButtonItem(customView: settingsButton)
		navigationItem.rightBarButtonItem = settingsButtonItem

		regenerateButton.backgroundColor = ColorManager.sharedInstance.setAccentColor()
		copyButton.backgroundColor = ColorManager.sharedInstance.setAccentColor()

	}

	private func layoutUI() {

		let guide = view.safeAreaLayoutGuide

		verticalStackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20).isActive = true
		verticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		verticalStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true

 		regenerateButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
		regenerateButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

		copyButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
		copyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

	}

	private func randomString(length: Int) -> String {

		var characters = "abcdefghijklmnopqrstuvwxyz"

		let switchState = UserDefaults.standard.bool(forKey: "switchState")
		let switchState1 = UserDefaults.standard.bool(forKey: "switchState1")
		let switchState2 = UserDefaults.standard.bool(forKey: "switchState2")
		let switchState3 = UserDefaults.standard.bool(forKey: "switchState3")
		let switchState4 = UserDefaults.standard.bool(forKey: "switchState4")
		let switchState5 = UserDefaults.standard.bool(forKey: "switchState5")

		if switchState { characters += "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }

		if switchState1 { characters += "0123456789" }

		if switchState2 { characters += "!¡@·#$~%&/()=?¿[]{}-,.;:_+*<>|" }

		if switchState3 { characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }

		if switchState4 { characters = "0123456789" }

		if switchState5 { characters = "!¡@·#$~%&/()=?¿[]{}-,.;:_+*<>|" }

		return String((0..<length).map { _ in characters.randomElement() ?? "c" })

	}

	@objc private func didTapRegenerateButton() {

  		let crossDissolve = CATransition()
		crossDissolve.type = CATransitionType.fade
		crossDissolve.duration = 0.5
		crossDissolve.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		randomLabel.layer.add(crossDissolve, forKey: CATransitionType.fade.rawValue)

		randomLabel.text = randomString(length: Int(lengthSlider.value))

		view.layoutIfNeeded()

	}

	@objc private func didTapCopyButton() {

 		UIPasteboard.general.string = randomLabel.text

	}

	@objc private func sliderValueDidChange() {

		randomLabel.text = randomString(length: Int(lengthSlider.value))
		sliderValueLabel.text = "\(Int(lengthSlider.value))"

		UserDefaults.standard.set((lengthSlider.value), forKey: "sliderValue")

	}

	@objc private func didTapSettingsButton() {

		let vc = SettingsVC()
		present(vc, animated: true, completion: nil)

	}

}
