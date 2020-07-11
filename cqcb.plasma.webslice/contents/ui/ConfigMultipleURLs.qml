import QtQuick 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.10
import "../code/utils.js" as ConfigUtils

Item {
    id: rootItem

    property string cfg_urlsModel

    property int textfieldWidth:parent.width-(buttonAdd.width+5)*4
    property double tableWidth: parent.width


    ListModel {
        id: urlsModel
    }


    Grid{
        columns:1
        spacing:6

        Label {
            text: i18n('List of URL accessible throught the context menu to switch to others websites.')
        }

        TableView {
            id: table
            model: urlsModel
            width: tableWidth
            TableViewColumn {
                role: 'url'
                title: i18n('URL')
            }
            height:300
        }


        RowLayout {
            TextField {
                id: addedUrl
                placeholderText: i18n('URL')
                Layout.preferredWidth: textfieldWidth
            }

            Button {
                id:buttonAdd
                iconName: 'list-add'
                tooltip: i18n('Add a URL')
                onClicked: {
                    urlsModel.append({"url":addedUrl.text});
                    cfg_urlsModel = ConfigUtils.stringifyModel(urlsModel)
                }
            }

            Button {
                iconName: 'list-remove'
                tooltip: i18n('Remove the selected URL')
                onClicked: {
                    urlsModel.remove(table.currentRow);
                    cfg_urlsModel = ConfigUtils.stringifyModel(urlsModel)
                }
            }
            Button {
                iconName: 'go-up'
                tooltip: i18n('Move the selected URL up')
                onClicked: {
                    urlsModel.move(table.currentRow,table.currentRow-1, 1);
                    table.selection.clear();
                    table.selection.select(table.currentRow-1,table.currentRow-1)
                    cfg_urlsModel = ConfigUtils.stringifyModel(urlsModel)
                }
            }
            Button {
                iconName: 'go-down'
                tooltip: i18n('Move the selected URL down')
                onClicked: {
                    urlsModel.move(table.currentRow, table.currentRow+1, 1);
                    table.selection.clear();
                    table.selection.select(table.currentRow+1,table.currentRow+1)
                    cfg_urlsModel = ConfigUtils.stringifyModel(urlsModel)
                }
            }
        }
    }

    Component.onCompleted: {
        var arrayURLs = ConfigUtils.getURLsObjectArray();
        for (var index in arrayURLs) {
            urlsModel.append({"url":arrayURLs[index]});
        }
    }
}
