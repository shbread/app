import StoreKit

extension Store {
    enum State {
        case
        loading,
        error(String),
        products([Product])
    }
}
