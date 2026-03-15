import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    color: "#11111b"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Toolbar
        Rectangle {
            Layout.fillWidth: true
            height: 36
            color: "#181825"
            border.color: "#313244"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 4

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 26
                    height: 26
                    radius: 4
                    color: addBtn.containsMouse ? "#313244" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "+"
                        color: "#a6adc8"
                        font.pixelSize: 18
                        font.weight: Font.Light
                    }

                    MouseArea {
                        id: addBtn
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            TableData.insertRow()
                            tableView.positionViewAtRow(tableView.rows - 1, Qt.AlignBottom)
                        }
                    }
                }
            }
        }

        // Header view
        HorizontalHeaderView {
            id: headerView
            syncView: tableView
            Layout.fillWidth: true
            clip: true

            delegate: Rectangle {
                implicitWidth: 140
                implicitHeight: 32
                color: "#181825"
                border.color: "#313244"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 8
                    text: display
                    color: "#a6adc8"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                }
            }
        }

        // Table + row header
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            VerticalHeaderView {
                id: rowHeader
                syncView: tableView
                Layout.fillHeight: true
                width: 48
                clip: true

                delegate: Rectangle {
                    implicitWidth: 48
                    implicitHeight: 32
                    color: "#181825"
                    border.color: "#313244"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: display
                        color: "#585b70"
                        font.pixelSize: 11
                    }
                }
            }

            TableView {
                id: tableView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: TableData

                editTriggers: TableView.DoubleTapped | TableView.EditKeyPressed

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    background: Rectangle { color: "#181825" }
                    contentItem: Rectangle { radius: 2; color: "#45475a" }
                }
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    background: Rectangle { color: "#181825" }
                    contentItem: Rectangle { radius: 2; color: "#45475a" }
                }

                delegate: Rectangle {
                    implicitWidth: 140
                    implicitHeight: 32
                    color: modified ? "#2a1a2e"
                                    : (row % 2 === 0 ? "#11111b" : "#181825")
                    border.color: tableView.currentRow === row ? "#585b70" : "#313244"
                    border.width: 1

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        text: display ?? ""
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                    }

                    TableView.editDelegate: FocusScope {
                        anchors.fill: parent

                        TextField {
                            anchors.fill: parent
                            text: display ?? ""
                            color: "#cdd6f4"
                            font.pixelSize: 13
                            leftPadding: 8
                            background: Rectangle {
                                color: "#313244"
                                border.color: "#cba6f7"
                                border.width: 1
                            }

                            onAccepted: {
                                TableView.view.model.setData(
                                    TableView.view.index(row, column), text)
                                TableView.view.closeEditor()
                            }
                        }
                    }
                }
            }
        }

        // Status bar (shown when there are unsaved changes)
        Rectangle {
            visible: TableData.dirty
            Layout.fillWidth: true
            height: 36
            color: "#1e1e2e"
            border.color: "#313244"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Text {
                    text: "Hay cambios sin guardar"
                    color: "#f9e2af"
                    font.pixelSize: 12
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "Revertir"
                    onClicked: TableData.revert()
                    contentItem: Text {
                        text: parent.text
                        color: "#f38ba8"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                    }
                    background: Rectangle {
                        color: parent.hovered ? "#313244" : "transparent"
                        radius: 4
                        border.color: "#f38ba8"
                        border.width: 1
                    }
                    padding: 6
                }

                Button {
                    text: "Guardar"
                    onClicked: TableData.commit()
                    contentItem: Text {
                        text: parent.text
                        color: "#1e1e2e"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                    }
                    background: Rectangle {
                        color: parent.hovered ? "#a6e3a1" : "#a6e3a1"
                        radius: 4
                    }
                    padding: 6
                }
            }
        }
    }
}
