import os
import sys
from functools import partial
from PySide2 import QtCore, QtGui, QtQml

### NOTES

#   PoC created by Simon Gruber (h45h74x) -> http://simongruber.eu.org
#
#   I had to sudo pip install PySide2 to get this running
#   Edit Layout Constraints in 'mainwindow.qml' (e.g. Screenshot Image Size)
#   HiDPI Scaling is not yet implemented
#
#   Use the provided hooks to offer your content to the GUI
#   'Controlpanel.start()' loads all needed contents and opens the window
#   Content is loaded as-needed when selecting ListEntries

### NOTES END
### HOOKS

def startSelectedEntry(moduleindex, entryindex, advancedstart):
    print(advancedstart)

def fetchModules():
    modules = [
        Entry("Vim", "res/vim-icon.png").toQML(),
        Entry("Photoshop", "res/ps-icon.png").toQML(),
        Entry("Fusion 360", "res/fusion-icon.png").toQML()
    ]
    return modules

def fetchEntryList(moduleindex):
    switcher = {
            0: [
                Entry("Getting Started", "").toQML(),
                Entry("Setting Views", "").toQML(),
                Entry("The First Rage", "").toQML()
            ],
            1: [
                Entry("Layers", "").toQML(),
                Entry("Masks", "").toQML(),
                Entry("Camera Raw", "").toQML(),
                Entry("Fine Tuning", "").toQML()
            ],
            2: [
                Entry("Navigation", "").toQML(),
                Entry("Your first extrusion", "").toQML()
            ]
        }
    return switcher.get(moduleindex)

def fetchEntryField(moduleindex, entryindex, field):
    if field == "description":
        if moduleindex == 0:
            switcher = {
                0: "Vim is great",
                1: "Vim desc 2",
                2: "Vim desc 3"
            }
            return switcher.get(entryindex)
        elif moduleindex == 1:
            switcher = {
                0: "Photoshop is amazing",
                1: "Ps desc 2",
                2: "Ps desc 3",
                3: "Ps desc 4"
            }
            return switcher.get(entryindex)
        elif moduleindex == 2:
            switcher = {
                0: "I love CAD",
                1: "Fusion desc 2"
            }
            return switcher.get(entryindex)

    if field == "screenshots":
        if moduleindex == 0:
            switcher = {
                0: [{"scrshpath":"res/screenshots/vim_01.png"}, {"scrshpath":"res/screenshots/vim_02.png"}],
                1: [{"scrshpath":"res/screenshots/vim_03.png"}, {"scrshpath":"res/screenshots/vim_04.png"}],
                2: [{"scrshpath":"res/screenshots/vim_05.png"}, {"scrshpath":"res/screenshots/vim_06.png"}]
            }
            return switcher.get(entryindex)
        elif moduleindex == 1:
            switcher = {
                0: [{"scrshpath":"res/screenshots/vim_01.png"}, {"scrshpath":"res/screenshots/vim_02.png"}],
                1: [{"scrshpath":"res/screenshots/vim_03.png"}, {"scrshpath":"res/screenshots/vim_04.png"}],
                2: [{"scrshpath":"res/screenshots/vim_05.png"}, {"scrshpath":"res/screenshots/vim_06.png"}],
                3: [{"scrshpath":"res/screenshots/vim_05.png"}, {"scrshpath":"res/screenshots/vim_06.png"}]
            }
            return switcher.get(entryindex)
        elif moduleindex == 2:
            switcher = {
                0: [{"scrshpath":"res/screenshots/vim_05.png"}, {"scrshpath":"res/screenshots/vim_06.png"}],
                1: [{"scrshpath":"res/screenshots/vim_05.png"}, {"scrshpath":"res/screenshots/vim_06.png"}]
            }
        return switcher.get(entryindex)

    return None


def startEntry(moduleindex, entryindex, advancedstart):
    print("Starting nooooowwww!!!!!!!")


### HOOKS END

class Model(QtCore.QAbstractListModel):
    NameRole = QtCore.Qt.UserRole + 1000
    IconRole = QtCore.Qt.UserRole + 1001
    ScrShRole = QtCore.Qt.UserRole + 1002

    def __init__(self, entries, parent=None):
        super(Model, self).__init__(parent)
        self._entries = entries

    def rowCount(self, parent=QtCore.QModelIndex()):
        if parent.isValid():
            return 0
        if self._entries == None:
            return 0
        return len(self._entries)

    def data(self, index, role=QtCore.Qt.DisplayRole):
        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._entries[index.row()]
            if role == Model.NameRole:
                return item["name"]
            elif role == Model.IconRole:
                return item["appicon"]
            elif role == Model.ScrShRole:
                return item["scrshpath"]

    def roleNames(self):
        roles = dict()
        roles[Model.NameRole] = b"name"
        roles[Model.IconRole] = b"appicon"
        roles[Model.ScrShRole] = b"scrshpath"
        return roles

    def appendRow(self, n, a, s):
        self.beginInsertRows(QtCore.QModelIndex(), self.rowCount(), self.rowCount())
        self._entries.append(dict(name=n, appicon=a, scrshpath=s))
        self.endInsertRows()

class Handler(QtCore.QObject):
    def __init__(self, modules, parent=None):
        super(Handler, self).__init__(parent)
        self.modules = modules

    @QtCore.Slot(int, int, int)
    def btclick_start(self, moduleindex, entryindex, advancedstart):
        startSelectedEntry(moduleindex, entryindex, advancedstart)

    @QtCore.Slot(int, str, result=str)
    def getModuleFieldById(self, moduleindex, field):
        return self.modules[moduleindex].get(field)

    @QtCore.Slot(int, int, str, result=str)
    def getEntryFieldById(self, moduleindex, entryindex, field):

        dbResult = fetchEntryField(moduleindex, entryindex, field)
        if dbResult == None:
            return fetchEntryList(moduleindex)[entryindex].get(field)
        else:
            return dbResult

    @QtCore.Property(QtCore.QObject, constant=True)
    def getModules(self):
        self._mmodules = Model(self.modules)
        return self._mmodules

    @QtCore.Slot(int, result=QtCore.QObject)
    def getEntries(self, index):
        self._mentries = Model(fetchEntryList(index))
        return self._mentries

    @QtCore.Slot(int, int, result=QtCore.QObject)
    def getEntryScreenshots(self, moduleindex, entryindex):
        self._mscreenshots = Model(fetchEntryField(moduleindex, entryindex, "screenshots"))
        return self._mscreenshots

class Entry():
    Name = "Entry"
    IconPath = ""

    def __init__(self, name, iconpath):
        self.Name = name
        self.IconPath = iconpath

    def toQML(self):
        return {"name":self.Name, "appicon":self.IconPath}


class Controlpanel():
    def start():
        QtGui.QGuiApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling, True)
        app = QtGui.QGuiApplication(sys.argv)

        engine = QtQml.QQmlApplicationEngine()

        context = engine.rootContext()
        handler = Handler(fetchModules())
        context.setContextProperty("handler", handler)

        engine.load(QtCore.QUrl.fromLocalFile(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'mainwindow.qml')))

        if not engine.rootObjects():
            return -1
        return app.exec_()

Controlpanel.start()
