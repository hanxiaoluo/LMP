import QtQuick 2.2
import QtQuick.Window 2.1
import QtMultimedia 5.0

Window {
    id: win
    visible: true
    width: 660
    height: 400
    //color: "#252525"

    Component.onCompleted: {
        playList.activated.connect(play)
        playCtrl.clicked.connect(onCtrl)
        playCtrl.moved.connect(playPanel.player.seek)
        playCtrl.volumeChanged.connect(setVolume)
        win.closing.connect(save)
        playPanel.player.volume = 0.5
    }

    function setVolume(val) {
        playPanel.player.volume = val/100.0
    }

    function save(val) {
        CtoOpts.saveData(playList.curIdx, playPanel.player.position/1000)
    }

    function playBack(idx, pos) {
        if (idx === -1 || pos === -1)
            return
        playList.curIdx = idx;
        playPanel.player.seek(pos*1000)
    }

    function playIdx(idx) {
        if (idx !== -1)
            playList.curIdx = idx;
    }

    function play(text) {
        playPanel.player.stop()
        playPanel.player.source = "";
        playPanel.player.source = text
        win.title = CtoOpts.fileName(text)
        playPanel.player.play()

        playCtrl.maxVal = 0
        playCtrl.setPos(0)
        playCtrl.paused = true

        if (!countDown.running)
            countDown.start()
    }

    function onCtrl(idx) {
        if (idx === 0)
            playList.perv()
        else if (idx === 1) {
            if (playPanel.player.source == "")
                return
            playCtrl.paused = !playCtrl.paused;
            if (playCtrl.paused) {
                playPanel.player.play()
                countDown.start()
            }
            else {
                playPanel.player.pause()
                countDown.stop()
            }
        }
        else if (idx === 2) {
            playPanel.player.stop()
            var tem = playPanel.player.source
            playPanel.player.source = "";
            playPanel.player.source = tem

            countDown.stop()

            playCtrl.paused = false
            playCtrl.maxVal = 0
            playCtrl.setPos(0)
        }
        else if (idx === 3)
            playList.next()
        else if (idx === 5)
            playList.width = playList.width ? 0 : 216
    }

    PlayList {
        id: playList
        anchors.top: parent.top; anchors.right: parent.right; anchors.bottom: parent.bottom;
    }

    PlayPanel {
        id: playPanel
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: playList.left; anchors.bottom: parent.bottom //playCtrl.top
        anchors.bottomMargin: 60
        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: onCtrl(1)
            onDoubleClicked: {
                if (playList.width == 216) {
                    playList.width = 0;
                    playCtrl.visible = false;
                    playPanel.anchors.bottomMargin = 0;
                    showFullScreen();
                    hoverEnabled = true;
                }
                else {
                    playList.width = 216;
                    playPanel.anchors.bottomMargin = 60;
                    playCtrl.visible = true;
                    hoverEnabled = false;
                    showNormal();
                }
            }

            onPositionChanged: {
                console.log(mouse.y)
                if (playPanel.anchors.bottomMargin == 0)
                    playCtrl.visible = mouse.y > playPanel.height - 60;
            }
        }
    }

    PlayCtrl {
        id: playCtrl
        anchors.left: parent.left; anchors.right: playList.left; anchors.bottom: parent.bottom
        focus: true
        Keys.enabled: true;
        Keys.onPressed: {
            if (event.key === Qt.Key_Right)
                playPanel.player.seek(playPanel.player.position + 30000);
            else if (event.key === Qt.Key_Left)
                playPanel.player.seek(playPanel.player.position - 30000);
            else if (event.key === Qt.Key_Space)
                onCtrl(1)
        }
    }

    DropArea {
        anchors.fill: parent
        onDropped: CtoOpts.createPlayList(drop.urls)
    }

    Timer {
        id:countDown;
        interval: 1000;
        repeat: true;

        onTriggered: {
            if (playCtrl.maxVal == 0)
                playCtrl.maxVal = playPanel.player.duration / 1000
            else if (playCtrl.maxVal-1 <= playCtrl.curVal)
                playList.next()
            playCtrl.setPos(playPanel.player.position/1000)
        }
    }
}
