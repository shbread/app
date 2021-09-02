import UIKit

extension Writer {
    final class Coordinator: UITextView, UITextViewDelegate {
        private let wrapper: Writer
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Writer) {
            self.wrapper = wrapper
            super.init(frame: .zero, textContainer: Container())
            typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .regular)
            typingAttributes[.kern] = 1
            font = typingAttributes[.font] as? UIFont
            textContainerInset = .init(top: 50, left: 20, bottom: 30, right: 20)
            keyboardDismissMode = .none
            backgroundColor = .clear
            tintColor = .label
            autocapitalizationType = .sentences
            autocorrectionType = .no
            spellCheckingType = .no
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
            delegate = self
            
            switch wrapper.write {
            case .rename:
                text = wrapper.session.secret.name
            case .edit:
                text = wrapper.session.secret.payload
            default:
                break
            }
            
            let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
            
            let cancel = UIButton()
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16)), for: .normal)
            cancel.addTarget(self, action: #selector(resignFirstResponder), for: .touchUpInside)
            cancel.imageView!.tintColor = .secondaryLabel
            
            let send = UIButton()
            send.setImage(UIImage(systemName: "arrow.up.circle.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
            send.imageView!.tintColor = .label
            send.addTarget(self, action: #selector(self.send), for: .touchUpInside)
            
            let number = UIButton()
            number.setImage(UIImage(systemName: "number")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)), for: .normal)
            number.addTarget(self, action: #selector(self.number), for: .touchUpInside)
            
            let minus = UIButton()
            minus.setImage(UIImage(systemName: "minus")?
                            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
            minus.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
            
            let asterisk = UIButton()
            asterisk.setImage(UIImage(systemName: "staroflife.fill")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .light)), for: .normal)
            asterisk.addTarget(self, action: #selector(self.asterisk), for: .touchUpInside)
            
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.numberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            [cancel, send, number, minus, asterisk].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                input.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: 5).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 64).isActive = true
            }
            
            [number, minus, asterisk]
                .forEach {
                    $0.imageView!.tintColor = .label
                }
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            send.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            minus.centerXAnchor.constraint(equalTo: input.centerXAnchor).isActive = true
            number.rightAnchor.constraint(equalTo: minus.leftAnchor).isActive = true
            asterisk.leftAnchor.constraint(equalTo: minus.rightAnchor).isActive = true
            
            title.topAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
            title.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
            let right = title.rightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.rightAnchor, constant: -25)
            right.priority = .defaultLow
            right.isActive = true
            
            inputAccessoryView = input
            
            switch wrapper.write {
            case .create:
                title.attributedText = .make("New secret",
                                             font: .preferredFont(forTextStyle: .callout),
                                             color: .secondaryLabel)
            case .rename:
                title.attributedText = .make("Rename secret",
                                             font: .preferredFont(forTextStyle: .callout),
                                             color: .secondaryLabel)
            case .edit:
                title.attributedText = .make(wrapper.session.secret.name,
                                             font: .preferredFont(forTextStyle: .callout),
                                             color: .secondaryLabel)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.becomeFirstResponder()
            }
        }
        
        func textViewDidEndEditing(_: UITextView) {
            wrapper.dismiss()
        }
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.width = 2
            return rect
        }
        
        @objc private func send() {
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            resignFirstResponder()
            Task {
                switch wrapper.write {
                case .create:
                    wrapper.session.selected = await cloud.new(secret: text)
        //            cloud.new(board: text.isEmpty ? "Project" : text) {
        //                Notifications.send(message: "Created project")
        //            }
                case .rename:
                    await cloud.update(index: wrapper.session.selected!, name: text)
                case .edit:
                    await cloud.update(index: wrapper.session.selected!, payload: text)
        //            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
        //            Notifications.send(message: "Created column")
                }
            }
        }
        
        @objc private func asterisk() {
            insertText("*")
        }
        
        @objc private func minus() {
            insertText("-")
        }
        
        @objc private func number() {
            insertText("#")
        }
    }
}
