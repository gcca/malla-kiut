import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    signal connectRequested()

    color: "#1e1e2e"

    ColumnLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 24
        }
        spacing: 4

        RowLayout {
            Layout.leftMargin: 12
            Layout.rightMargin: 8
            Layout.bottomMargin: 12

            Text {
                text: "malla-kiut"
                color: "#cdd6f4"
                font.pixelSize: 13
                font.weight: Font.Bold
                Layout.fillWidth: true
            }

            Rectangle {
                width: 24
                height: 24
                color: connectBtn.containsMouse ? "#313244" : "transparent"
                radius: 4

                Text {
                    anchors.centerIn: parent
                    text: "+"
                    color: "#a6adc8"
                    font.pixelSize: 16
                    font.weight: Font.Light
                }

                MouseArea {
                    id: connectBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.connectRequested()
                }
            }
        }

        // Tables list (when connected)
        ListView {
            id: tablesList
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: Database.connected
            model: Database.tables
            clip: true
            spacing: 2

            delegate: Rectangle {
                width: tablesList.width
                height: 34
                color: delegateArea.containsMouse ? "#313244" : "transparent"
                radius: 6

                Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: 4
                    height: parent.height * 0.5
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 2
                    color: "#cba6f7"
                    visible: false // TODO: highlight selected
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 16
                    anchors.rightMargin: 8
                    text: modelData
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    elide: Text.ElideRight
                }

                MouseArea {
                    id: delegateArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Database.selectTable(modelData)
                }
            }
        }

        // Empty state (when not connected)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: !Database.connected

            Text {
                anchors.centerIn: parent
                text: "Sin conexión"
                color: "#45475a"
                font.pixelSize: 12
            }
        }
    }
}
