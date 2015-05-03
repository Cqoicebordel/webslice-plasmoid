import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

Item {

    property alias cfg_websliceUrl: websliceUrl.text
    //property alias cfg_reloadIntervalMin: reloadIntervalMin.value
    
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
        
        /*Label {
            text: i18n('Reload interval :')
            //Layout.alignment: Qt.AlignRight
        }
        
        SpinBox {
            id: reloadIntervalMin
            suffix: i18nc('Abbreviation for minutes', 'min')
        }*/
        
    }
    
}
 
