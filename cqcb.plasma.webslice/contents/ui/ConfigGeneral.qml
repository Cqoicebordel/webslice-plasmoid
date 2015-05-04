import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {

    property alias cfg_websliceUrl: websliceUrl.text
    property alias cfg_enableReload: enableReload.checked
    property alias cfg_reloadIntervalMin: reloadIntervalMin.value
    
    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 2
        
        Label {
            text: i18n('URL :')
            Layout.alignment: Qt.AlignRight
        }
        
        TextField {
            id: websliceUrl
            placeholderText: 'URL'
            Layout.preferredWidth: textfieldWidth
        }
        
        CheckBox {
            id: enableReload
            Layout.columnSpan: 2
            text: i18n('Enable auto reload')
        }
        
        Label {
            text: i18n('Reload interval :')
        }
        
        SpinBox {
            id: reloadIntervalMin
            suffix: i18nc('Abbreviation for minutes', 'min')
			enabled: enableReload.checked
			minimumValue: 1
        }
        
    }
    
}
 
