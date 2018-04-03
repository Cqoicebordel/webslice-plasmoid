/***************************************************************************
 *   Copyright 2015 by Cqoicebordel <cqoicebordel@gmail.com>               *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.7
import QtWebKit 3.0
//import QtWebEngine 1.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtWebKit.experimental 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQml 2.2

import "../code/utils.js" as ConfigUtils



Item {
    id: main

    property string websliceUrl: plasmoid.configuration.websliceUrl
    property bool enableReload: plasmoid.configuration.enableReload
    property int reloadIntervalSec: plasmoid.configuration.reloadIntervalSec
    property bool enableTransparency: plasmoid.configuration.enableTransparency
    property bool displaySiteBehaviour: plasmoid.configuration.displaySiteBehaviour
    property bool buttonBehaviour: plasmoid.configuration.buttonBehaviour
    property int webPopupWidth: plasmoid.configuration.webPopupWidth
    property int webPopupHeight: plasmoid.configuration.webPopupHeight
    property bool reloadAnimation: plasmoid.configuration.reloadAnimation

    property bool enableJSID: plasmoid.configuration.enableJSID
    property string jsSelector: plasmoid.configuration.jsSelector
    property string minimumContentWidth: plasmoid.configuration.minimumContentWidth
    property bool enableJS: plasmoid.configuration.enableJS
    property string js: plasmoid.configuration.js

    property string urlsModel: plasmoid.configuration.urlsModel

    signal handleSettingsUpdated();
    signal popupSizeChanged();

    Layout.fillWidth: true
    Layout.fillHeight: true


    Plasmoid.preferredRepresentation: (displaySiteBehaviour)? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: webview

    onUrlsModelChanged:{
        loadURLs();
    }

    onWebPopupHeightChanged:{
        main.popupSizeChanged();
    }

    onWebPopupWidthChanged:{
        main.popupSizeChanged();
    }


    property Component webview: WebView {
        id: webviewID
        url: websliceUrl
        anchors.fill: parent
        experimental.preferredMinimumContentsWidth: minimumContentWidth
        experimental.transparentBackground: enableTransparency

        width: (displaySiteBehaviour) ? 0 : webPopupWidth
        height: (displaySiteBehaviour) ? 0 : webPopupHeight

        onWidthChanged: updateSizeHints()
        onHeightChanged: updateSizeHints()

        property bool isExternalLink

        Connections {
            target: main
            onPopupSizeChanged: {
                updateSizeHints();
            }
        }

        /**
         * Hack to handle the size of the popup when displayed as a compactRepresentation
         */
        function updateSizeHints() {
            //console.debug(webviewID.height + " " + webPopupHeight + " " + plasmoid.configuration.webPopupHeight + " " +displaySiteBehaviour);
            if(!displaySiteBehaviour){
                webviewID.height = webPopupHeight;
                webviewID.width = webPopupWidth;
                webviewID.reload();
                //webviewID.zoomFactor = Math.min(1, webviewID.width / 1000);
            }
        }

        /**
         * Handle everything around web request : display the busy indicator, and run JS
         */
        onLoadingChanged: {
            if (enableJSID && loadRequest.status === WebView.LoadSucceededStatus) {
                experimental.evaluateJavaScript(
                    jsSelector + ".scrollIntoView(true);");
            }
            if (enableJS && loadRequest.status === WebView.LoadSucceededStatus) {
                experimental.evaluateJavaScript(js);
            }
            if (loadRequest && loadRequest.status === WebView.LoadSucceededStatus) {
                busyIndicator.visible = false;
                busyIndicator.running = false;
            }
        }

        /**
         * Open the middle clicked (or ctrl+clicked) link in the default browser
         */
        onNavigationRequested: {
            if(isExternalLink){
                request.action = WebView.IgnoreRequest;
                Qt.openUrlExternally(request.url);
            }
        }

        /**
         * Display the context menu
         */
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
            propagateComposedEvents:true
            onReleased: mouse.accepted = false;
            onDoubleClicked: mouse.accepted = false;
            onPositionChanged: mouse.accepted = false;
            onPressAndHold: mouse.accepted = false;
            onClicked: {
                if (mouse.button & Qt.RightButton) {
                    contextMenu.open(mapToItem(webviewID, mouseX, mouseY).x, mapToItem(webviewID, mouseX, mouseY).y)
                    isExternalLink = false;
                }else if(mouse.button & Qt.MiddleButton || ((mouse.button & Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier))){
                    mouse.accepted = false
                    isExternalLink = true
                }else{
                    mouse.accepted = false
                    isExternalLink = false
                }
            }
            onPressed: {
                if (mouse.button & Qt.RightButton) {
                    contextMenu.open(mapToItem(webviewID, mouseX, mouseY).x, mapToItem(webviewID, mouseX, mouseY).y)
                    isExternalLink = false;
                }else if(mouse.button & Qt.MiddleButton || ((mouse.button & Qt.LeftButton) && (mouse.modifiers & Qt.ControlModifier))){
                    mouse.accepted = false
                    isExternalLink = true
                }else{
                    mouse.accepted = false
                    isExternalLink = false
                }
            }
        }

        /**
         * Context menu
         */
        PlasmaComponents.ContextMenu {
            id: contextMenu

            PlasmaComponents.MenuItem {
                text: i18n('Back')
                icon: 'draw-arrow-back'
                enabled: webviewID.canGoBack
                onClicked: webviewID.goBack()
            }

            PlasmaComponents.MenuItem {
                text: i18n('Forward')
                icon: 'draw-arrow-forward'
                enabled: webviewID.canGoForward
                onClicked: webviewID.goForward()
            }

            PlasmaComponents.MenuItem {
                text: i18n('Reload')
                icon: 'view-refresh'
                onClicked: reloadFn()
            }

            PlasmaComponents.MenuItem {
                id: gotourls
                text: i18n('Go to')
                icon: 'go-jump'
                visible:(urlsToShow.count>0)
                enabled:(urlsToShow.count>0)

                /**
                 * Dynamic context menu
                 * Display the principal URL first, then the list
                 */
                PlasmaComponents.ContextMenu {
                    id:dynamicMenu
                    visualParent: gotourls.action
                    PlasmaComponents.MenuItem {
                        text: websliceUrl
                        icon: 'link'
                        onClicked: webviewID.url = websliceUrl
                    }
                }
            }

            PlasmaComponents.MenuItem {
                text: i18n('Open current URL in default browser')
                icon: 'document-share'
                onClicked: Qt.openUrlExternally(webviewID.url)
            }

            PlasmaComponents.MenuItem {
                text: i18n('Configure')
                icon: 'configure'
                onClicked: plasmoid.action("configure").trigger()
            }
        }

        Connections {
            target: main
            onHandleSettingsUpdated: {
                loadMenu();
            }
        }

        function addEntry(stringURL) {
            var menuItemI = menuItem.createObject(dynamicMenu, {text: stringURL, icon: 'link', "stringURL":stringURL});
            menuItemI.clicked.connect(function() { webviewID.url = stringURL; });
        }

        Component {
            id: menuItem
            PlasmaComponents.MenuItem {
            }
        }

        function loadMenu() {
            for(var i=1; i<dynamicMenu.content.length; i++){
                dynamicMenu.content[i].visible=false;
            }

            for(var i=0; i<urlsToShow.count; i++){
                var entry = addEntry(urlsToShow.get(i).url);
            }
        }

        Component.onCompleted: {
            loadURLs();
        }

        Timer {
            interval: 1000 * reloadIntervalSec
            running: enableReload
            repeat: true
            onTriggered: {
                reloadFn()
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.left: parent.left
            anchors.top: parent.top
            width: Math.min(webviewID.width, webviewID.height);
            height: Math.min(webviewID.width, webviewID.height);
            anchors.leftMargin: (webviewID.width - busyIndicator.width)/2
            anchors.topMargin: (webviewID.height - busyIndicator.height)/2
            visible: false
            running: false
        }

        function reloadFn() {
            if(reloadAnimation){
                busyIndicator.visible = true;
                busyIndicator.running = true;
            }
            webviewID.reload();
        }
    }

    ListModel {
        id: urlsToShow
    }

    function loadURLs(){
        var arrayURLs = ConfigUtils.getURLsObjectArray();
        urlsToShow.clear();
        for (var index in arrayURLs) {
            urlsToShow.append({"url":arrayURLs[index]});
        }

        main.handleSettingsUpdated();
    }
}
