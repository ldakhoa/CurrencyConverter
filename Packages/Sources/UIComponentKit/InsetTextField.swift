import UIKit

public final class InsetTextField: UITextField {
    private let inset: CGFloat

    public init(inset: CGFloat) {
        self.inset = inset
        super.init(frame: .zero)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func textRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: self.inset)
    }

    public override func editingRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: self.inset)
    }

    public override func placeholderRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.inset, dy: self.inset)
    }
}
