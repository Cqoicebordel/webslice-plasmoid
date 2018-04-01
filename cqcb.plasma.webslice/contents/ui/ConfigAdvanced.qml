import QtQuick 2.7
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

    property alias cfg_enableJSID: enableJSID.checked
    property alias cfg_jsSelector: jsSelector.text
    property alias cfg_minimumContentWidth: minimumContentWidth.value
    property alias cfg_enableJS: enableJS.checked
    property alias cfg_js: js.text

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

        Label {
            font.bold: true
            text: i18n('Attention, modify with care and only if you know what you are doing.')
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
            Layout.columnSpan: 1
        }

        TextField {
            id: jsSelector
            placeholderText: 'document.getElementById("id")'
            Layout.preferredWidth: textfieldWidth
            enabled: enableJSID.checked
            Layout.columnSpan: 2
        }

        Item {
            Layout.columnSpan: 3
            height: 25
        }

        Label {
            text: i18n('Minimum Content width :')
        }

        SpinBox {
            id: minimumContentWidth
            suffix: i18nc('Abbreviation for pixels', 'px')
            minimumValue: 1
            maximumValue: 10000
            Layout.columnSpan: 1
        }

        Label {
            font.italic: true
            text: i18n('(default : 100px)')
            Layout.columnSpan: 1
        }

        Label {
            font.italic: true
            text: i18n('This option can help you trigger media queries, and may help with zoom.')
            Layout.preferredWidth: 0
            Layout.columnSpan: 3
        }

        Item {
            width: 3
            height: 25
        }

        CheckBox {
            id: enableJS
            Layout.columnSpan: 3
            text: i18n('Enable personnalized JavaScript to be executed once the page is loaded')
        }

        Label {
            text: i18n('Your JavaScript :')
            enabled: enableJS.checked
        }

        TextArea {
            id: js
            width: textfieldWidth
            Layout.minimumWidth: textfieldWidth
            enabled: enableJS.checked
            Layout.columnSpan: 2
        }
    }
}
