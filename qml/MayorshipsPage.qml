import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property alias m: listmodel
    property bool loading;
    property string last_error;
    property string listName;

    signal checkinDetail(string venue_id, string name, string address, url icon, double lat, double lon);


    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        spacing: Theme.paddingMedium;

        header: PageHeader {
            //% "Mayorships"
            title: qsTrId("mayorships-title")
        }

        ViewPlaceholder {
            enabled: !loading && (listmodel.count === 0)
            //% "User hasn't got any mayorships yet"
            text: (last_error !== "") ? last_error : qsTrId("mayorships-empty")
        }

        delegate: BackgroundItem {
            id: delegate

            width: parent.width
            height: Math.max(venue_icon_image.height, venue_details_column.height)

            Image {
                id: venue_icon_image
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: Theme.paddingMedium
                anchors.leftMargin: Theme.paddingMedium;
                width: 64;
                height: 64;
                source: (venueIcon.prefix + width + venueIcon.suffix)
            }

            Column {
                id: venue_details_column
                anchors.left: venue_icon_image.right
                anchors.right: parent.right
                anchors.margins: Theme.paddingMedium;
                spacing: Theme.paddingSmall

                Label {
                    id: venue_name_label
                    anchors.left: parent.left
                    anchors.right: parent.right

                    wrapMode: Text.Wrap
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium

                    text: venueName
                }

                Label {
                    id: venue_address_label
                    anchors.left: parent.left
                    anchors.right: parent.right

                    wrapMode: Text.Wrap
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall

                    text: address
                }
            }


            onClicked: {
                checkinDetail(vid, venueName, address, venueIcon.prefix+"64"+venueIcon.suffix, lat, lon)

            }

        }


        VerticalScrollDecorator {}
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }


}





