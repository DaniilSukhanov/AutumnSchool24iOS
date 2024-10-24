import UIKit
import Lottie

final class AnimationsViewController: UIViewController {
    
    private struct Constants {
        static let animationNames = ["animation1", "animation2", "animation3"]
        static let initialAnimationIndex = 0
        static let buttonDimension: CGFloat = 60
        static let buttonInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        static let playPausePointSize: CGFloat = 40
        static let controlButtonPointSize: CGFloat = 30
        static let sliderMinValue: Float = 0.5
        static let sliderMaxValue: Float = 2.0
        static let sliderInitialValue: Float = 1.0
        static let horizontalStackSpacing: CGFloat = 8
        static let verticalStackSpacing: CGFloat = 65
        static let controlButtonStackSpacing: CGFloat = 5
        static let controlsContainerStackSpacing: CGFloat = 10
        static let animationInfoStackSpacing: CGFloat = 8
        static let timecodeInitial = "0:00"
    }
    
    var currentAnimationIndex: Int = 0
    
    private lazy var createConfigurationButton: (UIImage, CGFloat) -> UIButton = { image, pointSize in
        var config = UIButton.Configuration.plain()
        
        config.image = image
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
        config.contentInsets = Constants.buttonInsets
        
        let button = UIButton(configuration: config)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonDimension),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonDimension)
        ])
        
        return button
    }
    
    // MARK: Buttons
    
    private lazy var playPauseButton: UIButton = {
        let button = createConfigurationButton(.play, Constants.playPausePointSize)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var previusButton: UIButton = {
        let button = createConfigurationButton(.backward, Constants.playPausePointSize)
        button.addTarget(self, action: #selector(showPreviusAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = createConfigurationButton(.forward, Constants.playPausePointSize)
        button.addTarget(self, action: #selector(showNextAnimation), for: .touchUpInside)
        return button
    }()
    
    private lazy var controlsContainer: UIView = {
        let view = UIView()
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(previusButton)
        view.addSubview(playPauseButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            previusButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -10),
            previusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 10),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [animationView, controlsContainer])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        loadAnimation(ar: Constants.initialAnimationIndex, autoPlay: false)
    }
    
    func setupView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            animationView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.6),
            controlsContainer.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.4),
        ])
    }
    
    func loadAnimation(ar index: Int, autoPlay: Bool) {
        let animationName = Constants.animationNames[index]
        animationView.animation = LottieAnimation.named(animationName)
        
        if autoPlay {
            animationView.play()
        } else {
            animationView.stop()
        }
        playPauseButton.configuration?.image = autoPlay ? .pause : .play
    }
    
    @objc func togglePlayPause() {
        if animationView.isAnimationPlaying {
            animationView.stop()
            playPauseButton.configuration?.image = .play
        } else {
            animationView.play()
            playPauseButton.configuration?.image = .pause
        }
    }
    
    @objc func showPreviusAnimation() {
        currentAnimationIndex = (currentAnimationIndex - 1 + Constants.animationNames.count) % Constants.animationNames.count
        loadAnimation(ar: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }
    
    @objc func showNextAnimation() {
        currentAnimationIndex = (currentAnimationIndex - 1) % Constants.animationNames.count
        loadAnimation(ar: currentAnimationIndex, autoPlay: animationView.isAnimationPlaying)
    }
}
