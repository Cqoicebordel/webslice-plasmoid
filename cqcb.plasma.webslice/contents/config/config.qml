import QtQuick 2.7
import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
         name: i18n('General')
         icon: 'preferences-system-windows'
         source: 'ConfigGeneral.qml'
    }
    ConfigCategory {
         name: i18n('Advanced')
         icon: 'preferences-desktop-notification'
         source: 'ConfigAdvanced.qml'
    }
    ConfigCategory {
         name: i18n('More URLs')
         icon: 'link'
         source: 'ConfigMultipleURLs.qml'
    }
    ConfigCategory {
         name: i18n('Experimental')
         icon: 'applications-science'
         source: 'ConfigExperimental.qml'
    }
}
