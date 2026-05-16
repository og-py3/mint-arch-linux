import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#0d1117"

    // ── Live Video Wallpaper ─────────────────────────────────────────────────
    MediaPlayer {
        id: bgPlayer
        source: "/usr/share/mint-arch/wallpapers/mintarch-live-wallpaper.mp4"
        loops: MediaPlayer.Infinite
        audioOutput: AudioOutput { volume: 0 }
        Component.onCompleted: bgPlayer.play()
    }

    VideoOutput {
        id: bgVideo
        anchors.fill: parent
        source: bgPlayer
        fillMode: VideoOutput.PreserveAspectCrop
    }

    // ── Dark overlay ─────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
    }

    // ── Frosted glass login card ─────────────────────────────────────────────
    Rectangle {
        id: loginCard
        anchors.centerIn: parent
        width: 420
        height: 500
        radius: 20
        color: Qt.rgba(0.05, 0.07, 0.10, 0.72)
        border.color: Qt.rgba(0.28, 0.80, 0.44, 0.35)
        border.width: 1

        layer.enabled: true
        layer.effect: null

        // Glow border effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: parent.radius + 1
            color: "transparent"
            border.color: Qt.rgba(0.28, 0.80, 0.44, 0.15)
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 16

            // Logo
            Image {
                Layout.alignment: Qt.AlignHCenter
                source: "/usr/share/pixmaps/mintarch-logo.png"
                width: 72
                height: 72
                fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: 72
                Layout.preferredHeight: 72
            }

            // Distro name
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Mint Arch Linux"
                color: "#2ecb71"
                font.pixelSize: 22
                font.bold: true
                font.family: "JetBrains Mono"
            }

            // Subtitle
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Rolling · KDE Plasma 6 · BlackArch"
                color: "#8b9ab0"
                font.pixelSize: 11
                font.family: "JetBrains Mono"
            }

            // Spacer
            Item { Layout.preferredHeight: 8 }

            // Username field
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.07)
                border.color: userField.activeFocus ? "#2ecb71" : Qt.rgba(1,1,1,0.15)
                border.width: 1

                TextInput {
                    id: userField
                    anchors.fill: parent
                    anchors.margins: 12
                    color: "#e6edf3"
                    font.pixelSize: 14
                    font.family: "JetBrains Mono"
                    text: userModel.lastUser
                    verticalAlignment: TextInput.AlignVCenter
                    KeyNavigation.tab: passField
                    Keys.onReturnPressed: passField.forceActiveFocus()

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Username"
                        color: "#4a5568"
                        font: parent.font
                        visible: parent.text === ""
                    }
                }
            }

            // Password field
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.07)
                border.color: passField.activeFocus ? "#2ecb71" : Qt.rgba(1,1,1,0.15)
                border.width: 1

                TextInput {
                    id: passField
                    anchors.fill: parent
                    anchors.margins: 12
                    color: "#e6edf3"
                    font.pixelSize: 14
                    font.family: "JetBrains Mono"
                    echoMode: TextInput.Password
                    verticalAlignment: TextInput.AlignVCenter
                    KeyNavigation.tab: loginBtn
                    Keys.onReturnPressed: doLogin()

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Password"
                        color: "#4a5568"
                        font: parent.font
                        visible: parent.text === ""
                    }
                }
            }

            // Session selector
            ComboBox {
                id: sessionCombo
                Layout.fillWidth: true
                height: 36
                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex

                background: Rectangle {
                    radius: 8
                    color: Qt.rgba(1, 1, 1, 0.07)
                    border.color: Qt.rgba(1,1,1,0.15)
                    border.width: 1
                }

                contentItem: Text {
                    leftPadding: 12
                    text: sessionCombo.displayText
                    color: "#8b9ab0"
                    font.pixelSize: 12
                    font.family: "JetBrains Mono"
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Login button
            Rectangle {
                id: loginBtn
                Layout.fillWidth: true
                height: 44
                radius: 8
                color: loginMouse.containsMouse ? "#27ae5f" : "#2ecb71"
                opacity: loginMouse.containsPress ? 0.85 : 1.0

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "Sign In"
                    color: "#0d1117"
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "JetBrains Mono"
                }

                MouseArea {
                    id: loginMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: doLogin()
                }

                Keys.onReturnPressed: doLogin()
            }

            // Error message
            Text {
                id: errorMsg
                Layout.alignment: Qt.AlignHCenter
                text: ""
                color: "#ff6b6b"
                font.pixelSize: 11
                visible: text !== ""
            }

            // Bottom actions
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4

                Text {
                    text: Qt.formatDateTime(new Date(), "ddd d MMM · hh:mm")
                    color: "#4a5568"
                    font.pixelSize: 10
                    font.family: "JetBrains Mono"

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: parent.text = Qt.formatDateTime(new Date(), "ddd d MMM · hh:mm")
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "⏻"
                    color: "#4a5568"
                    font.pixelSize: 16
                    MouseArea {
                        anchors.fill: parent
                        onClicked: sddm.powerOff()
                    }
                }

                Text {
                    text: "↺"
                    color: "#4a5568"
                    font.pixelSize: 16
                    leftPadding: 12
                    MouseArea {
                        anchors.fill: parent
                        onClicked: sddm.reboot()
                    }
                }
            }
        }
    }

    function doLogin() {
        errorMsg.text = ""
        if (userField.text === "") {
            errorMsg.text = "Please enter a username"
            return
        }
        sddm.login(userField.text, passField.text, sessionCombo.currentIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMsg.text = "Incorrect username or password"
            passField.text = ""
            passField.forceActiveFocus()
        }
    }

    Component.onCompleted: {
        if (userField.text === "") {
            userField.forceActiveFocus()
        } else {
            passField.forceActiveFocus()
        }
    }
}
