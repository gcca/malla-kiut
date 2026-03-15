cmake_minimum_required(VERSION 4.2)

project(malla-kiut VERSION 0.1 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Sql)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(malla-kiut
    main.cc
    db/database_manager.h
    db/database_manager.cc
    db/table_model.h
    db/table_model.cc
)

qt_add_qml_module(malla-kiut
    URI MallaKiut
    VERSION 1.0
    QML_FILES
        main.qml
        components/LeftSidebar.qml
        components/TableGrid.qml
        components/ConnectionDialog.qml
)

target_link_libraries(malla-kiut PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Sql
)
