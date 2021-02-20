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
    property bool showPinButton: plasmoid.configuration.showPinButton
    property bool pinButtonAlignmentLeft: plasmoid.configuration.pinButtonAlignmentLeft
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
    property bool bypassSSLErrors: plasmoid.configuration.bypassSSLErrors
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
    property bool notOffTheRecord: plasmoid.configuration.notOffTheRecord
    property string profileName: plasmoid.configuration.profileName

    signal handleSettingsUpdated();

    Plasmoid.preferredRepresentation: (displaySiteBehaviour)? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

    Plasmoid.fullRepresentation: webview
    
    Plasmoid.icon: webPopupIcon
    
    onUrlsModelChanged:{ loadURLs(); }

    onWebPopupHeightChanged:{ main.handleSettingsUpdated(); }

    onWebPopupWidthChanged:{  main.handleSettingsUpdated(); }
    
    onZoomFactorCfgChanged:{  main.handleSettingsUpdated(); }

    onNotOffTheRecordChanged:{ 
        //console.debug("test");
        //console.debug(Plasmoid.fullRepresentation);
        //Plasmoid.fullRepresentation = null; 
        //webviewID.destroy();
        //var component = Qt.createComponent("WebviewWebslice.qml");
        //webview = component.createObject(webview, {id: "webviewID"});
        //Plasmoid.fullRepresentation=component;
        //webview = component.createObject(webview);
        //webview.createObject(WebviewWebslice);
        //webview = webviewTemp;
    }

    //onKeysseqChanged: { main.handleSettingsUpdated(); }

    Binding {
        target: plasmoid
        property: "hideOnWindowDeactivate"
        value: !plasmoid.configuration.pin
    }


    property Component webview: WebEngineView{
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

        onCertificateError: if(bypassSSLErrors){error.ignoreCertificateError()}

        property bool isExternalLink: false
        
        profile:  WebEngineProfile{
            httpUserAgent: (enableCustomUA)?customUA:httpUserAgent
            offTheRecord: !notOffTheRecord
            storageName: (notOffTheRecord)?profileName:"webslice-data"
        }


        /* Access to system palette */
        SystemPalette { id: myPalette}
        
        /**
         * Pin button
         */
        Button {
            id: pinButton
            x: pinButtonAlignmentLeft?y:parent.width-y-2*Math.round(units.gridUnit)
            width: Math.round(units.gridUnit)
            height: width
            checkable: true
            icon.name: "window-pin"
            hoverEnabled: false
            focusPolicy: Qt.NoFocus
            checked: plasmoid.configuration.pin
            onCheckedChanged: plasmoid.configuration.pin = checked
            visible: !displaySiteBehaviour && showPinButton
            z:1
            palette {
                button: plasmoid.configuration.pin ? myPalette.highlight : myPalette.button
            }
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
            contextMenu.open(request.x, request.y)
        }


        /**
         * Get status of Ctrl key
         */
         PlasmaCore.DataSource {
            id: dataSource
            engine: "keystate"
            connectedSources: ["Ctrl"]
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
                onClicked: {
                    // Force reload if Ctrl pressed
                    if(dataSource.data["Ctrl"]["Pressed"]){
                        reloadFn(true);
                    }else{
                        reloadFn(false);
                    }
                }
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
                        icon: 'go-home'
                        onClicked: webviewID.url = websliceUrl
                    }
                }
            }
            
            PlasmaComponents.MenuItem {
                text: i18n('Go Home')
                icon: 'go-home'
                visible:(urlsToShow.count==0)
                enabled:(urlsToShow.count==0)
                onClicked: webviewID.url = websliceUrl
            }

            PlasmaComponents.MenuItem {
                text: i18n('Open current URL in default browser')
                icon: 'document-share'
                onClicked: Qt.openUrlExternally(webviewID.url)
            }
            
            PlasmaComponents.MenuItem{
                separator: true
                visible: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
            }
            
            PlasmaComponents.MenuItem {
                text: i18n('Open link\'s URL in default browser')
                icon: 'document-share'
                enabled: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                visible: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                onClicked: Qt.openUrlExternally(contextMenu.request.linkUrl)
            }
            
            PlasmaComponents.MenuItem {
                text: i18n('Copy link\'s URL')
                icon: 'edit-copy'
                enabled: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                visible: (typeof contextMenu.request !== "undefined" && contextMenu.request.linkUrl && contextMenu.request.linkUrl != "")
                onClicked: {
                    copyURLTextEdit.text = contextMenu.request.linkUrl
                    copyURLTextEdit.selectAll()
                    copyURLTextEdit.copy()
                }
                TextEdit{
                    id: copyURLTextEdit
                    visible: false
                }
            }
            
            PlasmaComponents.MenuItem{
                separator: true
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
                webviewID.reloadAndBypassCache()
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
