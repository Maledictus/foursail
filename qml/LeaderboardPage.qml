import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page


    property alias m: listmodel
    property bool loading;
    property string last_error;

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        spacing: Theme.paddingMedium;

        header: PageHeader {
            //% "Leaderboard"
            title: qsTrId("leaderboard-title")
        }

        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            //% "Leaderboard is empty"
            text: (last_error !== "") ? last_error : qsTrId("leaderboard-empty")
        }

        delegate: BackgroundItem {
            id: delegate

            height: Math.max(personPhoto.height, infoColumn.height)

            Image {
                id: personPhotoPlaceHolder
                source: "./images/blank_boy.png"
                width: 86;
                height: 86;
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingMedium
                visible: (personPhoto.status !== Image.Ready)
            }


            Image {
                id: personPhoto
                source: photo
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingMedium
                width: 86;
                height: 86;
            }

            Column {
                id: infoColumn
                anchors.left: personPhoto.right
                anchors.right: scoresLabel.left
                anchors.verticalCenter: personPhoto.verticalCenter
                anchors.margins: Theme.paddingMedium

                spacing: Theme.paddingSmall

                Label {
                    id: personNameLabel
                    text: name
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                }

                Label {
                    id: infoLabel
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    //% "%n checkins"
                    text: qsTrId("leaderboard-n-checkins", checkins_count);
                }
            }

            Label {
                id: scoresLabel
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Theme.paddingMedium
                color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeMedium
                text: score_recent
            }

            onClicked: console.log ("Show friend profile " + uid)
        }

        VerticalScrollDecorator {}

    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }

}





