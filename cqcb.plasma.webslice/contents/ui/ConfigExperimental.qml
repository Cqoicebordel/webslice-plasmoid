import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.10
import org.kde.kquickcontrols 2.0

Item {

    property alias cfg_keysSeqBack: keysSeqBack.keySequence
    property alias cfg_keysSeqForward: keysSeqForward.keySequence
    property alias cfg_keysSeqReload: keysSeqReload.keySequence
    property alias cfg_keysSeqStop: keysSeqStop.keySequence
    property alias cfg_fillWidthAndHeight: fillWidthAndHeight.checked

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: 25
        width:parent.parent.parent.width

        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4

            Label {
                text: i18n('Shortcuts :')
                Layout.columnSpan: 4
                Layout.fillWidth: true
                
            }
            Label {
                font.italic: true
                text: i18n('Note that the usual shortcuts for those actions are already included. Here you can add to those. It\'s in experimental, because it\'s seems to not work for some shortcuts, and because I don\'t know if they will be global or not once the plasmoid is properly installed.')
                wrapMode: Text.Wrap
                Layout.maximumWidth: parent.parent.width
                Layout.columnSpan: 4
            }
            Label {
                text: i18n('Back (ctrl+left already in)')
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            Label {
                text: i18n('Forward (ctrl+right already in)')
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            KeySequenceItem{
                id:keysSeqBack
                modifierlessAllowed:true
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            KeySequenceItem{
                id:keysSeqForward
                modifierlessAllowed:true
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            Label {
                text: i18n('Reload (F5 already in)')
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            Label {
                text: i18n('Stop (Esc already in)')
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            KeySequenceItem{
                id:keysSeqReload
                modifierlessAllowed:true
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
            KeySequenceItem{
                id:keysSeqStop
                modifierlessAllowed:true
                Layout.columnSpan: 2
                Layout.fillWidth: true
                
            }
        }
        
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4
            
            CheckBox {
                id: fillWidthAndHeight
                Layout.columnSpan: 4
                text: i18n('Fill the whole width and height')
                Layout.fillWidth: true
            }
            
            Label {
                font.italic: true
                text: i18n('Might be useful when the plasmoid is in a panel, to fill the empty space. Not sure if it works correctly, and not sure if it really fill vertically (seems OK horizontally).')
                wrapMode: Text.Wrap
                Layout.maximumWidth: parent.parent.width
                Layout.columnSpan: 4
            }
        }
    }
}
