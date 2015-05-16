import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {
	
	property alias cfg_enableJSID: enableJSID.checked
	property alias cfg_jsSelector: jsSelector.text

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

        Text {
            font.bold: true
            text: i18n('Attention, modify with care and only if you know what you are doing.')
            Layout.preferredWidth: 0
            Layout.columnSpan: 3
        }
        
        CheckBox {
            id: enableJSID
            Layout.columnSpan: 3
            text: i18n('Enable JS Scroll Into View')
        }
        
        Label {
            text: i18n('JS Selector :')
			enabled: enableJSID.checked
        }

        TextField {
            id: jsSelector
            placeholderText: 'document.getElementById("id")'
            Layout.preferredWidth: textfieldWidth
            enabled: enableJSID.checked
        }
    }
    
}
 
