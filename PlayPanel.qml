import QtQuick 2.0
import QtQuick.Window 2.1
import QtMultimedia 5.0

Rectangle {
    id: root
    color: "black"

    property alias player: player;

    MediaPlayer {
        id: player
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors.fill: root
    }
}
