import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: root
    height: col.height; color: "#202020"; //border.color: "#101010"; border.width: 2

    property bool paused: false
    property int btnSize: 28
    property int curVal: 0
    property alias maxVal: sdrPos.maximumValue;

    signal clicked(int idx)
    signal moved(int idx)
    signal volumeChanged(int val)

    FontLoader { id: icnFont; source: "qrc:/font/FontAwesome.otf" }

    function setPos(val) {
        curVal = val;
        sdrPos.value = val;
        txtCurTime.text = CtoOpts.fmtTime(val)
    }

    Column {
        id: col
        // 进度条
        Rectangle {
            width: root.width; height: 20; color: "#303030";

            Text {id: txtCurTime; text: "00:00:00"; anchors.left: parent.left; anchors.leftMargin: 5; anchors.verticalCenter: parent.verticalCenter; color: "white"; font {pixelSize: 10} }

            Text {id: txtTotalTime; text: "00:00:00"; anchors.right: parent.right; anchors.rightMargin: 5; anchors.verticalCenter: parent.verticalCenter; color: "white"; font {pixelSize: 10} }

            Slider {id: sdrPos; anchors.left: txtCurTime.right; anchors.verticalCenter: parent.verticalCenter; anchors.right: txtTotalTime.left; anchors.leftMargin: 5; anchors.rightMargin: 5;
                    onValueChanged: {
                        if (curVal-value >= 5 || value - curVal >= 5) {
                            txtCurTime.text = CtoOpts.fmtTime(value);
                            root.moved(value*1000);
                        }
                    }
                    onMaximumValueChanged: {txtTotalTime.text = CtoOpts.fmtTime(maximumValue)}
            }
        }

        // 按钮
        Item {
            id: bottomRect
            width: root.width; height: 40;

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left; anchors.leftMargin: 5
                height: btnSize; spacing: 12

                Repeater {
                    model: ListModel {
                        ListElement { name: "\uf04a" }
                        ListElement { name: "\uf04b" }
                        ListElement { name: "\uf04d" }
                        ListElement { name: "\uf04e" }
                    }
                    Button {
                        width: btnSize+6; height: btnSize
                        onClicked: root.clicked(index)
                        style: ButtonStyle {
                            background: Rectangle {
                                width: btnSize+6; height: btnSize
                                x: control.pressed ? 1 : 0; y: control.pressed ? 1 : 0;
                                radius: 5
                                gradient: Gradient {
                                    GradientStop { position: 0 ; color: control.pressed ? "#575757" : control.hovered ? "#757575" : "#888" }
                                    GradientStop { position: 1 ; color: control.pressed ? "#888" : control.hovered ? "#4b4b4b" : "#575757" }
                                }
                                Text {text: index == 1 ? (paused ? "\uf04c" : name) : name; anchors.centerIn: parent; color: "white"; font {family: icnFont.name; pixelSize: 16} }
                            }
                        }
                    }
                } // end of repeater
            }

            Button {
                width: btnSize+6; height: btnSize
                anchors.right: parent.right; anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.clicked(5)

                style: ButtonStyle {
                    background: Rectangle {
                        width: btnSize+6; height: btnSize
                        x: control.pressed ? 1 : 0; y: control.pressed ? 1 : 0;
                        radius: 5
                        gradient: Gradient {
                            GradientStop { position: 0 ; color: control.pressed ? "#575757" : control.hovered ? "#757575" : "#888" }
                            GradientStop { position: 1 ; color: control.pressed ? "#888" : control.hovered ? "#4b4b4b" : "#575757" }
                        }
                        Text {text: "\uf03a"; anchors.centerIn: parent; color: "white"; font {family: icnFont.name; pixelSize: 16} }
                    }
                }
            }

            // 声音
            Slider { id: sdrVom; width: 100; maximumValue: 100; value: 50; anchors.right: parent.right; anchors.rightMargin: 55; anchors.verticalCenter: parent.verticalCenter;
                   onValueChanged: root.volumeChanged(value); }
            Text {text: "\uf028"; anchors.right: parent.right; anchors.rightMargin: 160; anchors.verticalCenter: parent.verticalCenter; color: "white"; font {family: icnFont.name; pixelSize: 16} }
        }
    }
}
