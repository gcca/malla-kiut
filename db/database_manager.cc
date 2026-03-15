#include "database_manager.h"

#include <QSqlError>
#include <QSqlQuery>
#include <QUrl>

static constexpr auto kConnName = "malla_kiut_conn";

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {}

QStringList DatabaseManager::tables() const { return m_tables; }

bool DatabaseManager::isConnected() const { return m_connected; }

QSqlDatabase DatabaseManager::database() const { return m_db; }

bool DatabaseManager::connectSQLite(const QUrl &fileUrl) {
  if (QSqlDatabase::contains(kConnName))
    QSqlDatabase::removeDatabase(kConnName);

  m_db = QSqlDatabase::addDatabase("QSQLITE", kConnName);
  m_db.setDatabaseName(fileUrl.toLocalFile());

  if (!m_db.open()) {
    emit errorOccurred(m_db.lastError().text());
    return false;
  }

  m_connected = true;
  emit connectedChanged();
  refreshTables();
  return true;
}

bool DatabaseManager::connectPostgres(const QString &host, int port,
                                      const QString &dbName,
                                      const QString &user,
                                      const QString &password) {
  if (!QSqlDatabase::isDriverAvailable("QPSQL")) {
    emit errorOccurred("PostgreSQL driver (QPSQL) not available");
    return false;
  }

  if (QSqlDatabase::contains(kConnName))
    QSqlDatabase::removeDatabase(kConnName);

  m_db = QSqlDatabase::addDatabase("QPSQL", kConnName);
  m_db.setHostName(host);
  m_db.setPort(port);
  m_db.setDatabaseName(dbName);
  m_db.setUserName(user);
  m_db.setPassword(password);

  if (!m_db.open()) {
    emit errorOccurred(m_db.lastError().text());
    return false;
  }

  m_connected = true;
  emit connectedChanged();
  refreshTables();
  return true;
}

void DatabaseManager::disconnect() {
  if (m_db.isOpen())
    m_db.close();
  if (QSqlDatabase::contains(kConnName))
    QSqlDatabase::removeDatabase(kConnName);

  m_connected = false;
  m_tables.clear();
  emit connectedChanged();
  emit tablesChanged();
}

void DatabaseManager::selectTable(const QString &tableName) {
  emit tableSelected(tableName);
}

void DatabaseManager::refreshTables() {
  m_tables = m_db.tables(QSql::Tables);
  emit tablesChanged();
}
