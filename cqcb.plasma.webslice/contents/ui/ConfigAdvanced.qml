import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.10
import org.kde.kquickcontrols 2.0

Item {

    property alias cfg_enableScrollTo: enableScrollTo.checked
    property alias cfg_scrollToX: scrollToX.text
    property alias cfg_scrollToY: scrollToY.text
    property alias cfg_enableJSID: enableJSID.checked
    property alias cfg_jsSelector: jsSelector.text
    property alias cfg_enableReloadOnActivate: enableReloadOnActivate.checked
    property alias cfg_enableJS: enableJS.checked
    property alias cfg_js: js.text

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: 25
        width:parent.parent.parent.width

        // Scroll To Position
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 5
            
            CheckBox {
                id: enableScrollTo
                Layout.columnSpan: 5
                text: i18n('Scroll to a fixed position')
                Layout.fillWidth: true
            }
            
            Label {
                text: i18n('Scroll To : ')
                Layout.columnSpan: 1
                enabled: enableScrollTo.checked
                Layout.fillWidth: true
            }
            
            GridLayout{
                Layout.columnSpan: 2
                columns: 3
                
                Label {
                    text: i18n('X :')
                    enabled: enableScrollTo.checked
                    Layout.columnSpan: 1
                }
                TextField {
                    id: scrollToX
                    placeholderText: '0'
                    Layout.fillWidth: true
                    Layout.minimumWidth:30
                    enabled: enableScrollTo.checked
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 1000000
                    }
                    Layout.columnSpan: 1
                }
                Label {
                    text: i18n('px, ')
                    enabled: enableScrollTo.checked
                    Layout.columnSpan: 1
                }
            }
            
            GridLayout{
                Layout.columnSpan: 2
                columns: 3
                
                Label {
                    text: i18n('Y :')
                    enabled: enableScrollTo.checked
                   Layout.columnSpan: 1
                }
                TextField {
                    id: scrollToY
                    placeholderText: '0'
                    Layout.fillWidth: true
                    Layout.minimumWidth:30
                    enabled: enableScrollTo.checked
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 1000000
                    }
                    Layout.columnSpan: 1
                }
                Label {
                    text: i18n('px')
                    enabled: enableScrollTo.checked
                    Layout.columnSpan: 1
                }
            }
        }

        // Scroll to view
        GridLayout{
            //width: parent.width
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4
            
            CheckBox {
                id: enableJSID
                Layout.columnSpan: 4
                text: i18n('Enable JS Scroll Into View')
                Layout.fillWidth: true
            }

            Label {
                text: i18n('JS Selector :')
                enabled: enableJSID.checked
                Layout.columnSpan: 1
            }

            TextField {
                id: jsSelector
                placeholderText: 'document.getElementById("id")'
                Layout.minimumWidth: textfieldWidth
                enabled: enableJSID.checked
                Layout.columnSpan: 3
                Layout.fillWidth: true
            }
        }

        // Reload on Activate
        GridLayout{
            //width: parent.width
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 1
            
            CheckBox {
                id: enableReloadOnActivate
                text: i18n('Reload the page when activated through the global shortcut')
                Layout.fillWidth: true
            }
        }

        // UserJS
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4
            
            CheckBox {
                id: enableJS
                Layout.columnSpan: 4
                text: i18n('Enable personnalized JavaScript to be executed once the page is loaded')
            }

            Label {
                text: i18n('Your JavaScript :')
                enabled: enableJS.checked
                Layout.columnSpan: 1
            }

            TextArea {
                id: js
                Layout.fillWidth: true
                Layout.minimumWidth: textfieldWidth
                enabled: enableJS.checked
                Layout.columnSpan: 3
            }
        }
    }
}
