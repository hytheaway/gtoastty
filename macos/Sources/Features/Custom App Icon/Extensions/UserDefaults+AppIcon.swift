import AppKit

extension UserDefaults {
    private static let customIconKeyOld = "CustomGhosttyIcon"
    private static let customIconKeyNew = "CustomGhosttyIcon2"

    /// Icon settings live in their own domain so they are not shared with
    /// another app that uses the `com.mitchellh.ghostty` bundle identifier.
    private static func iconDefaults() -> UserDefaults? {
        #if DEBUG
        UserDefaults(suiteName: "com.mitchellh.gtoasty.debug")
        #else
        UserDefaults(suiteName: "com.mitchellh.gtoasty")
        #endif
    }

    var appIcon: AppIcon? {
        get {
            guard let defaults = Self.iconDefaults() else { return nil }

            // Always remove our old pre-docktileplugin values.
            defer {
                defaults.removeObject(forKey: Self.customIconKeyOld)
            }

            // Check if we have the new key for our dock tile plugin format.
            guard let data = defaults.data(forKey: Self.customIconKeyNew) else {
                return nil
            }
            return try? JSONDecoder().decode(AppIcon.self, from: data)
        }

        set {
            guard let defaults = Self.iconDefaults() else { return }
            guard let newData = try? JSONEncoder().encode(newValue) else {
                return
            }

            defaults.set(newData, forKey: Self.customIconKeyNew)
        }
    }
}
