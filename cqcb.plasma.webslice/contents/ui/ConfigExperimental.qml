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

    property alias cfg_notOffTheRecord: notOffTheRecord.checked
    property alias cfg_profileName: profileName.text

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: 25
        width:parent.parent.parent.width

        // Shortcuts
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4

            Label {
                text: i18n('Shortcuts :')
                Layout.columnSpan: 4
                Layout.fillWidth: true
                
            }
            Label {
                font.italic: true
                text: i18n('Note that the usual shortcuts for those actions are already included. Here you can add to those. It\'s in experimental, because it\'s seems to not work for some shortcuts, and because I don\'t know if they will be global or not once the plasmoid is properly installed. There might also be an issue when multiple webslices are present.')
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
        
        // Fill
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
        
        // Not off the record
        GridLayout{
            Layout.fillWidth: true
            Layout.columnSpan: 4
            columns: 4
            
            CheckBox {
                id: notOffTheRecord
                text: i18nc('Setting, checkbox, to avoid behaving like a private window in a browser', 'Allow to store navigation data')
                Layout.fillWidth: true
                Layout.columnSpan: 4
            }
            
            Label {
                font.italic: true
                text: i18nc('Text info just below the "Allow to store navigation data"', 'By default, Webslices behave like a private window in a standard browser and no data is stored on disk. That\'s why you have to re-login when you restart you computer. So, activate this option if you want data to be stored.<br />The profile name is the folder in which your data will be stored. Don\'t change it unless you want multiple webslices connected with different accounts to the same website.')
                wrapMode: Text.Wrap
                Layout.maximumWidth: parent.parent.width
                Layout.columnSpan: 4
            }
            
            Label {
                text: i18nc('Setting, textfield, name of the folder containing the profile (navigation) data', 'Profile name :')
                enabled: notOffTheRecord.checked
                Layout.columnSpan: 1
            }
            
            TextField {
                id: profileName
                placeholderText: 'webslice-data'
                enabled: notOffTheRecord.checked
                Layout.columnSpan: 3
                Layout.fillWidth: true
            }
            
            // https://bugreports.qt.io/browse/QTBUG-72738
            Label {
                font.italic: true
                text: i18nc('Text info just below the "Profile name"', '⚠ Beware. Because of a bug in QT, those options will crash the web renderer each time they are changed. So, to make it work, change the settings, and restart the plasmoid (restarting plasmashell once should suffice).')
                wrapMode: Text.Wrap
                Layout.maximumWidth: parent.parent.width
                Layout.columnSpan: 4
            }
        }
    }
}
