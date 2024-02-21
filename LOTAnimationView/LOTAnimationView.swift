// MIT License
//
// Copyright (c) 2024 Dwarven Yang <prison.yang@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Lottie

@objc public enum LOTLoopMode: Int {
    /// Animation is played once then stops.
    case playOnce
    /// Animation will loop from beginning to end until stopped.
    case loop
    /// Animation will play forward, then backwards and loop until stopped.
    case autoReverse
}

@objcMembers public class LOTAnimationView: UIView {
    private var lottieView: LottieAnimationView?
    
    public var loopMode: LOTLoopMode {
        get {
            switch lottieView?.loopMode {
            case .loop:
                return .loop
            case .autoReverse:
                return .autoReverse
            default:
                return .playOnce
            }
        }
        set {
            switch newValue {
            case .loop:
                lottieView?.loopMode = .loop
            case .autoReverse:
                lottieView?.loopMode = .autoReverse
            default:
                lottieView?.loopMode = .playOnce
            }
        }
    }
    
    public var isAnimationPlaying: Bool {
        lottieView?.isAnimationPlaying ?? false
    }
    
    public var animationProgress: CGFloat {
        get { lottieView?.realtimeAnimationFrame ?? 0 }
        set { lottieView?.currentProgress = newValue }
    }
    
    public var animationSpeed: CGFloat {
        get { lottieView?.animationSpeed ?? 1 }
        set { lottieView?.animationSpeed = newValue }
    }
    
    public var duration: TimeInterval {
        lottieView?.animation?.duration ?? 0
    }
    
    public var hasAnimation: Bool {
        lottieView?.animation != nil
    }
    
    public var currentFrame: CGFloat {
        get { lottieView?.currentFrame ?? 0 }
        set { lottieView?.currentFrame = newValue }
    }
    
    public override var contentMode: UIView.ContentMode {
        didSet { lottieView?.contentMode = contentMode }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        lottieView?.frame = bounds
    }
    
    private static func bundleInMain(with name: String?) -> Bundle? {
        guard let path = name, path.count > 0, let bundle = Bundle.main.path(forResource: path, ofType: "bundle") else { return nil }
        return Bundle(path: bundle)
    }
    
    public static func animation(bundleName: String?) -> LOTAnimationView {
        animation(filePath: bundleInMain(with: bundleName)?.path(forResource: bundleName, ofType: "json"))
    }
    
    public static func animation(filePath: String?) -> LOTAnimationView {
        let view = LOTAnimationView()
        view.backgroundColor = .clear
        if let path = filePath {
            let lottieView = LottieAnimationView(filePath: path)
            view.addSubview(lottieView)
            view.lottieView = lottieView
        }
        return view
    }
    
    public func play() {
        play(completion: nil)
    }
    
    public func play(completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) {
        lottieView?.play { [weak self] completed in
            completion?(completed, self)
        }
    }
    
    public func play(fromProgress: CGFloat, toProgress: CGFloat) {
        play(fromProgress: fromProgress, toProgress: toProgress, withCompletion: nil)
    }
    
    public func play(fromProgress: CGFloat, toProgress: CGFloat, withCompletion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) {
        lottieView?.play(fromProgress: fromProgress, toProgress: toProgress) { [weak self] completed in
            withCompletion?(completed, self)
        }
    }
    
    public func play(toProgress: CGFloat) {
        play(toProgress: toProgress, withCompletion: nil)
    }
    
    public func play(toProgress: CGFloat, withCompletion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) {
        lottieView?.play(toProgress: toProgress) { [weak self] completed in
            withCompletion?(completed, self)
        }
    }
    
    public func play(fromFrame: CGFloat, toFrame: CGFloat) {
        play(fromFrame: fromFrame, toFrame: toFrame, withCompletion: nil)
    }
    
    public func play(fromFrame: CGFloat, toFrame: CGFloat, withCompletion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) {
        lottieView?.play(fromFrame: fromFrame, toFrame: toFrame) { [weak self] completed in
            withCompletion?(completed, self)
        }
    }
    
    public func play(toFrame: CGFloat) {
        play(toFrame: toFrame, withCompletion: nil)
    }
    
    public func play(toFrame: CGFloat, withCompletion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) {
        lottieView?.play(toFrame: toFrame) { [weak self] completed in
            withCompletion?(completed, self)
        }
    }
    
    public func pause() {
        lottieView?.pause()
    }
    
    public func stop() {
        lottieView?.stop()
    }
}

extension LOTAnimationView {
    @discardableResult
    public static func play(bundleName: String?, frame: CGRect, parent: UIView) -> LOTAnimationView {
        play(bundleName: bundleName, frame: frame, parent: parent, completion: nil)
    }
    
    @discardableResult
    public static func play(bundleName: String?, frame: CGRect, parent: UIView, completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) -> LOTAnimationView {
        play(bundleName: bundleName, frame: frame, parent: parent, loopMode: .playOnce, completion: completion)
    }
    
    @discardableResult
    public static func play(bundleName: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
        play(bundleName: bundleName, json: bundleName, frame: frame, parent: parent, loopMode: loopMode)
    }
    
    @discardableResult
    public static func play(bundleName: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode, completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) -> LOTAnimationView {
        play(bundleName: bundleName, json: bundleName, frame: frame, parent: parent, loopMode: loopMode, completion: completion)
    }
    
    @discardableResult
    public static func play(bundleName: String?, json: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
        play(bundleName: bundleName, json: json, frame: frame, parent: parent, loopMode: loopMode, completion: nil)
    }
    
    @discardableResult
    public static func play(bundleName: String?, json: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode, completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) -> LOTAnimationView {
        play(filePath: bundleInMain(with: bundleName)?.path(forResource: json, ofType: "json"), frame: frame, parent: parent, loopMode: loopMode, completion: completion)
    }
    
    @discardableResult
    public static func play(filePath: String?, frame: CGRect, parent: UIView) -> LOTAnimationView {
        play(filePath: filePath, frame: frame, parent: parent, completion: nil)
    }
    
    @discardableResult
    public static func play(filePath: String?, frame: CGRect, parent: UIView, completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) -> LOTAnimationView {
        play(filePath: filePath, frame: frame, parent: parent, loopMode: .playOnce, completion: completion)
    }
    
    @discardableResult
    public static func play(filePath: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
        play(filePath: filePath, frame: frame, parent: parent, loopMode: loopMode, completion: nil)
    }
    
    @discardableResult
    public static func play(filePath: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode, completion: ((_ completed: Bool, _ view: LOTAnimationView?) -> Void)?) -> LOTAnimationView {
        let animation = animation(filePath: filePath, frame: frame, parent: parent, loopMode: loopMode)
        animation.play(completion: completion)
        return animation
    }
    
    @discardableResult
    public static func animation(bundleName: String?, frame: CGRect, parent: UIView) -> LOTAnimationView {
        animation(bundleName: bundleName, frame: frame, parent: parent, loopMode: .playOnce)
    }
    
    @discardableResult
    public static func animation(bundleName: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
        animation(bundleName: bundleName, json: bundleName, frame: frame, parent: parent, loopMode: loopMode)
    }
    
    @discardableResult
    public static func animation(bundleName: String?, json: String?, frame: CGRect, parent: UIView) -> LOTAnimationView {
        animation(bundleName: bundleName, json: json, frame: frame, parent: parent, loopMode: .playOnce)
    }
    
    @discardableResult
    public static func animation(bundleName: String?, json: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
        animation(filePath: bundleInMain(with: bundleName)?.path(forResource: json, ofType: "json"), frame: frame, parent: parent, loopMode: loopMode)
    }
    
    @discardableResult
    public static func animation(filePath: String?, frame: CGRect, parent: UIView) -> LOTAnimationView {
        animation(filePath: filePath, frame: frame, parent: parent, loopMode: .playOnce)
    }
    
    @discardableResult
    public static func animation(filePath: String?, frame: CGRect, parent: UIView, loopMode: LOTLoopMode) -> LOTAnimationView {
#if DEBUG
        assert(parent.isKind(of: UIView.self))
#endif
        let animation = animation(filePath: filePath)
        animation.frame = frame
        animation.loopMode = loopMode
        parent.addSubview(animation)
        return animation
    }
}
