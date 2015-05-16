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

Item {
	id: main
	
	//property alias mainWebview: webview.url
	
	property string websliceUrl: plasmoid.configuration.websliceUrl
	property bool enableReload: plasmoid.configuration.enableReload
	property int reloadIntervalMin: plasmoid.configuration.reloadIntervalMin
	property bool enableTransparency: plasmoid.configuration.enableTransparency
	
	property bool enableJSID: plasmoid.configuration.enableJSID
	property string jsSelector: plasmoid.configuration.jsSelector
	
	Layout.fillWidth: true
	Layout.fillHeight: true

	WebView {
		id: webview
		url: websliceUrl
		anchors.fill: parent
		experimental.preferredMinimumContentsWidth: 100
		experimental.transparentBackground: enableTransparency
		
		onLoadingChanged: {
            if (enableJSID && loadRequest.status === WebView.LoadSucceededStatus) {
                experimental.evaluateJavaScript(
                    jsSelector + ".scrollIntoView(true);");
            }
        }
		
		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			onClicked: {
				if(mouse.button & Qt.RightButton) {
					contextMenu.popup()
				}
			}
		}
	}

	Menu {
		id: contextMenu
		MenuItem {
			iconName: "view-refresh"
			text: i18n('Reload')
			onTriggered: webview.reload()
		}
	}

    Timer {
        interval: 1000 * 60 * reloadIntervalMin
        running: enableReload
        repeat: true
        onTriggered: {
			webview.reload()
        }
    }
}
