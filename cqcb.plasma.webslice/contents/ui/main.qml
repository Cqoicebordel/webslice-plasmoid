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

import QtQuick 2.0
import QtWebKit 3.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import QtWebKit.experimental 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	id: main
	//property alias mainWebview: webview.url
	
	property string websliceUrl: plasmoid.configuration.websliceUrl
	property bool enableReload: plasmoid.configuration.enableReload
	property int reloadIntervalSec: plasmoid.configuration.reloadIntervalSec
	property bool enableTransparency: plasmoid.configuration.enableTransparency
	property bool displaySiteBehaviour: plasmoid.configuration.displaySiteBehaviour
	property bool buttonBehaviour: plasmoid.configuration.buttonBehaviour
	property bool reloadAnimation: plasmoid.configuration.reloadAnimation
	
	property bool enableJSID: plasmoid.configuration.enableJSID
	property string jsSelector: plasmoid.configuration.jsSelector
	property string minimumContentWidth: plasmoid.configuration.minimumContentWidth
	property bool enableJS: plasmoid.configuration.enableJS
	property string js: plasmoid.configuration.js
	
	Layout.fillWidth: true
	Layout.fillHeight: true
	
	
	Plasmoid.preferredRepresentation: (displaySiteBehaviour)? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation

	WebView {
		id: webview
		url: websliceUrl
		anchors.fill: parent
		experimental.preferredMinimumContentsWidth: minimumContentWidth
		experimental.transparentBackground: enableTransparency
		
		onLoadingChanged: {
            if (enableJSID && loadRequest.status === WebView.LoadSucceededStatus) {
                experimental.evaluateJavaScript(
                    jsSelector + ".scrollIntoView(true);");
            }
            if (enableJS && loadRequest.status === WebView.LoadSucceededStatus) {
                experimental.evaluateJavaScript(js);
            }
            if (loadRequest.status === WebView.LoadSucceededStatus) {
				busyIndicator.visible = false;
				busyIndicator.running = false;
			}
        }
		
		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			onClicked: {
				if(mouse.button & Qt.RightButton) {
					contextMenu.open(mouse.x, mouse.y)
				}
			}
		}
	}
	
    PlasmaComponents.ContextMenu {
        id: contextMenu
        
        PlasmaComponents.MenuItem {
            text: i18n('Reload')
            icon: 'view-refresh'
            onClicked: reload()
        }
        
        PlasmaComponents.MenuItem {
            text: i18n('Configure')
            icon: 'configure'
            onClicked: plasmoid.action("configure").trigger()
        }
    }

    Timer {
        interval: 1000 * reloadIntervalSec
        running: enableReload
        repeat: true
        onTriggered: {
			reload()
        }
    }
    
    PlasmaComponents.BusyIndicator {
        id: busyIndicator
        anchors.fill: parent
        visible: false
        running: false
    }
    
    function reload() {
		if(reloadAnimation){
			busyIndicator.visible = true;
			busyIndicator.running = true;
		}
		webview.reload();
    }
}
