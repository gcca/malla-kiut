import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 1024
    height: 680
    title: "Malla Kiut"

    ConnectionDialog {
        id: connectionDialog
        anchors.centerIn: parent
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        handle: Rectangle {
            implicitWidth: 1
            color: SplitHandle.hovered || SplitHandle.pressed ? "#45475a" : "#313244"
        }

        LeftSidebar {
            SplitView.preferredWidth: 220
            SplitView.minimumWidth: 140
            SplitView.maximumWidth: 400

            onConnectRequested: connectionDialog.open()
        }

        Rectangle {
            SplitView.fillWidth: true
            color: "#11111b"

            TableGrid {
                anchors.fill: parent
                visible: TableData.currentTable !== ""
            }

            Column {
                anchors.centerIn: parent
                spacing: 12
                visible: TableData.currentTable === ""

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Database.connected ? "Selecciona una tabla" : "Conecta a una base de datos"
                    color: "#585b70"
                    font.pixelSize: 16
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Database.connected ? "" : "Usa el botón + en el sidebar"
                    color: "#45475a"
                    font.pixelSize: 13
                    visible: !Database.connected
                }
            }
        }
    }
}
