import QtQuick 2.9
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

ApplicationWindow {
    id: root
    visible: true
    height: 800
    width: 1000
    Rectangle {
        anchors.fill: parent
        GridLayout {
            anchors.fill: parent
            id: grid
            rowSpacing: 0
            columnSpacing: 0
            columns: 3

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#3d5a80"
                Layout.maximumWidth: 200

                ListView {
                    currentIndex: -1
                    id: list_modules
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 5
                    anchors.topMargin: 10
                    anchors.fill: parent
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    focus: true

                    model: handler.getModules

                    Component.onCompleted: {
                        currentIndex = 0
                    }

                    onCurrentIndexChanged: {
                        lbl_modulename.text = handler.getModuleFieldById(currentIndex, "name")
                        img_appicon.source = handler.getModuleFieldById(currentIndex, "appicon")
                        list_tutorials.model = handler.getEntries(currentIndex)
                        list_tutorials.currentIndex = 0
                    }


                    delegate: Item {
                        width: 200
                        height: 50
                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                list_modules.focus = true
                                list_modules.currentIndex = index
                            }
                        }
                        Row {
                            anchors.rightMargin: 10
                            anchors.leftMargin: 10
                            anchors.bottomMargin: 10
                            anchors.topMargin: 10
                            anchors.fill: parent
                            spacing: 10

                            Image {
                                width: 40
                                height: 40
                                antialiasing: true
                                source: appicon
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                color: "#ffffff"
                                text: name
                                anchors.verticalCenter: parent.verticalCenter
                                font.bold: true
                            }
                        }
                    }

                    highlight: Rectangle {
                        color: '#314866'
                        Text {
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            Rectangle {
                color: "#4a6fa5"
                Layout.maximumWidth: 175
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: list_tutorials
                    currentIndex: 0
                    anchors.topMargin: 10
                    anchors.fill: parent
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: ListModel {}

                    onCurrentIndexChanged: {
                        lbl_tutoname.text = handler.getEntryFieldById(list_modules.currentIndex, currentIndex, "name")
                        txt_description.text = handler.getEntryFieldById(list_modules.currentIndex, currentIndex, "description")
                        list_screenshots.model = handler.getEntryScreenshots(list_modules.currentIndex, currentIndex)
                    }

                    delegate: Item {
                        height: 50
                        anchors.right: parent.right
                        anchors.left: parent.left

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                list_tutorials.focus = true
                                list_tutorials.currentIndex = index
                            }
                        }

                        Row {
                            id: row2
                            anchors.rightMargin: 10
                            anchors.leftMargin: 10
                            anchors.bottomMargin: 10
                            anchors.topMargin: 10
                            anchors.fill: parent
                            spacing: 10

                            Text {
                                color: "#ffffff"
                                text: name
                                anchors.verticalCenter: parent.verticalCenter
                                font.bold: true
                            }
                        }
                    }

                    highlight: Rectangle {
                        color: "#3F5E8D"
                        Text {
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#e8edee"

                GridLayout {
                    anchors.fill: parent
                    id: grid_content
                    anchors.rightMargin: 15
                    anchors.leftMargin: 15
                    anchors.bottomMargin: 15
                    anchors.topMargin: 15
                    rows: 5
                    columns: 3
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Rectangle {
                        radius: 10
                        Layout.preferredHeight: 80
                        Layout.rowSpan: 2
                        color: "#00000000"
                        Layout.maximumWidth: 500
                        Layout.minimumWidth: 100
                        Layout.minimumHeight: 1
                        Layout.rightMargin: 0
                        Layout.bottomMargin: 0
                        Layout.leftMargin: 0
                        Layout.topMargin: 0
                        Layout.maximumHeight: 200
                        Layout.columnSpan: 1
                        Layout.fillHeight: false
                        Layout.fillWidth: true
                        ColumnLayout {
                            anchors.fill: parent
                            Layout.rightMargin: 5
                            Layout.bottomMargin: 5
                            Layout.leftMargin: 5
                            Layout.topMargin: 5
                            Layout.maximumHeight: 70
                            Layout.maximumWidth: 535
                            Layout.fillHeight: false
                            Layout.fillWidth: true
                            Layout.columnSpan: 2
                            Layout.rowSpan: 1

                            Text {
                                id: lbl_modulename
                                width: 80
                                height: 20
                                color: "#3d5a80"
                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                Layout.maximumHeight: 20
                                Layout.fillHeight: false
                                Layout.fillWidth: true
                                font.pixelSize: 12
                            }

                            RowLayout {
                                width: 100
                                height: 100
                                Layout.fillHeight: false
                                Layout.fillWidth: true

                                Image {
                                    id: img_appicon
                                    width: 100
                                    height: 100
                                    Layout.maximumWidth: 50
                                    Layout.maximumHeight: 50
                                    Layout.fillHeight: false
                                    Layout.fillWidth: false
                                    fillMode: Image.PreserveAspectFit
                                }

                                Text {
                                    id: lbl_tutoname
                                    color: "#4a6fa5"
                                    font.bold: true
                                    font.family: "Arial"
                                    renderType: Text.NativeRendering
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.fillHeight: false
                                    Layout.fillWidth: true
                                    font.pixelSize: 17
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 200
                        height: 200
                        color: "#00000000"
                        Layout.fillWidth: true
                        Layout.maximumHeight: 1
                        Layout.minimumHeight: 1
                        Layout.maximumWidth: 0
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        width: 100
                        height: 100
                        Layout.minimumHeight: 40
                        Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                        Layout.maximumWidth: 150
                        Layout.rightMargin: 0
                        Layout.bottomMargin: 0
                        Layout.leftMargin: 0
                        Layout.topMargin: 0
                        Layout.maximumHeight: 50
                        Layout.fillHeight: false
                        Layout.fillWidth: true

                        Button {
                            id: bt_advancedstart
                            text: qsTr("v")
                            Layout.fillHeight: true
                            Layout.maximumWidth: 30

                            onClicked: {
                                handler.btclick_start(list_modules.currentIndex, list_tutorials.currentIndex, 1)
                            }

                            contentItem: Text {
                                text: bt_advancedstart.text
                                font: bt_advancedstart.font
                                opacity: enabled ? 1.0 : 0.3
                                color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                color: bt_advancedstart.down ? "#00b248" : "#00e676"
                                radius: 5
                            }
                        }

                        Button {

                            id: bt_start
                            text: qsTr("Start")
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            display: AbstractButton.TextOnly
                            font.pointSize: 10
                            flat: false
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            onClicked: {
                                handler.btclick_start(list_modules.currentIndex, list_tutorials.currentIndex, 0)
                            }

                            contentItem: Text {
                                text: bt_start.text
                                font: bt_start.font
                                opacity: enabled ? 1.0 : 0.3
                                color: "#ffffff"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                color: bt_start.down ? "#009624" : "#00c853"
                                radius: 5
                            }
                        }
                    }

                    ListView {
                        id: list_screenshots
                        x: 0
                        y: 0
                        width: 110
                        height: 215
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        snapMode: ListView.SnapToItem
                        Layout.minimumHeight: 200
                        Layout.maximumHeight: 215
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        orientation: ListView.Horizontal
                        Layout.columnSpan: 3
                        spacing: 15

                        ScrollBar.horizontal: ScrollBar {
                            active: true
                            onActiveChanged: {
                                if (!active)
                                    active = true
                            }
                        }

                        delegate: Item {
                            height: 200
                            width: 400

                            Row {
                                spacing: 10

                                Image {
                                    source: scrshpath
                                    height: 200
                                    width: 400
                                }
                            }
                        }
                        model: ListModel {}
                    }
                    TextArea {
                        id: txt_description
                        font.pointSize: 10
                        renderType: Text.NativeRendering
                        verticalAlignment: Text.AlignTop
                        wrapMode: Text.WordWrap
                        Layout.minimumHeight: 250
                        Layout.minimumWidth: 1
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.columnSpan: 3
                        enabled: false
                        color: "#182645"
                    }
                }
            }
        }
    }
}








/*##^## Designer {
    D{i:7;anchors_height:40;anchors_width:40}D{i:4;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}
D{i:19;anchors_height:40;anchors_x:5}D{i:18;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}
D{i:15;anchors_height:160;anchors_width:110;anchors_x:0;anchors_y:0}D{i:13;anchors_height:40;anchors_width:40}
D{i:27;anchors_height:100;anchors_width:100}D{i:28;anchors_height:100;anchors_width:100}
D{i:33;anchors_height:100;anchors_width:100}D{i:31;anchors_height:100;anchors_width:100}
D{i:34;anchors_height:100;anchors_width:100}D{i:30;anchors_height:100;anchors_width:100}
}
 ##^##*/
