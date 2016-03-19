import QtQuick 2.1
import Sailfish.Silica 1.0
import "../localdb.js" as DB
import "Vars.js" as GlobVars

Page {
    id: dishPage
    allowedOrientations: mainapp.orientationSetting

    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge

    function appendDish(dish, duration, comment) {
        dishlist.model.append({
                                  Dish: dish,
                                  Duration: duration,
                                  Comment: comment
                              })
    }

    SilicaListView {
        id: dishlist
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.topMargin: 40
        VerticalScrollDecorator {
        }
        model: ListModel {
        }

        function loadDishList() {
            // wipeTaskList()
            DB.readDishes()
        }

        Component.onCompleted: {
            GlobVars.myDuration = " "
            loadDishList()
        }
        delegate: ListItem {
            id: listItem
            //         menu: contextMenu
            contentHeight: Theme.itemSizeMedium // two line delegate
            function setDish() {
                if (GlobVars.myCurrentTimer === 1) {
                    mainapp.dishText1 = Dish
                }
                if (GlobVars.myCurrentTimer === 2) {
                    mainapp.dishText2 = Dish
                }
                if (GlobVars.myCurrentTimer === 3) {
                    mainapp.dishText3 = Dish
                }
                GlobVars.myDish = Dish
                GlobVars.myDuration = Duration
                GlobVars.myComment = Comment
                pageStack.pop()
            }
            Item { // background element with diagonal gradient
                anchors.fill: parent
                clip: true
                Rectangle {
                    rotation: isPortrait ? (largeScreen ? parent.width/260 : parent.width/60) : 5
                    height: parent.height
                    x: -dishlist.width
                    width: dishlist.width*2

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.rgba(Theme.primaryColor, 0) }
                        GradientStop { position: 1.0; color: Theme.rgba(Theme.primaryColor, 0.1) }
                    }
                }
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: label
                    anchors.bottom: sublabel.top
                    text: Dish
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: largeScreen ? Theme.fontSizeLarge : Theme.fontSizeMedium
                    font.bold: true
                    color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                Label {
                    id: sublabel
                    text: Duration
                    font.pixelSize: largeScreen ? Theme.fontSizeSmall : Theme.fontSizeExtraSmall
                    color: listItem.highlighted ? Theme.highlightColor : Theme.secondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            onClicked: {
                setDish()
            }
        }
        ViewPlaceholder {
            enabled: dishlist.count === 0
            text: qsTr("No dishes defined. Choose \"Edit Dishes\" from the pulley menu.")
        }
    }
}
