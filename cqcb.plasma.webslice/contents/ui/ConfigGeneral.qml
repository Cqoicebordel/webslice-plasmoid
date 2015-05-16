import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {

    property alias cfg_websliceUrl: websliceUrl.text
    property alias cfg_enableReload: enableReload.checked
    property alias cfg_reloadIntervalMin: reloadIntervalMin.value
    property alias cfg_enableTransparency: enableTransparency.checked

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

        Label {
            text: i18n('URL :')
        }

        TextField {
            id: websliceUrl
            placeholderText: 'URL'
            Layout.preferredWidth: textfieldWidth
        }

        /*Button{
			iconName: 'view-refresh'
			action: main.mainWebview.url = websliceUrl.text
			//action: main.mainWebview.reload()
		}*/

		Item {
            width: 1
            height: 25
        }

        Item {
            width: 3
            height: 25
        }

        CheckBox {
            id: enableReload
            Layout.columnSpan: 3
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
			Layout.columnSpan: 2
        }

        Item {
            width: 25
            height: 25
        }

        CheckBox {
            id: enableTransparency
            Layout.columnSpan: 3
            text: i18n('Enable transparency')
        }

        Text {
            font.italic: true
            text: i18n('Note that the transparency will only work if the page background is also transparent or not set.\nAlso, the transparency may not be visible until the page is reloaded or repainted.')
            Layout.preferredWidth: 0
            Layout.columnSpan: 3
            //Layout.alignment: Qt.AlignLeft
        }
        
    }
    
}
 
