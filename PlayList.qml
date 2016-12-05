import QtQuick 2.0
import QtQuick.Window 2.1

Rectangle {
    id: playList
    width: 216; height: 62
    color: "#252525"

    property int itemHeight: 40
    property alias curIdx: grid.currentIndex
    signal activated(string text)

    function next() {
        if (grid.count > 0)
            grid.currentIndex = grid.currentIndex >= grid.count - 1 ? 0 : grid.currentIndex + 1;
    }

    function perv() {
        if (grid.count > 0)
            grid.currentIndex = grid.currentIndex > 0 ? grid.currentIndex - 1 : grid.count-1;
    }

    Rectangle {
        id: titleRect
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right;
        height: 50; color: "#3A3A3A";
        Text { x: 10; anchors.verticalCenter: parent.verticalCenter; text: titleName; color: "white"; font {pixelSize: 20; bold: true;} }
    }

    Rectangle {
        id: tipRect; height:25; color: "#3A3A3A"
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.left: parent.left
        Text { id:txtTip; anchors.fill: parent; anchors.leftMargin: 10; color: "white"; verticalAlignment: Text.AlignVCenter; font {pixelSize: 12}}
    }

    GridView {
        id: grid
        anchors.top: titleRect.bottom; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: tipRect.top
        anchors.margins: 10; cellWidth: itemHeight-1; cellHeight: itemHeight-1; clip: true
        currentIndex: -1

        model: playListModel

        delegate: Column {
            Rectangle {
                id: item; width: itemHeight; height: itemHeight; color: grid.currentIndex == index ? "#633517" : "#252525"; border.color: "#3A3A3A"
                onColorChanged: { if (color == "#633517") playList.activated(modelData);}
                Rectangle {id: overItem; anchors.fill: parent; color: "#00000000"}
                Text { text: ""+(index+1); anchors.centerIn: parent; color: "white"; font {pixelSize: 20; bold: true} }
                MouseArea { anchors.fill: parent; onClicked: grid.currentIndex = index; hoverEnabled: true; onExited: { overItem.color = "#00000000"; txtTip.text = "" } onEntered: {overItem.color = "#50808080"; txtTip.text = CtoOpts.fileName(modelData); } }
            }
        }
    }
}
