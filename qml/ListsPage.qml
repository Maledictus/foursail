import QtQuick 2.0
import Sailfish.Silica 1.0
import "functions.js" as F

Page {
    id: page

    property alias m: listmodel
    property bool loading;

    signal switchToAddAndEditList(string lid, string name, string description)
    signal switchToListDetailPage(string lid, string listName)

    ListModel {
        id: listmodel;
    }

    SilicaListView {
        id: listView
        model: listmodel
        anchors.fill: parent
        spacing: Theme.paddingMedium

        property Item contextMenu

        PullDownMenu {
            MenuItem {
                text: qsTr("New list")
                onClicked: switchToAddAndEditList("", "", "")
            }
        }

        header: PageHeader {
            title: qsTr("Lists")
        }

        delegate: Item {
            id: myListItem
            property bool menuOpen: listView.contextMenu != null && listView.contextMenu.parent === myListItem

            width: ListView.view.width
            height: menuOpen ? listView.contextMenu.height + contentItem.height : contentItem.height


            BackgroundItem {
                id: contentItem

                width: parent.width
                height: nameLabel.height + descriptionLabel.height

                Label {
                    id: nameLabel

                    anchors.left: parent.left
                    anchors.right: itemsCountLabel.left
                    anchors.margins: Theme.paddingMedium

                    font.family: Theme.fontFamilyHeading
                    font.pixelSize:  Theme.fontSizeMedium
                    wrapMode: Text.Wrap

                    color: myListItem.highlighted ? Theme.highlightColor : Theme.primaryColor

                    text: name
                }

                Label {
                    id: descriptionLabel

                    anchors.left: parent.left
                    anchors.right: itemsCountLabel.left
                    anchors.top: nameLabel.bottom
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.rightMargin: Theme.paddingMedium

                    font.pixelSize:  Theme.fontSizeSmall
                    wrapMode: Text.Wrap

                    color: myListItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor

                    text: description
                }

                Label {
                    id: itemsCountLabel
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: Theme.paddingMedium
                    color: myListItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    text: count
                }

                onClicked: switchToListDetailPage(listId, name)

                onPressAndHold: {
                    if (!listView.contextMenu) {
                        listView.contextMenu = contextMenuComponent.createObject(listView)
                    }
                    listView.contextMenu.listId = model.listId;
                    listView.contextMenu.name = model.name;
                    listView.contextMenu.description = model.description;

                    listView.contextMenu.show(myListItem)
                }
            }
        }

        VerticalScrollDecorator {}

        Component {
            id: contextMenuComponent
            ContextMenu {
                property string listId;
                property string name;
                property string description;
                MenuItem {
                    text: qsTr ("Edit");
                    onClicked: switchToAddAndEditList(listId, name, description)
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent;
        visible: loading && (listmodel.count === 0)
        running: visible;
    }

    Label {
        anchors.centerIn: parent;
        visible: !loading && (listmodel.count === 0)
        text: qsTr("Offline")
    }

}




