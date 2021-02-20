import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.10
import org.kde.kquickcontrols 2.0

Item {

    property alias cfg_websliceUrl: websliceUrl.text
    property alias cfg_zoomFactor: zoomFactor.value
    property alias cfg_enableReload: enableReload.checked
    property alias cfg_reloadIntervalSec: reloadIntervalSec.value
    property alias cfg_displaySiteBehaviour: displaySiteBehaviour.checked
    property alias cfg_buttonBehaviour: buttonBehaviour.checked

    property alias cfg_webPopupWidth: webPopupWidth.value
    property alias cfg_webPopupHeight: webPopupHeight.value
    property alias cfg_webPopupIcon: webPopupIcon.text
    property alias cfg_showPinButton: showPinButton.checked
    property alias cfg_pinButtonAlignmentLeft: pinButtonAlignmentLeft.checked
    property alias cfg_pinButtonAlignmentRight: pinButtonAlignmentRight.checked
    property alias cfg_reloadAnimation: reloadAnimation.checked

    property alias cfg_backgroundColorWhite: backgroundColorWhite.checked
    property alias cfg_backgroundColorTransparent: backgroundColorTransparent.checked
    property alias cfg_backgroundColorTheme: backgroundColorTheme.checked
    property alias cfg_backgroundColorCustom: backgroundColorCustom.checked
    property alias cfg_customBackgroundColor: customBackgroundColor.color
    
    property double maxWidth: width - 22

    GridLayout {
        Layout.fillWidth: true
        Layout.maximumWidth: maxWidth
        columns: 4
        rowSpacing: 20

        // URL
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 3
            
            Label {
                text: i18n('URL :')
                Layout.columnSpan: 1
            }

            TextField {
                id: websliceUrl
                placeholderText: 'URL'
                Layout.columnSpan: 2
                Layout.fillWidth: true
            }
        }
        
        // Zoom Factor
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4
            
            Label {
                text: i18n('Zoom factor :')
                Layout.columnSpan: 1
            }

            Slider {
                id: zoomFactor
                from: 0.25
                to: 5
                value: 1
                stepSize: 0.25
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
                Label {
                    id:zoof
                    Layout.columnSpan: 1
                    text: zoomFactor.value+"x"
                    width:35
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.bottom: parent.top
                    Layout.minimumWidth:35
                    Layout.maximumWidth:35
                }
        }

        // Auto reload
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 3
            
            CheckBox {
                id: enableReload
                text: i18n('Enable auto reload')
                Layout.columnSpan: 3
            }

            Label {
                text: i18n('Reload interval :')
                enabled: enableReload.checked
                Layout.columnSpan: 1
                Layout.fillWidth: true
            }

            SpinBox {
                id: reloadIntervalSec
                enabled: enableReload.checked
                from: 15
                to: 360000
                stepSize: 15
                textFromValue: function(value, locale) {
                    return i18nc('Abbreviation for seconds', '%1 sec', value);
                }
                Layout.columnSpan: 2
            }
        }

        // Full or minimal UI
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 3
            
            Label {
                text: i18n('Plasmoid behaviour :')
                Layout.columnSpan: 3
            }

            ButtonGroup {
                buttons: behaviourGroup.children
            }

            ColumnLayout {
                id: behaviourGroup

                RadioButton {
                    id: displaySiteBehaviour
                    text: i18n("Display the site")
                }

                RadioButton {
                    id: buttonBehaviour
                    text: i18n("Display a button that opens the site in a new panel")
                }
            }

            // Minimal UI settings
            GridLayout{
                Layout.fillWidth: true
                enabled: buttonBehaviour.checked
                Layout.columnSpan: 3
                columns: 5

                Label{
                    Layout.fillWidth: true
                    text: i18n('Popup size')
                    Layout.columnSpan: 1
                }
                
                Label{
                    text: i18n('Width')
                    Layout.columnSpan: 1
                }

                SpinBox {
                    id: webPopupWidth
                    from: 10
                    to: 10000
                    stepSize: 10
                    textFromValue: function(value, locale) {
                        return i18nc('Abbreviation for pixels', '%1 px', value);
                    }
                    Layout.columnSpan: 1
                }

                Label{
                    text: i18n('Height')
                    Layout.columnSpan: 1
                }

                SpinBox {
                    id: webPopupHeight
                    from: 10
                    to: 10000
                    stepSize: 10
                    textFromValue: function(value, locale) {
                        return i18nc('Abbreviation for pixels', '%1 px', value);
                    }
                    Layout.columnSpan: 1
                }
                
                // Pin button
                GridLayout{
                    Layout.fillWidth: true
                    Layout.columnSpan: 5
                    columns: 5
                    
                    CheckBox {
                        id: showPinButton
                        text: i18nc('General setting, checkbox, to show the pin icon to keep the popup open', 'Show pin button')
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                    }
                    
                    ButtonGroup {
                        buttons: pinButtonAlignment.children
                    }
                    
                    GridLayout{
                        id: pinButtonAlignment
                        Layout.fillWidth: true
                        Layout.columnSpan: 3
                        columns: 3
                        
                        RadioButton {
                            id: pinButtonAlignmentLeft
                            text: i18nc("General setting, radio button, to chose the alignement of the pin button, to the left or the right", "to the left")
                            enabled: showPinButton.checked
                            Layout.columnSpan: 1
                        }

                        RadioButton {
                            id: pinButtonAlignmentRight
                            text: i18nc("General setting, radio button, to chose the alignement of the pin button, to the left or the right", "to the right")
                            enabled: showPinButton.checked
                            Layout.columnSpan: 1
                        }
                        
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // Icon
                GridLayout{
                    Layout.fillWidth: true
                    Layout.columnSpan: 5
                    columns: 5
                
                    Label {
                        text: i18n('Icon :')
                        Layout.columnSpan: 2
                    }

                    TextField {
                        id: webPopupIcon
                        Layout.fillWidth: true
                        placeholderText: 'file:///media/.../icon.jpg'
                        Layout.columnSpan: 3
                    }
                }
                
                Label {
                    font.italic: true
                    text: i18n('Icon in "file:///media/.../icon.jpg" format, or name of <a href="https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html">standard freedesktop icons</a>.')
                    onLinkActivated:{
                        Qt.openUrlExternally("https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html");
                    }
                    wrapMode: Text.Wrap
                    Layout.maximumWidth: maxWidth
                    Layout.columnSpan: 5
                }
            }
        }

        // Loading animation
        ColumnLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            
            CheckBox {
                id: reloadAnimation
                text: i18n('Display loading animation')
            }
        }

        // Plasmoid background color
        ColumnLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4           
            
            Label {
                Layout.fillWidth: true
                text: i18n('Plasmoid background color :')
            }
            
            ButtonGroup {
                id: backgroundColorGroup
            }

            ColumnLayout {

                RadioButton {
                    id: backgroundColorWhite
                    text: i18n("White")
                    ButtonGroup.group: backgroundColorGroup
                }

                RadioButton {
                    id: backgroundColorTransparent
                    text: i18n("Transparent <i>(⚠ might cause drawing issues)</i>")
                    ButtonGroup.group: backgroundColorGroup
                }
                
                RadioButton {
                    id: backgroundColorTheme
                    text: i18n("Theme's background color")
                    ButtonGroup.group: backgroundColorGroup
                }
                
                RowLayout{
                    RadioButton {
                        id: backgroundColorCustom
                        text: i18n("Custom")
                        ButtonGroup.group: backgroundColorGroup
                    }
                    ColorButton {
                        id: customBackgroundColor
                        showAlphaChannel:true
                        enabled: backgroundColorCustom.checked
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                font.italic: true
                text: i18n('Note that the background color will only be visible if the page background is also transparent or not set. This setting is for the background of the plasmoid, not of the page.')
                wrapMode: Text.Wrap
                Layout.maximumWidth: maxWidth
            }
        }
    }
}
