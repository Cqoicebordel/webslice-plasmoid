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
    property bool enableJSID: plasmoid.configuration.enableJSID
    property string jsSelector: plasmoid.configuration.jsSelector
    property bool enableCustomUA: plasmoid.configuration.enableCustomUA
    property string customUA: plasmoid.configuration.customUA
    property bool enableReloadOnActivate: plasmoid.configuration.enableReloadOnActivate
    property bool scrollbarsShow: plasmoid.configuration.scrollbarsShow
    property bool scrollbarsOverflow: plasmoid.configuration.scrollbarsOverflow
    property bool scrollbarsWebkit: plasmoid.configuration.scrollbarsWebkit
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

        profile:  WebEngineProfile{
            httpUserAgent: (enableCustomUA)?customUA:httpUserAgent
        }
        
        /*
         * When using the shortcut to activate the Plasmoid
         * Thanks to https://github.com/pronobis/webslice-plasmoid/commit/07633bf508c1876d45645415dfc98b802322d407
         */
        Plasmoid.onActivated: {
            if(enableReloadOnActivate){
                reloadFn(false);
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
            onActivated: reloadFn(false)
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
            if (scrollbarsOverflow && loadRequest.status === WebEngineView.LoadSucceededStatus) {
                runJavaScript("document.body.style.overflow='hidden';");
            }else if (scrollbarsWebkit && loadRequest.status === WebEngineView.LoadSucceededStatus){
                runJavaScript("var style = document.createElement('style');
                                style.innerHTML = `body::-webkit-scrollbar {display: none;}`;
                                document.head.appendChild(style);");
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
            contextMenu.popup(request.x, request.y)
        }

        /**
         * Context menu
         */
        Menu {
            property var request
            id: contextMenu

            MenuItem {
                text: i18n('Back')
                icon.name: 'draw-arrow-back'
                enabled: webviewID.canGoBack
                onClicked: webviewID.goBack()
            }

            MenuItem {
                text: i18n('Forward')
                icon.name: 'draw-arrow-forward'
                enabled: webviewID.canGoForward
                onClicked: webviewID.goForward()
            }

            MenuItem {
                text: i18n('Reload')
                icon.name: 'view-refresh'

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onClicked: {
                        mouse.accepted = true;
                        if (mouse.modifiers & Qt.ControlModifier){
                            reloadFn(true);
                        }else{
                            reloadFn(false);
                        }
                        contextMenu.close();
                    }
                }
            }

            /**
            * Dynamic context menu
            * Display the principal URL first, then the list
            */
            Menu {
                id:dynamicMenu
                title: i18n('Go to')

                MenuItem {
                    text: websliceUrl
                    icon.name: 'go-home'
                    onClicked: webviewID.url = websliceUrl
                }
            }
            
            MenuItem {
                text: i18n('Go Home')
                icon.name: 'go-home'
                visible:(urlsToShow.count==0)
                enabled:(urlsToShow.count==0)
                onClicked: webviewID.url = websliceUrl
            }

            MenuItem {
                text: i18n('Open current URL in default browser')
                icon.name: 'document-share'
                onClicked: Qt.openUrlExternally(webviewID.url)
            }
            
            MenuItem {
                text: i18n('Open link\'s URL in default browser')
                icon.name: 'document-share'
                enabled: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                visible: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                onClicked: Qt.openUrlExternally(contextMenu.request.linkUrl)
            }

            MenuSeparator { }

            MenuItem {
                text: i18n('Configure')
                icon.name: 'configure'
                onClicked: plasmoid.action("configure").trigger()
            }
        }

        function addEntry(stringURL) {
            var menuItemI = menuItem.createObject(dynamicMenu, {text: stringURL, 'icon.name': 'link', "stringURL":stringURL});
            menuItemI.clicked.connect(function() { webviewID.url = stringURL; });
            dynamicMenu.addItem(menuItemI);
        }

        Component {
            id: menuItem
            MenuItem {
            }
        }

        function loadMenu() {
            for(var i=1; i<dynamicMenu.count; i++){
                dynamicMenu.itemAt(i).visible=false;
            }

            for(var i=0; i<urlsToShow.count; i++){
                var entry = addEntry(urlsToShow.get(i).url);
            }
            
            // A "Menu" is not a visible item. So, to style it, we need to use its parent.
            // Thanks to https://stackoverflow.com/a/59167505/4190513
            dynamicMenu.parent.visible = (urlsToShow.count>0);
            dynamicMenu.parent.icon.name = 'go-jump';
        }

        Component.onCompleted: {
            loadURLs();
        }

        Timer {
            interval: 1000 * reloadIntervalSec
            running: enableReload
            repeat: true
            onTriggered: {
                reloadFn(false)
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

        function reloadFn(force) {
            if(reloadAnimation){
                busyIndicator.visible = true;
                busyIndicator.running = true;
            }
            if(force){
                webviewID.reloadAndBypassCache();
            }else{
                webviewID.reload();
            }
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
