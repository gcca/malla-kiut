#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "db/database_manager.h"
#include "db/table_model.h"

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  QQuickStyle::setStyle(u"Basic"_s);

  DatabaseManager db;
  TableModel tableData;

  QObject::connect(&db, &DatabaseManager::tableSelected, &tableData,
                   [&tableData, &db](const QString &tableName) {
                     tableData.setTable(tableName, db.database());
                   });

  QQmlApplicationEngine engine;

  engine.rootContext()->setContextProperty(u"Database"_s, &db);
  engine.rootContext()->setContextProperty(u"TableData"_s, &tableData);

  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
      []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);

  engine.load(u"qrc:/qt/qml/MallaKiut/main.qml"_s);

  return app.exec();
}
