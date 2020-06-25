import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.10

Item {

    property alias cfg_zoomFactor: zoomFactor.value
    property alias cfg_enableScrollTo: enableScrollTo.checked
    property alias cfg_scrollToX: scrollToX.text
    property alias cfg_scrollToY: scrollToY.text
    property alias cfg_enableJSID: enableJSID.checked
    property alias cfg_jsSelector: jsSelector.text
    property alias cfg_enableJS: enableJS.checked
    property alias cfg_js: js.text

    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: 40


        GridLayout{
            Layout.fillWidth: true
            columns: 4
            Layout.columnSpan: 4
            anchors.topMargin: 500
            
            Label {
                text: i18n('Zoom factor :')
                Layout.columnSpan: 2
            }
                    
            Slider {
                id: zoomFactor
                from: 0.25
                to: 5
                value: 1
                stepSize: 0.25
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
                Label {
                    text: zoomFactor.value+"x"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.top
                }
            }
            Label {
                font.italic: true
                text: i18n('You may need to reload the page to see the effect')
                Layout.columnSpan: 4
            }
        }
        
        GridLayout{
            Layout.fillWidth: true
            columns: 5
            Layout.columnSpan: 4
            
            CheckBox {
                id: enableScrollTo
                Layout.columnSpan: 5
                text: i18n('Scroll to a fixed position')
                Layout.fillWidth: true
            }
            
            Label {
                text: i18n('Scroll To :')
                Layout.columnSpan: 1
                enabled: enableScrollTo.checked
                Layout.fillWidth: true
            }
            
            Row{
                Layout.columnSpan: 2
                Label {
                    text: i18n('X:')
                    enabled: enableScrollTo.checked
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    id: scrollToX
                    width: 120
                    placeholderText: '0'
                    enabled: enableScrollTo.checked
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 1000000
                    }
                }
                Label {
                    text: i18n('px, ')
                    enabled: enableScrollTo.checked
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            
            Row{
                Layout.columnSpan: 2
                Label {
                    text: i18n('Y:')
                    enabled: enableScrollTo.checked
                    anchors.verticalCenter: parent.verticalCenter
                }
                TextField {
                    id: scrollToY
                    width: 120
                    placeholderText: '0'
                    enabled: enableScrollTo.checked
                    horizontalAlignment: TextInput.AlignRight
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator {
                        bottom: 0
                        top: 1000000
                    }
                }
                Label {
                    text: i18n('px')
                    enabled: enableScrollTo.checked
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        
        
        GridLayout{
            width: parent.width
            columns: 4
            Layout.columnSpan: 4
            Layout.fillWidth: true
            
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

        GridLayout{
            Layout.fillWidth: true
            columns: 4
            Layout.columnSpan: 4
            
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
