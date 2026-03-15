import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Dialog {
    id: root

    title: "Conectar a base de datos"
    modal: true
    width: 420
    height: 360

    background: Rectangle {
        color: "#1e1e2e"
        radius: 8
        border.color: "#313244"
        border.width: 1
    }

    header: Item {
        height: 48
        Text {
            anchors.centerIn: parent
            text: root.title
            color: "#cdd6f4"
            font.pixelSize: 14
            font.weight: Font.Medium
        }
    }

    contentItem: ColumnLayout {
        spacing: 16

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            background: Rectangle { color: "#181825"; radius: 4 }

            TabButton {
                text: "SQLite"
                width: implicitWidth
                contentItem: Text {
                    text: parent.text
                    color: tabBar.currentIndex === 0 ? "#cdd6f4" : "#585b70"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                    color: tabBar.currentIndex === 0 ? "#313244" : "transparent"
                    radius: 4
                }
            }

            TabButton {
                text: "PostgreSQL"
                width: implicitWidth
                contentItem: Text {
                    text: parent.text
                    color: tabBar.currentIndex === 1 ? "#cdd6f4" : "#585b70"
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle {
                    color: tabBar.currentIndex === 1 ? "#313244" : "transparent"
                    radius: 4
                }
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            // SQLite tab
            ColumnLayout {
                spacing: 8

                RowLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        color: "#181825"
                        radius: 4
                        border.color: "#313244"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            text: fileDialog.selectedFile.toString().replace(/.*\//, "") || "Ningún archivo seleccionado"
                            color: fileDialog.selectedFile.toString() ? "#cdd6f4" : "#585b70"
                            font.pixelSize: 13
                            elide: Text.ElideLeft
                        }
                    }

                    Button {
                        text: "Examinar"
                        onClicked: fileDialog.open()
                        contentItem: Text {
                            text: parent.text
                            color: "#cdd6f4"
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                        }
                        background: Rectangle {
                            color: parent.hovered ? "#45475a" : "#313244"
                            radius: 4
                        }
                        padding: 8
                    }
                }

                Item { Layout.fillHeight: true }
            }

            // PostgreSQL tab
            GridLayout {
                columns: 2
                columnSpacing: 8
                rowSpacing: 8
                Layout.fillWidth: true

                Text { text: "Host"; color: "#a6adc8"; font.pixelSize: 13 }
                TextField {
                    id: pgHost
                    text: "localhost"
                    Layout.fillWidth: true
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    background: Rectangle { color: "#181825"; radius: 4; border.color: "#313244" }
                    leftPadding: 10
                }

                Text { text: "Puerto"; color: "#a6adc8"; font.pixelSize: 13 }
                TextField {
                    id: pgPort
                    text: "5432"
                    Layout.fillWidth: true
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    background: Rectangle { color: "#181825"; radius: 4; border.color: "#313244" }
                    leftPadding: 10
                    inputMethodHints: Qt.ImhDigitsOnly
                }

                Text { text: "Base de datos"; color: "#a6adc8"; font.pixelSize: 13 }
                TextField {
                    id: pgDatabase
                    Layout.fillWidth: true
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    background: Rectangle { color: "#181825"; radius: 4; border.color: "#313244" }
                    leftPadding: 10
                }

                Text { text: "Usuario"; color: "#a6adc8"; font.pixelSize: 13 }
                TextField {
                    id: pgUser
                    Layout.fillWidth: true
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    background: Rectangle { color: "#181825"; radius: 4; border.color: "#313244" }
                    leftPadding: 10
                }

                Text { text: "Contraseña"; color: "#a6adc8"; font.pixelSize: 13 }
                TextField {
                    id: pgPassword
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    color: "#cdd6f4"
                    font.pixelSize: 13
                    background: Rectangle { color: "#181825"; radius: 4; border.color: "#313244" }
                    leftPadding: 10
                }
            }
        }
    }

    footer: RowLayout {
        spacing: 8
        Item { Layout.fillWidth: true }

        Text {
            id: errorLabel
            color: "#f38ba8"
            font.pixelSize: 12
            visible: text.length > 0
        }

        Button {
            text: "Cancelar"
            onClicked: root.reject()
            contentItem: Text {
                text: parent.text
                color: "#a6adc8"
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle {
                color: parent.hovered ? "#313244" : "transparent"
                radius: 4
                border.color: "#313244"
            }
            padding: 8
            Layout.rightMargin: 4
        }

        Button {
            text: "Conectar"
            Layout.rightMargin: 12
            onClicked: {
                errorLabel.text = ""
                if (tabBar.currentIndex === 0) {
                    if (!fileDialog.selectedFile.toString()) {
                        errorLabel.text = "Selecciona un archivo"
                        return
                    }
                    if (Database.connectSQLite(fileDialog.selectedFile))
                        root.accept()
                } else {
                    if (Database.connectPostgres(pgHost.text, parseInt(pgPort.text),
                                                  pgDatabase.text, pgUser.text,
                                                  pgPassword.text))
                        root.accept()
                }
            }
            contentItem: Text {
                text: parent.text
                color: "#1e1e2e"
                font.pixelSize: 13
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
            }
            background: Rectangle {
                color: parent.hovered ? "#b4befe" : "#cba6f7"
                radius: 4
            }
            padding: 8
        }
    }

    FileDialog {
        id: fileDialog
        title: "Seleccionar archivo SQLite"
        nameFilters: ["SQLite (*.db *.sqlite *.sqlite3)", "Todos los archivos (*)"]
    }

    Connections {
        target: Database
        function onErrorOccurred(message) {
            errorLabel.text = message
        }
    }
}
