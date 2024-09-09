import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    private var curNews: String?
    private var curIdx: Int = 0
    private var displayLink: CADisplayLink?
    private var lastUpdateTime: CFTimeInterval = 0
    private let updateInterval: CFTimeInterval = 0.2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Serve the people"
        
        curNews = "我们的同志在困难的时候，要看到成绩，要看到光明，要提高我们的勇气。中国人民正在受难，我们有责任解救他们，我们要努力奋斗。要奋斗就会有牺牲，死人的事是经常发生的。但是我们想到人民的利益，想到大多数人民的痛苦，我们为人民而死，就是死得其所。不过，我们应当尽量地减少那些不必要的牺牲。\nOur comrades in moments of difficulty should see the achievements and the bright future, and enhance their courage. The Chinese people are suffering; we have the responsibility to rescue them, and we must strive hard. To struggle there will be sacrifice, and death is a common occurrence. However, when we think of the interests of the people, and the suffering of the majority, to die for the people is a worthy death. Nevertheless, we should strive to reduce unnecessary sacrifices."
        
        view.addSubview(textView)
        view.addSubview(cursorView)
        
        makeViewConstrains()
        startCursorAnimation()
    }
    
    deinit {
        displayLink?.invalidate()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.setupDisplayLink()
        }
    }

    //MARK: private
    private func startCursorAnimation() {
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyframeAnimation.values = [1.0, 1.5, 1.0]
        keyframeAnimation.keyTimes = [0, 0.5, 1]
        keyframeAnimation.duration = 1.2
        keyframeAnimation.repeatCount = 2
        keyframeAnimation.isRemovedOnCompletion = false
        keyframeAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        keyframeAnimation.delegate = self
        cursorView.layer.add(keyframeAnimation, forKey: "pulse")
    }

    private func makeViewConstrains() {
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        cursorView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(15)
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.preferredFramesPerSecond = Int(1/updateInterval)
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func update(displayLink: CADisplayLink) {
        guard lastUpdateTime == 0 || displayLink.timestamp - lastUpdateTime >= updateInterval else {
            return
        }
        lastUpdateTime = displayLink.timestamp
        appendText()
    }

    //appends a random portion of the remaining text and updates the text view and cursor accordingly
    private func appendText() {
        guard let curNews = curNews, curIdx < curNews.count else {
            finishAnimation()
            return
        }

        let remainingLength = curNews.count - curIdx
        let maxReadLength = min(5, remainingLength)
        let read = Int.random(in: 1...maxReadLength)
        let startIndex = curNews.index(curNews.startIndex, offsetBy: curIdx)
        let endIndex = curNews.index(startIndex, offsetBy: read)
        let substring = String(curNews[startIndex..<endIndex])

        textView.text += substring
        updateTextViewHeight()
        updateCursorPosition()
        curIdx += read
    }

    private func updateTextViewHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        textView.contentSize.height = size.height
        textView.snp.updateConstraints { make in
            make.height.equalTo(size.height)
        }
    }

    private func updateCursorPosition() {
        guard let selectedRange = textView.selectedTextRange else { return }
        let cursorRect = textView.caretRect(for: selectedRange.end)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.cursorView.alpha = 0.2
            self.cursorView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(cursorRect.origin.y + self.textView.frame.origin.y + 4)
                make.left.equalToSuperview().offset(cursorRect.origin.x + self.textView.frame.origin.x)
            }
        }) { _ in
            UIView.animate(withDuration: 0.05) {
                self.cursorView.alpha = 1
            }
        }
    }

    private func finishAnimation() {
        curIdx = 0
        displayLink?.invalidate()
        cursorView.isHidden = true
    }
    
    //MARK: lazy load
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textColor = .black
        view.backgroundColor = .green.withAlphaComponent(0.1)
        view.isEditable = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
    private lazy var cursorView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 8
        return view
    }()
}


