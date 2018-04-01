import QtQuick 2.7
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

    property alias cfg_websliceUrl: websliceUrl.text
    property alias cfg_enableReload: enableReload.checked
    property alias cfg_reloadIntervalSec: reloadIntervalSec.value
    property alias cfg_enableTransparency: enableTransparency.checked
    property alias cfg_displaySiteBehaviour: displaySiteBehaviour.checked
    property alias cfg_buttonBehaviour: buttonBehaviour.checked
    property alias cfg_webPopupWidth: webPopupWidth.value
    property alias cfg_webPopupHeight: webPopupHeight.value
    property alias cfg_reloadAnimation: reloadAnimation.checked

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

        /*Item {
            width: 1
            height: 25
        }*/
        Item {
            width: 3
            height: 40
        }

        CheckBox {
            id: enableReload
            Layout.columnSpan: 3
            text: i18n('Enable auto reload')
        }

        Label {
            text: i18n('Reload interval :')
            enabled: enableReload.checked
        }

        SpinBox {
            id: reloadIntervalSec
            suffix: i18nc('Abbreviation for seconds', 'sec')
            enabled: enableReload.checked
            minimumValue: 15
            maximumValue: 360000
            stepSize: 15
            Layout.columnSpan: 2
        }

        Item {
            width: 3
            height: 20
        }

        CheckBox {
            id: enableTransparency
            Layout.columnSpan: 3
            text: i18n('Enable transparency')
        }

        Label {
            font.italic: true
            text: i18n('Note that the transparency will only work if the page background is also transparent or not set.\nAlso, the transparency may not be visible until the page is reloaded or repainted.')
            Layout.columnSpan: 3
        }

        Item {
            width: 3
            height: 20
        }

        Label {
            text: i18n('Plasmoid behaviour :')
            Layout.columnSpan: 3
        }

        GroupBox {
            flat: true
            Layout.columnSpan: 3

            ColumnLayout {
                ExclusiveGroup {
                    id: behaviourGroup
                }

                RadioButton {
                    id: displaySiteBehaviour
                    text: i18n("Display the site")
                    exclusiveGroup: behaviourGroup
                }

                RadioButton {
                    id: buttonBehaviour
                    text: i18n("Display a button that opens the site in a new panel")
                    exclusiveGroup: behaviourGroup
                }
            }
        }


        RowLayout{
            Layout.columnSpan: 3
            Label{
                text: i18n('Popup size')
                enabled: buttonBehaviour.checked
            }

            Item {
                width: 30
                height: 10
            }

            Label{
                text: i18n('Width')
                enabled: buttonBehaviour.checked
            }

            SpinBox {
                id: webPopupWidth
                suffix: i18nc('Abbreviation for pixels', 'px')
                enabled: buttonBehaviour.checked
                minimumValue: 10
                maximumValue: 10000
                stepSize: 10
            }

            Label{
                text: i18n('Height')
                enabled: buttonBehaviour.checked
            }

            SpinBox {
                id: webPopupHeight
                suffix: i18nc('Abbreviation for pixels', 'px')
                enabled: buttonBehaviour.checked
                minimumValue: 10
                maximumValue: 10000
                stepSize: 10
            }
        }


        Label {
            font.italic: true
            text: i18n('Note that this behaviour might not be visible until the plasmoid is reloaded.')
            Layout.columnSpan: 3
        }

        Item {
            width: 3
            height: 25
        }

        CheckBox {
            id: reloadAnimation
            Layout.columnSpan: 3
            text: i18n('Display reload animation')
        }
    }
}
