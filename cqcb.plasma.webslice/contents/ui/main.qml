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

import QtQuick 2.12
import QtWebEngine 1.8
import QtQuick.Layouts 1.10
import QtQuick.Controls 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQml 2.12

import "../code/utils.js" as ConfigUtils



Item {
    id: main

    property string websliceUrl: plasmoid.configuration.websliceUrl
    property double zoomFactorCfg: plasmoid.configuration.zoomFactor
    property bool enableReload: plasmoid.configuration.enableReload
    property int reloadIntervalSec: plasmoid.configuration.reloadIntervalSec
    property bool displaySiteBehaviour: plasmoid.configuration.displaySiteBehaviour
    property bool buttonBehaviour: plasmoid.configuration.buttonBehaviour
    property int webPopupWidth: plasmoid.configuration.webPopupWidth
    property int webPopupHeight: plasmoid.configuration.webPopupHeight
    property string webPopupIcon: plasmoid.configuration.webPopupIcon
    property bool reloadAnimation: plasmoid.configuration.reloadAnimation
    property bool backgroundColorWhite: plasmoid.configuration.backgroundColorWhite
    property bool backgroundColorTransparent: plasmoid.configuration.backgroundColorTransparent
    property bool backgroundColorTheme: plasmoid.configuration.backgroundColorTheme
    property bool backgroundColorCustom: plasmoid.configuration.backgroundColorCustom
    property string customBackgroundColor: plasmoid.configuration.customBackgroundColor

    property bool enableScrollTo: plasmoid.configuration.enableScrollTo
    property int scrollToX: plasmoid.configuration.scrollToX
    property int scrollToY: plasmoid.configuration.scrollToY
    property bool enableReloadOnActivate: plasmoid.configuration.enableReloadOnActivate
    property bool enableJSID: plasmoid.configuration.enableJSID
    property string jsSelector: plasmoid.configuration.jsSelector
    property bool enableJS: plasmoid.configuration.enableJS
    property string js: plasmoid.configuration.js

    property string urlsModel: plasmoid.configuration.urlsModel

    property string keysSeqBack: plasmoid.configuration.keysSeqBack
    property string keysSeqForward: plasmoid.configuration.keysSeqForward
    property string keysSeqReload: plasmoid.configuration.keysSeqReload
    property string keysSeqStop: plasmoid.configuration.keysSeqStop
    property bool fillWidthAndHeight: plasmoid.configuration.fillWidthAndHeight

    signal handleSettingsUpdated();

    Plasmoid.preferredRepresentation: (displaySiteBehaviour)? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: webview
    
    Plasmoid.icon: webPopupIcon
    
    onUrlsModelChanged:{ loadURLs(); }

    onWebPopupHeightChanged:{ main.handleSettingsUpdated(); }

    onWebPopupWidthChanged:{  main.handleSettingsUpdated(); }
    
    onZoomFactorCfgChanged:{  main.handleSettingsUpdated(); }
    
    //onKeysseqChanged: { main.handleSettingsUpdated(); }


    property Component webview: WebEngineView {
        id: webviewID
        url: websliceUrl
        anchors.fill: parent

        backgroundColor: backgroundColorWhite?"white":(backgroundColorTransparent?"transparent":(backgroundColorTheme?theme.viewBackgroundColor:(backgroundColorCustom?customBackgroundColor:"black")))

        width: (displaySiteBehaviour) ? 0 : webPopupWidth
        height: (displaySiteBehaviour) ? 0 : webPopupHeight
        Layout.fillWidth: fillWidthAndHeight
        Layout.fillHeight: fillWidthAndHeight

        zoomFactor: zoomFactorCfg
        
        onWidthChanged: updateSizeHints()
        onHeightChanged: updateSizeHints()

        property bool isExternalLink: false
        
        /*
         * When using the shortcut to activate the Plasmoid
         * Thanks to https://github.com/pronobis/webslice-plasmoid/commit/07633bf508c1876d45645415dfc98b802322d407
         */
        Plasmoid.onActivated: {
            if(enableReloadOnActivate){
                reloadFn();
            }
        }

        Connections {
            target: main
            onHandleSettingsUpdated: {
                loadMenu();
                updateSizeHints();
            }
        }
        
        Shortcut {
            id:shortreload
            sequences: [StandardKey.Refresh, keysSeqReload]
            onActivated: reloadFn()
        }
        
        Shortcut {
            sequences: [StandardKey.Back, keysSeqBack]
            onActivated: goBack()
        }
        
        Shortcut {
            sequences: [StandardKey.Forward, keysSeqForward]
            onActivated: goForward()
        }
        
        Shortcut {
            sequences: [StandardKey.Cancel, keysSeqStop]
            onActivated: {
                stop();
                busyIndicator.visible = false;
                busyIndicator.running = false;
            }
        }

        /**
         * Hack to handle the size of the popup when displayed as a compactRepresentation
         */
        function updateSizeHints() {
            //console.debug(webviewID.height + " " + webPopupHeight + " " + plasmoid.configuration.webPopupHeight + " " +displaySiteBehaviour);
            webviewID.zoomFactor = zoomFactorCfg;
            if(!displaySiteBehaviour){
                webviewID.height = webPopupHeight;
                webviewID.width = webPopupWidth;
                webviewID.reload();
                //console.debug("inside" + webviewID.height + " " + webPopupHeight + " " + plasmoid.configuration.webPopupHeight + " " +displaySiteBehaviour);
            }
        }

        /**
         * Handle everything around web request : display the busy indicator, and run JS
         */
        onLoadingChanged: {
            webviewID.zoomFactor = zoomFactorCfg;
            if (enableScrollTo && loadRequest.status === WebEngineView.LoadSucceededStatus) {
                runJavaScript("window.scrollTo("+scrollToX+", "+scrollToY+");");
            }
            if (enableJSID && loadRequest.status === WebEngineView.LoadSucceededStatus) {
                runJavaScript(jsSelector + ".scrollIntoView(true);");
            }
            if (enableJS && loadRequest.status === WebEngineView.LoadSucceededStatus) {
                runJavaScript(js);
            }
            if (loadRequest && (loadRequest.status === WebEngineView.LoadSucceededStatus || loadRequest.status === WebEngineLoadRequest.LoadFailedStatus)) {
                busyIndicator.visible = false;
                busyIndicator.running = false;
            }
        }

        /**
         * Open the middle clicked (or ctrl+clicked) link in the default browser
         */
        onNavigationRequested: {
            webviewID.zoomFactor = zoomFactorCfg;
            if(isExternalLink){
                isExternalLink = false;
                request.action = WebEngineView.IgnoreRequest;
                Qt.openUrlExternally(request.url);
            }else if(reloadAnimation){
                busyIndicator.visible = true;
                busyIndicator.running = true;
            }
        }
        
        onNewViewRequested: {
            if(request.userInitiated){
                isExternalLink = true;
            }else{
                isExternalLink = false;
            }
        }
        
        /**
         * Show context menu
         */
        onContextMenuRequested: {
            request.accepted = true
            contextMenu.request = request
            contextMenu.open(request.x, request.y)
        }

        /**
         * Context menu
         */
        PlasmaComponents.ContextMenu {
            property var request
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
                text: i18n('Open link URL in default browser')
                icon: 'document-share'
                enabled: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                visible: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                onClicked: Qt.openUrlExternally(contextMenu.request.linkUrl)
            }

            PlasmaComponents.MenuItem {
                text: i18n('Configure')
                icon: 'configure'
                onClicked: plasmoid.action("configure").trigger()
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
            z: 5
            opacity: 1
            
            anchors.left: parent.left
            anchors.top: parent.top
            width: Math.min(webviewID.width, webviewID.height);
            height: Math.min(webviewID.width, webviewID.height);
            anchors.leftMargin: (webviewID.width - busyIndicator.width)/2
            anchors.topMargin: (webviewID.height - busyIndicator.height)/2
            visible: false
            running: false
            
            contentItem: PlasmaCore.SvgItem {
                id: indicatorItem
                svg: PlasmaCore.Svg {
                    imagePath: "widgets/busywidget"
                }
                
                RotationAnimator on rotation {
                    from: 0
                    to: 360
                    duration:2000
                    running: busyIndicator.running && indicatorItem.visible && indicatorItem.opacity > 0;
                    loops: Animation.Infinite
                }
            }
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
